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

@interface LNRacTestTwoViewController ()

@property (nonatomic,strong)LNRacTestTwoModel *viewModel;
@property (nonatomic,strong)LNDelegateModel *delegaModel;

@property (nonatomic,strong)UITableView *tableView;

//@property (nonatomic,strong)RACCommand *command;

@end

@implementation LNRacTestTwoViewController

- (void)dealloc{
    NSLog(@"dealloc");
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
    [[subject takeLast:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"3333"];
    [subject sendNext:@"55555"];
    [subject sendNext:@"8888"];
    [subject sendCompleted];//订阅者必须调用完成
    
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
        NSLog(@"RAC select row is %@",x);
    }];
    
}

- (void)methodTest2{
    NSLog(@"this is method 2");
}

- (void)methodTest{
    
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
