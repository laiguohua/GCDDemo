//
//  LNRacTestViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/11.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNRacTestViewController.h"
#import "MBManager.h"
#import "LNStartViewController.h"
#import "LNRacTestTwoViewController.h"
#import "UINavigationController+DirectPop.h"

#import "LNAlbumListViewController.h"
#import "LNPhotoSmartViewController.h"

@interface LNRacTestViewController ()

@property (nonatomic,strong)UITextField *testTextField;
@property (nonatomic,strong)UIButton *logoinBtn;
@property (nonatomic,strong)RACSignal *aloginSignal;

@end

@implementation LNRacTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"RAC";
    
    //RAC经典的登录操作
    [self racLoginTest];
}

- (void)racLoginTest{
    
    //布局测试
//    UIScrollView *scrollview = [UIScrollView new];
//    scrollview.backgroundColor = [UIColor orangeColor];
//    UIView *aview = [UIView new];
//    aview.backgroundColor = [UIColor redColor];
//    
//    UIView *bgview = [UIView new];
//    bgview.backgroundColor = [UIColor cyanColor];
//    
//    UIButton *btn = [UIButton new];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitle:@"clik" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor redColor];
//    
//    [bgview addSubview:aview];
//    [scrollview addSubview:bgview];
//    [bgview addSubview:btn];
//    
//    [self.view addSubview:scrollview];
//    
//    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgview.mas_top);
//        make.left.equalTo(bgview.mas_left);
//        make.right.equalTo(bgview.mas_right);
//        make.height.equalTo(@150);
//        make.width.equalTo(bgview.mas_width);
//    }];
//    
//
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.greaterThanOrEqualTo(aview.mas_bottom).offset(20);
//        make.left.equalTo(bgview.mas_left).offset(24);
//        make.right.equalTo(bgview.mas_right).offset(-24);
//        make.bottom.equalTo(bgview.mas_bottom).priorityHigh();
//        make.height.equalTo(@40);
//    }];
//    
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - 49;
//    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollview);
//        make.width.equalTo(scrollview);
//        make.height.greaterThanOrEqualTo(@(height)).priorityHigh();
//    }];
//    
//    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//
//    }];
//    
//    
//    return;
    @weakify(self);
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"photo" forState:UIControlStateNormal];
    [[[button rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        LNAlbumListViewController *vc = [LNAlbumListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(70);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        make.centerX.equalTo(self.view.mas_centerX);

    }];
    
    [self.view addSubview:self.testTextField];
    [self.view addSubview:self.logoinBtn];
    [_testTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(50);
        make.right.equalTo(self.view.right).offset(-50);
        make.top.equalTo(self.view.top).offset(150);
        make.height.equalTo(@50);
        
    }];
    
    [_logoinBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(_testTextField.bottom).offset(20);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
    }];
    RACSignal *textFs = self.testTextField.rac_textSignal;
    RACSignal *reduce = [RACSignal combineLatest:@[textFs] reduce:^(NSString *signal1_Str){
        return @(signal1_Str.length > 4);
    }];
    
    RAC(self.logoinBtn,enabled) = reduce;
    
    
    [self.testTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输出%@",x);
    }];
    [[self.testTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"过滤后输出%@",x);
    }];
    
    [[[self.testTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }] filter:^BOOL(NSNumber * _Nullable value) {
        return value.integerValue > 3;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"类型转换后输出%@",x);
    }];
    
    
//    @weakify(self)
    [[[[[self.logoinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.logoinBtn.enabled = NO;
    }] flattenMap:^id _Nullable(__kindof UIControl * _Nullable value) {
        @strongify(self)
        return [self aloginSignal];
    }] throttle:.5] subscribeNext:^(NSNumber * x) {
        self.logoinBtn.enabled = YES;
        
        [MBManager showHUDWithMessage:[x boolValue]?@"登录成功":@"登录失败" comple:^{
//            LNStartViewController *startVC = [LNStartViewController new];
//            [self.navigationController pushViewController:startVC animated:YES];
            LNRacTestTwoViewController *racvc = [LNRacTestTwoViewController new];
            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
            [self.navigationController pushViewController:racvc animated:YES];
        }];
    }];
    
    
    NSArray *arr = @[@"1",@"2",@"3",@"4"];
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}

- (void)ractest1{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"send something here"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"销毁");
        }];
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"receive --- %@",x);
    }];
    
}

