//
//  LNHttpManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNHttpManager.h"
#import "MBManager.h"

@interface LNHttpManager()

@property (nonatomic,strong)NSLock *lock;
@property (nonatomic,strong)NSMutableDictionary *signDic;

@end

@implementation LNHttpManager

+ (LNHttpManager *)shareManage{
    static LNHttpManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LNHttpManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.douban.com/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10.0;
        
        manager.lock = [[NSLock alloc] init];
        
    });
    return manager;
}

- (NSMutableDictionary *)signDic{
    if(!_signDic){
        _signDic = [NSMutableDictionary dictionary];
    }
    return _signDic;
}
- (NSURLSessionTask *)post:(NSString *)interfacing parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self post:interfacing parameter:parameter hudType:HUD_notShow progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)get:(NSString *)interfacing parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self get:interfacing parameter:parameter hudType:HUD_notShow progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)postWithHud:(NSString *)interfacing parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self post:interfacing parameter:parameter hudType:HUD_showAndCompleHidden progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)getWithHud:(NSString *)interfacing parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self get:interfacing parameter:parameter hudType:HUD_showAndCompleHidden progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)post:(NSString *)interfacing parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    
    NSURLSessionTask *atask = [self POST:interfacing parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handHUDwithTask:task message:@"success" code:0];
        if(success){
            success(0,responseObject,@"success");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handHUDwithTask:task message:@"failure" code:-1];
        if(failure){
            failure(-1,nil,@"failure");
        }
    }];
    if(ahudType != HUD_notShow){
        [MBManager showHUDMessage:@"loading..."];
        [self.lock lock];
        [self.signDic setObject:@(ahudType) forKey:@(atask.taskIdentifier)];
        [self.lock unlock];
    }
    return atask;
}

- (NSURLSessionTask *)get:(NSString *)interfacing parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    
    NSURLSessionTask *atask = [self GET:interfacing parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handHUDwithTask:task message:@"success" code:0];
        if(success){
            success(0,responseObject,@"success");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handHUDwithTask:task message:@"failure" code:-1];
        if(failure){
            failure(-1,nil,@"failure");
        }
    }];
    if(ahudType != HUD_notShow){
        [MBManager showHUDMessage:@"loading..."];
        [self.lock lock];
        [self.signDic setObject:@(ahudType) forKey:@(atask.taskIdentifier)];
        [self.lock unlock];
    }
    return atask;
}

- (void)handHUDwithTask:(NSURLSessionTask *)task message:(NSString *)message code:(NSInteger)code{
    if(!task) return;
    [self.lock lock];
    HUDTYPE type = [[self.signDic objectForKey:@(task.taskIdentifier)] integerValue];
    [self.signDic removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
    if(type == HUD_notShow) return;
    if(type & HUD_showAndCompleHidden){
        [MBManager hiddenHUD];
    }
    if(type & HUD_showAndCompleShowFailureMessage){
        [MBManager showHUDWithMessage:message];
    }
    if(type & HUD_showAndCompleShowSuccessMessage){
        [MBManager showHUDWithMessage:message];
    }
}

- (void)cancelAllTask{
    for(NSURLSessionTask *task in self.tasks){
        if(task.state == NSURLSessionTaskStateSuspended || task.state == NSURLSessionTaskStateRunning){
            [task cancel];
        }
    }
}


@end
