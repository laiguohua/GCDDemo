//
//  LNRacTestTwoViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/20.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNRacTestTwoViewController.h"
#import "LNRacTestTwoModel.h"
#import "LNDelegateModel.h"
#import "LNNetLoadViewController.h"


@interface LNRacTestTwoViewController ()

@property (nonatomic,strong)LNRacTestTwoModel *viewModel;
@property (nonatomic,strong)LNDelegateModel *delegaModel;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIWindow *window;

//@property (nonatomic,strong)RACCommand *command;

@end

@implementation LNRacTestTwoViewController

- (void)dealloc{
    NSLog(@"dealloc");
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self loadUI];
    
    //tableview 的代理

    self.delegaModel.viewModel = self.viewModel;
    
    @weakify(self);
    
    //信号中的信号
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        @strongify(self);
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
    
    [self.viewModel.requestCommand execute:nil];
        //每隔一秒钟就会发出信号
//    [[RACSignal interval:1.0 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//        [self.viewModel.requestCommand execute:nil];
//
//    }];
    
     RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
      return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
          [subscriber sendNext:@"77777"];
          [subscriber sendCompleted];
          return nil;
      }];
    }];
    //可以过滤掉多个请求，只请求一次
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [command execute:nil];
    [command execute:nil];
    
    
    
    RACSubject *subject = [RACSubject subject];
    //取最后一条信号
    [[subject takeLast:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"3333"];
    [subject sendNext:@"55555"];
    [subject sendNext:@"8888"];
    [subject sendCompleted];//订阅者必须调用完成
    
    //用作防重复点击事件比较好
    RACSubject *subject1 = [RACSubject subject];
    [[subject1 throttle:.5] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject1 sendNext:@"3333"];
    [subject1 sendNext:@"55555"];
    [subject1 sendNext:@"8888"];
    
//    [[self.viewModel.requestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//        
//        NSLog(@"%@",x);
//        @strongify(self);
//        [self.tableView reloadData];
//        
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"send error");
//    }];
    
    [self.delegaModel.selectSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSLog(@"RAC select row is %@",x);
        LNNetLoadViewController *netVC = [LNNetLoadViewController new];
        [self.navigationController pushViewController:netVC animated:YES];
    }];
    
    
    
    [self methodTest2];
    
    [self calendarTest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)calendarTest{
    //获取代表公历的Calendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //获取当前日期
    NSDate* dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitQuarter;
    
    NSDate* toDate   = [self DateFromString:@"2012-10-29 00:00:00 +0600"];
    //获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt ];
//    NSDateComponents* comp = [gregorian components:unitFlags fromDate:dt toDate:toDate options:0];
    //获取各个时间字段的数值
    NSLog(@"现在是%ld年",comp.year);
    NSLog(@"现在是%ld月",comp.month);
    NSLog(@"现在是%ld日",comp.day);
    NSLog(@"现在是%ld时",comp.hour);
    NSLog(@"现在是%ld分",comp.minute);
    NSLog(@"现在是%ld秒",comp.second);
    NSLog(@"现在是星期%ld",comp.weekday);
    NSLog(@"现在是季度%ld",comp.quarter);
    
    //再次创建一个NSDateComponents对象
    NSDateComponents* comp2 = [[NSDateComponents alloc] init];
    //设置各个时间字段的数值
    comp2.year = 2013;
    comp2.month = 4;
    comp2.day = 12;
    //要设置时区，不然计算出来的会少8个小时
    [comp2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    comp2.hour = 23 ;
//    comp2.hour = 23 + 8;//如果不设置时区，这里一定要加8，计算出来的才是23点，
   
    comp2.minute = 34;
    //通过NSDateComponents所包含的时间字段的数值来恢复NSDateduixiang
    NSDate* date = [gregorian dateFromComponents:comp2];
    
    
    NSLog(@"获取的日期为:%@",date);
}

//NSDate也可以转换为NSString
- (NSString *)StringFromDate:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * string = [formatter stringFromDate:date];
    return string;
}
//NSStrinig可以转换为NSDate
- (NSDate *)DateFromString:(NSString *)string{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    //下面两句加一句，不然转换出来的时间会少了8个小时
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:string];
    return date;
}

- (void)methodTest2{
    NSLog(@"this is method 2");
    //如下方式，三个订阅者，则会调用[subscriber sendNext:@"哈哈哈"];三次
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"哈哈哈"];
        return nil;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //如下方式，三个订阅者，则会调用[subscriber sendNext:@"哈哈哈"]只会一次
    RACSignal *signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"我只调用了一次"];
        return nil;
    }];
    RACMulticastConnection *connect = [signalOne publish];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [connect connect];
    
}

- (void)methodTest{
    
    //    LNNetLoadViewController *netVC = [LNNetLoadViewController new];
    UIButton *button = [UIButton new];
    [button setTitle:@"window消失" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.window resignKeyWindow];
        self.window = nil;
    }];
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    //    _window.rootViewController = netVC;
    _window.windowLevel = UIWindowLevelAlert + 3;
    [_window makeKeyAndVisible];
    [_window addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_window);
    }];
    
}

- (void)loadUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self.delegaModel;
        _tableView.delegate = self.delegaModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (LNRacTestTwoModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LNRacTestTwoModel new];
    }
    return _viewModel;
}
- (LNDelegateModel *)delegaModel{
    if(!_delegaModel){
        _delegaModel = [LNDelegateModel new];
    }
    return _delegaModel;
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
