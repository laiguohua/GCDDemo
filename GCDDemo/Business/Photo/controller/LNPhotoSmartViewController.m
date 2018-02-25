//
//  LNPhotoSmartViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNPhotoSmartViewController.h"
#import "LPhotoSmartCell.h"
#import "LPhotoSmartViewModel.h"
#import "LPhotoSmartDelegateModel.h"
#import "LNPhotoPreviewViewController.h"

@interface LNPhotoSmartViewController ()

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)LPhotoSmartDelegateModel *delegateModel;
@property (nonatomic,strong)LPhotoSmartViewModel *viewModel;

@end

@implementation LNPhotoSmartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    [self bindViewModel];
}

- (void)setModel:(LAlbumListModel *)model{
    _model = model;
    self.viewModel.model = _model;
    self.title = _model.title;
}

- (void)setUpUI{
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindViewModel{
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    self.delegateModel = [[LPhotoSmartDelegateModel alloc] initWithDataArr:self.viewModel.dataArr collectionView:self.collectionView cellClassNames:@[NSStringFromClass(LPhotoSmartCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        @strongify(self);
        LNPhotoPreviewViewController *vc = [LNPhotoPreviewViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self.viewModel.photoCmmand execute:nil];
}

#pragma mark - lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGSize size = [UIScreen mainScreen].bounds.size;
        layout.itemSize = CGSizeMake(floorf((size.width - 3 * 10) / 4), floorf((size.width - 3 * 10) / 4));
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [LPhotoSmartDelegateModel createCollectionViewWithLayout:layout rigistNibCellNames:@[NSStringFromClass(LPhotoSmartCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (LPhotoSmartViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LPhotoSmartViewModel new];
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
