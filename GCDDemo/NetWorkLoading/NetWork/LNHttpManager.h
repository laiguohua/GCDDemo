//
//  LNHttpManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_OPTIONS(NSInteger,HUDTYPE){
    HUD_notShow                             = 0,
    HUD_showAndCompleHidden                 = 1 << 0,
    HUD_showAndCompleShowSuccessMessage     = 1 << 1,
    HUD_showAndCompleShowFailureMessage     = 1 << 2
};

typedef void(^netSuccessBlock)(NSInteger code ,id response ,NSString *message);

typedef void(^netFailureBlock)(NSInteger code ,id response ,NSString *message);

typedef void(^netProgressBlock)(NSProgress *uploadProgress);

@interface LNHttpManager : AFHTTPSessionManager

+ (LNHttpManager *)shareManage;

- (NSURLSessionTask *)post:(NSString *)interfacing parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)get:(NSString *)interfacing parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)postWithHud:(NSString *)interfacing parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)getWithHud:(NSString *)interfacing parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)post:(NSString *)interfacing parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)get:(NSString *)interfacing parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (void)cancelAllTask;

@end
