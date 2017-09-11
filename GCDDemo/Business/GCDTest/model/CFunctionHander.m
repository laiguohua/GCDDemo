//
//  CFunctionHander.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "CFunctionHander.h"

//C函数的位置可以放在任意位置,但不可超出import
void cMethodTest(void){
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"输出1");
        
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"输出2");
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"输出3");
    }];
    
    [op1 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    
    [op2 addExecutionBlock:^{
        NSLog(@"新添加方法");
    }];
    
}

@implementation CFunctionHander

- (void)cMethodTest{
    //调用C方法
    cMethodTest();
}


@end
