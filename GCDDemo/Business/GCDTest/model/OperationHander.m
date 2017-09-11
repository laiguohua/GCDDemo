//
//  OperationHander.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "OperationHander.h"

@implementation OperationHander

- (void)dependencyAndAddExecutionTest{

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务1");
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"任务1追加的任务");
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务2");
    }];
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(theOpreationTest) object:nil];
    
    
    //添加依赖关系
    [op1 addDependency:op3];
    [op1 addDependency:op2];
    
    //任务加入队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //追加新的任务
    [op2 addExecutionBlock:^{
        NSLog(@"任务2追加的任务");
    }];
    
}

- (void)theOpreationTest{
    NSLog(@"任务3");
}

@end