#pragma mark - RAC发送消息,并且绑定到控件

- (void)racSenderMessage {
    //延迟2.0S 发送"呵呵哒~"消息
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"呵呵哒~"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2.0];
    
    //    RAC(_userNameFeild,text) = [signal map:^id(NSString *value) {
    //        if ([value isEqualToString:@"呵呵哒~"]) {
    //            return @"哈哈哈啊哈哈哈哈啊哈哈哈哈哈";
    //        }
    //        return nil;
    //    }];
    
}

#pragma mark - RAC代理
- (void)racProtocol {
    //    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(whoAmI) fromProtocol:@protocol(Programmer)];
    //
    //    [programmerSignal subscribeNext:^(id x) {
    //        NSLog(@"RAC通知------I'm a great programmer...");
    //    }];
    //    @weakify(self);
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self_weak_ whoAmI];
    //    });
}

- (void)whoAmI {
    //    NSLog(@"whoAmI------user.name = %@",_user.userName);
}

#pragma mark - RAC通知
- (void)racNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RAC_Notifaciotn" object:nil] subscribeNext:^(NSNotification *notify) {
        NSLog(@"notify.content = %@",notify.userInfo[@"content"]);
    }];
    
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RAC_Notifaciotn" object:nil userInfo:@{@"content" : @"i'm a notification"}];
}

#pragma mark - RAC信号拼接
- (void)racSignalLink {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    [[signal1 concat:signal2] subscribeNext:^(NSNumber *value) {
        NSLog(@"RAC信号拼接------value = %@",value);
    }];;
}

#pragma mark - RAC信号合并

- (void)racSignalMerge {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"清纯妹子"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"性感妹子"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    [[signal1 merge:signal2] subscribeNext:^(id x) {
        NSLog(@"RAC信号合并------我喜欢： %@",x);
    }];
}

#pragma mark - RAC信号组合

- (void)racSignalCombine {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"年轻"];
        [subscriber sendNext:@"清纯"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"温柔"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //combineLatest 将数组中的信号量发出的最后一个object 组合到一起
    [[RACSignal combineLatest:@[signal1, signal2]] subscribeNext:^(RACTuple *x) {
        //先进行解包
        RACTupleUnpack(NSString *signal1_Str, NSString *signal2_Str) = x;
        NSLog(@"RAC信号组合------我喜欢 %@的 %@的 妹子",signal1_Str,signal2_Str);
    }];
    
    //会注意收到 组合方法后还可以跟一个Block  /** + (RACSignal *)combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock */
    /*
     reduce这个Block可以对组合后的信号量做处理
     */
    //我们还可以这样使用
    [[RACSignal combineLatest:@[signal1, signal2] reduce:^(NSString *signal1_Str, NSString *signal2_Str){
        return [signal1_Str stringByAppendingString:signal2_Str];
    }] subscribeNext:^(id x) {
        NSLog(@"RAC信号组合(Reduce处理)------我喜欢 %@ 的妹子",x);
    }];
}

#pragma mark - RAC信号压缩
- (void)racSignalZIP {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"年轻"];
        [subscriber sendNext:@"清纯"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"温柔"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //zip 默认会取信号量的最开始发送的对象 所以结果会是 年轻 、温柔
    [[RACSignal zip:@[signal1,signal2]] subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *signal1_Str1,NSString *signal2_Str) = x;
        NSLog(@"RAC信号压缩------我喜欢 %@的 %@的 妹子",signal1_Str1, signal2_Str);
    }];
}

#pragma mark - RAC信号过滤
- (void)racSignalFilter {
    //信号过滤可以参考上面UIButton引用RAC的实例
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(19)];
        [subscriber sendNext:@(12)];
        [subscriber sendNext:@(20)];
        [subscriber sendCompleted];
        
        return nil;
    }] filter:^BOOL(NSNumber *value) {
        if (value.integerValue < 18) {
            //18禁
            NSLog(@"RAC信号过滤------FBI Warning~");
        }
        return value.integerValue > 18;
    }]
     subscribeNext:^(id x) {
         NSLog(@"RAC信号过滤------年龄：%@",x);
     }];
    
}

