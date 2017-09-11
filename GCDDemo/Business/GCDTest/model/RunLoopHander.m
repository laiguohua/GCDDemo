//
//  RunLoopHander.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "RunLoopHander.h"

@interface RunLoopHander()

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation RunLoopHander

- (void)dealloc{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

//runloop 在定时器中的使用
- (void)runloopTestWithTimer{
    //启动一个子线程
    NSThread *athread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTestMethod) object:nil];
    [athread start];
    
}

- (void)threadTestMethod{
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
        
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printSomthing:) userInfo:nil repeats:YES];
    //在子线程中，必须要手动启动runloop，否则不会执行
    [[NSRunLoop currentRunLoop] run];
    //repeats:YES 以下都不会执行，如果是为NO，则会执行
    NSLog(@"启动runloop之后，这里是不会执行的，因为runloop一直在运行，想象一下while(1),当线程销毁了之后才会执行");
}

- (void)printSomthing:(NSTimer *)sender{
    NSLog(@"定时器启动了");
}

@end
