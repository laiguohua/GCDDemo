//
//  LNAlbumListViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNAlbumListViewController.h"
#import "LAlbumListDelegateModel.h"
#import "LAlbumViewModel.h"
#import "LAlubumListCell.h"

#import "LNPhotoSmartViewController.h"

@interface LNAlbumListViewController ()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LAlbumListDelegateModel *delegateModel;
@property (nonatomic,strong)LAlbumViewModel *viewModel;
@end

@implementation LNAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"照片";
    
    [self setUpUI];
    
    [self bindViewModel];
}


- (void)setUpUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    self.delegateModel = [[LAlbumListDelegateModel alloc] initWithDataArr:self.viewModel.dataArr tableView:self.tableView cellClassNames:@[NSStringFromClass(LAlubumListCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        @strongify(self);
        LNPhotoSmartViewController *vc = [LNPhotoSmartViewController new];
        vc.model = cellModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self.viewModel.photoCmmand execute:nil];
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [LAlbumListDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(LAlubumListCell.class)] rigistClassCellNames:nil];
    }
    return _tableView;
}

- (LAlbumViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LAlbumViewModel new];
    }
    return _viewModel;
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
