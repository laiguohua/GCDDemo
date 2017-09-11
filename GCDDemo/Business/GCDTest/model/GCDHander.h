//
//  GCDHander.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDHander : NSObject

//采用dispatch_group_enter 和 dispatch_group_leave来控制线程同步
- (void)groupControl;

//采用信号量来控制线程同步
- (void)groupControlBySemaphore;

@end