#pragma mark - RAC信号传递
- (void)racSignalPass {
    //    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        [subscriber sendNext:@"老板向我扔过来一个Star"];
    //        return nil;
    //    }] flattenMap:^RACStream *(NSString *value) {
    //        NSLog(@"RAC信号传递------%@",value);
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            [subscriber sendNext:@"我向老板扔回一块板砖"];
    //            return nil;
    //        }];
    //    }] flattenMap:^RACStream *(NSString *value) {
    //        NSLog(@"RAC信号传递------%@",value);
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            [subscriber sendNext:@"我跟老板正面刚~,结果可想而知"];
    //            return nil;
    //        }];
    //    }] subscribeNext:^(id x) {
    //        NSLog(@"RAC信号传递------%@",x);
    //    }];
}

#pragma mark - RAC信号串
//用那个著名的脑筋急转弯说明吧，“如何把大象放进冰箱里”  第一步，打开冰箱；第二步，把大象放进冰箱；第三步，关上冰箱门。
- (void)racSignalQueue {
    //与信号传递类似，不过使用 `then` 表明的是秩序，没有传递value
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"RAC信号串------打开冰箱");
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"RAC信号串------把大象放进冰箱");
            [subscriber sendCompleted];
            return nil;
        }];
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"RAC信号串------关上冰箱门");
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        NSLog(@"RAC信号串------Over");
    }];
}

#pragma mark - RAC_Command介绍

- (void)racCommandDemo {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"racCommandDemo------亲，帮我带份饭~");
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //命令执行
    [command execute:nil];
}

#pragma mark - RACSignal 的一些修饰符
- (void)racSignalOther {
    
    //延迟
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"RAC信号延迟-----等等我~等等我2秒"];
        [subscriber sendCompleted];
        return nil;
    }] delay:2.0] subscribeNext:^(id x) {
        NSLog(@"RAC信号延迟-----终于等到你~");
    }];
    
    //定时任务，可以代替NSTimer,可以看到`RACScheduler`使用GCD实现的
    [[RACSignal interval:60*60 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"每小时吃一次药，不要放弃治疗");
    }];
    
    //设置超时时间
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"hh"];
            [subscriber sendCompleted];
            return nil;
        }] delay:4] subscribeNext:^(id x) {
            NSLog(@"RAC设置超时时间------请求到数据:%@",x);
            [subscriber sendNext:[@"RAC设置超时时间------请求到数据:" stringByAppendingString:x]];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }] timeout:3 onScheduler:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         //在timeout规定时间之内接受到信号，才会执行订阅者的block
         //这这里3秒之内没有接受到信号，所有该次订阅已失效
         NSLog(@"RAC设置超时时间------请求到数据:%@",x);
     }];
    
    //设置retry次数，这部分可以和网络请求一起用
    __block int retry_idx = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (retry_idx < 3) {
            retry_idx++;
            [subscriber sendError:nil];
        }else {
            [subscriber sendNext:@"success!"];
            [subscriber sendCompleted];
        }
        return nil;
    }] retry:3] subscribeNext:^(id x) {
        NSLog(@"请求:%@",x);
    }];
    
    //节流阀,throttle秒内只能通过1个消息
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"6"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"66"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"666"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }] throttle:2] subscribeNext:^(id x) {
        //throttle: N   N秒之内只能通过一个消息，所以@"66"是不会被发出的
        NSLog(@"RAC_throttle------result = %@",x);
    }];
    
    //takeUntil条件控制
    /**
     解释：`takeUntil:(RACSignal *)signalTrigger` 只有当`signalTrigger`这个signal发出消息才会停止
     */
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            //每秒发一个消息
            [subscriber sendNext:@"RAC_Condition------吃饭中~"];
        }];
        return nil;
    }] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //延迟3S发送一个消息，才会让前面的信号停止
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"RAC_Condition------吃饱了~");
            [subscriber sendNext:@"吃饱了"];
        });
        return nil;
    }]] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark - 信号
- (RACSignal *)aloginSignal{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"这里执行登录操作");
        [subscriber sendNext:@(YES)];
        [subscriber sendCompleted];
        return nil;
    }];
    
}
#pragma mark - UI

- (UITextField *)testTextField{
    if(!_testTextField){
        _testTextField = [UITextField new];
        _testTextField.backgroundColor = [UIColor yellowColor];
        _testTextField.textColor = [UIColor blackColor];
    }
    return _testTextField;
}

- (UIButton *)logoinBtn{
    if(!_logoinBtn){
        _logoinBtn = [UIButton new];
        _logoinBtn.backgroundColor = [UIColor redColor];
        [_logoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoinBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    return _logoinBtn;
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
