//
//  LNNetLoadViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNNetLoadViewController.h"
#import "MBManager.h"
#import "LNHttpManager.h"
#import "UINavigationController+DirectPop.h"

@implementation testModel


@end

@interface LNNetLoadViewController ()

@end

@implementation LNNetLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NETWORK";
    
    NSArray *arr = @[@"加载网络",@"提示一条信息(默认3秒消失)",@"提示一条信息,消失后回调回来"];
    for(int i=0;i<arr.count;i++){
        UIButton *btn = [UIButton new];
        btn.tag = 200+i;
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
        case 200:
        {
            [self searchTest];
            return;
            //测试
            [self.navigationController directTopControllerPop];
            
            return;
            
            [self startNetWork];
        }
            break;
        case 201:
        {
            [self showMessage:sender.currentTitle callBack:NO];
        }
            break;
        case 202:
        {
            [self showMessage:sender.currentTitle callBack:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)searchTest{
    NSMutableArray *muArr = [NSMutableArray array];
    for(int i = 0;i<10;i++){
        testModel *model = [testModel new];
        model.myId = i+1;
        model.name = [NSString stringWithFormat:@"name %d",i+1];
        [muArr addObject:model];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myId == %ld",5];
    NSArray *arr = [muArr filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",arr);
}

#pragma mark - method
- (void)startNetWork{
    //网络请求，不需要关心显示加载，传不同的枚举即可，如果需要自己控制，则传HUD_notShow
    [[LNHttpManager shareManager] get:@"v2/book/1220562" parameter:nil hudType:HUD_showAndCompleHidden progress:nil success:^(NSInteger code, id response, NSString *message) {
        
    } failure:^(NSInteger code, id response, NSString *message) {
        
    }];
}

- (void)showMessage:(NSString *)message callBack:(BOOL)callBack{

    if(callBack){
        [MBManager showHUDWithMessage:message comple:^{
            NSLog(@"回调回来这里");
        }];
    }else{
        [MBManager showHUDWithMessage:message comple:nil];
    }
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
