//
//  GCDHander.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "GCDHander.h"
#import "LNHttpManager.h"
#import "MBManager.h"

@implementation GCDHander

//采用dispatch_group_enter 和 dispatch_group_leave来控制线程同步
- (void)groupControl{
    
    [MBManager showHUD];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t myQueue = dispatch_queue_create("my.queue.lance", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, myQueue, ^{
        NSLog(@"执行任务1");
        //要执行同步任务，才能在完成之后调dispatch_group_notify，如果是异步则不行，如下代码，异步的话马上就会调dispatch_group_notify
        
        dispatch_group_enter(group);
        
        [[LNHttpManager shareManager] get:@"v2/book/1220562" parameter:nil progress:nil success:^(NSInteger code, id response, NSString *message) {
            dispatch_group_leave(group);
        } failure:^(NSInteger code, id response, NSString *message) {
            dispatch_group_leave(group);
        }];
        
    });
    dispatch_group_async(group, myQueue, ^{
        NSLog(@"执行任务2");
        
        dispatch_group_enter(group);
        
        [[LNHttpManager shareManager] get:@"v2/book/1220561" parameter:nil progress:nil success:^(NSInteger code, id response, NSString *message) {
            dispatch_group_leave(group);
        } failure:^(NSInteger code, id response, NSString *message) {
            dispatch_group_leave(group);
        }];
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"两个任务都完成了");
        [MBManager showHUDWithMessage:@"两个任务都完成了"];
    });
    //完成的通知方式二
    //dispatch_group_wait不能放到主线程中,因为它是同步的，放在子线程上
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //        NSLog(@"哈哈,完成了，我被执行了！");
    //    });
    
}

//采用信号量来控制线程同步
- (void)groupControlBySemaphore{
    
    [MBManager showHUD];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t myQueue = dispatch_queue_create("my.queue.lance", DISPATCH_QUEUE_CONCURRENT);
    //在一个组中，可以放到不同的队列上去
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, myQueue, ^{
        NSLog(@"执行任务1");
        //要执行同步任务，才能在完成之后调dispatch_group_notify，如果是异步则不行，如下代码，异步的话马上就会调dispatch_group_notify
        
        dispatch_semaphore_t semapore = dispatch_semaphore_create(0);
        
        [[LNHttpManager shareManager] get:@"v2/book/1220562" parameter:nil progress:nil success:^(NSInteger code, id response, NSString *message) {
            dispatch_semaphore_signal(semapore);
        } failure:^(NSInteger code, id response, NSString *message) {
            dispatch_semaphore_signal(semapore);
        }];
        //一开始信号量为0，不能通过，会一直等待，然后完成请求之后会发送dispatch_semaphore_signal(sem); 这时候信号量+1，所以可以通过，完成这个线程任务
        dispatch_semaphore_wait(semapore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务1完成了");
        
    });
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行任务2");
        
        dispatch_semaphore_t semapore = dispatch_semaphore_create(0);
        
        [[LNHttpManager shareManager] get:@"v2/book/1220561" parameter:nil progress:nil success:^(NSInteger code, id response, NSString *message) {
            dispatch_semaphore_signal(semapore);
        } failure:^(NSInteger code, id response, NSString *message) {
            dispatch_semaphore_signal(semapore);
        }];
        //一开始信号量为0，不能通过，会一直等待，然后完成请求之后会发送dispatch_semaphore_signal(sem); 这时候信号量+1，所以可以通过，完成这个线程任务
        dispatch_semaphore_wait(semapore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务2完成了");
        
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"两个任务都完成了");
        [MBManager showHUDWithMessage:@"两个任务都完成了"];
    });
    
    //完成的通知方式二
    //dispatch_group_wait不能放到主线程中,因为它是同步的，放在子线程上
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //        NSLog(@"哈哈,完成了，我被执行了！");
    //    });
}

@end
