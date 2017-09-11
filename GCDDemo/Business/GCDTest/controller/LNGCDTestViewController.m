//
//  LNGCDTestViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNGCDTestViewController.h"
#import "GCDHander.h"
#import "OperationHander.h"
#import "CFunctionHander.h"
#import "RunLoopHander.h"

@interface LNGCDTestViewController ()

@property (nonatomic,strong)GCDHander *agcdHander;
@property (nonatomic,strong)OperationHander *aoperation;
@property (nonatomic,strong)CFunctionHander *acFunction;
@property (nonatomic,strong)RunLoopHander *arunLoop;

@end

@implementation LNGCDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"GCD";
    
    NSArray *arr = @[@"GCD组同步方法1",@"GCD组同步方法2",@"operation",@"Runloop子线程",@"C函数"];
    for(int i=0;i<arr.count;i++){
        UIButton *btn = [UIButton new];
        btn.tag = 300+i;
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClikAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(80 * (i + 1));
            make.width.equalTo(@250);
            make.height.equalTo(@50);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    
}

- (void)buttonClikAction:(UIButton *)sender{
    switch (sender.tag) {
        case 300:
        {
            [self.agcdHander groupControl];
        }
            break;
        case 301:
        {
            [self.agcdHander groupControlBySemaphore];
        }
            break;
        case 302:
        {
            [self.aoperation dependencyAndAddExecutionTest];
        }
            break;
        case 303:
        {
            [self.arunLoop runloopTestWithTimer];
        }
            break;
        case 304:
        {
            [self.acFunction cMethodTest];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载
- (GCDHander *)agcdHander{
    if(!_agcdHander){
        _agcdHander = [[GCDHander alloc] init];
    }
    return _agcdHander;
}

- (OperationHander *)aoperation{
    if(!_aoperation){
        _aoperation = [[OperationHander alloc] init];
    }
    return _aoperation;
}
- (CFunctionHander *)acFunction{
    if(!_acFunction){
        _acFunction = [[CFunctionHander alloc] init];
    }
    return _acFunction;
}

- (RunLoopHander *)arunLoop{
    if(!_arunLoop){
        _arunLoop = [[RunLoopHander alloc] init];
    }
    return _arunLoop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
