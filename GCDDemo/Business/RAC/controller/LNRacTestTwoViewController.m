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
