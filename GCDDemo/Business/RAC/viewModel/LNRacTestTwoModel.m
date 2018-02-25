//
//  LNRacTestTwoModel.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/20.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNRacTestTwoModel.h"

@implementation LNRacTestTwoModel

- (void)loadData{
    for(int i=0;i<30;i++){
        [self.dataArr addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
}



- (RACCommand *)requestCommand{
    if(!_requestCommand){
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self loadData];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _requestCommand;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
