//
//  LAlbumViewModel.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LAlbumViewModel.h"

@implementation LAlbumViewModel

- (void)loadAlbumList{
    [self.dataArr removeAllObjects];
    NSArray *arr = [[LPhotoLibiraryManager defaultLPhotoLibiraryManager] getAllPhotoList];
    [arr enumerateObjectsUsingBlock:^(LNPhotoList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:[[LAlbumListModel alloc] initWithModel:obj]];
    }];
    [self.refreshUISubject sendNext:nil];
}

- (RACCommand *)photoCmmand{
    if(!_photoCmmand){
        _photoCmmand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [self loadAlbumList];
                [subscriber sendCompleted];
                return nil;
            }];
            
        }];
    }
    return _photoCmmand;
}

- (RACSubject *)refreshUISubject{
    if(!_refreshUISubject){
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
