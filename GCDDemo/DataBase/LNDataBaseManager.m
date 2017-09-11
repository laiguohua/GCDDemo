//
//  LNDataBaseManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNDataBaseManager.h"

@implementation LNDataBaseManager

+ (LNDataBaseManager *)shareManager{
    static LNDataBaseManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LNDataBaseManager alloc] init];
        
    });
    return manager;
}

@end
