//
//  LNPhotoPreviewViewController.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNPhotoPreviewViewController.h"

#import "LNPhotoPreviewDelegateModel.h"

#import "LNPhotoPreviewBigCell.h"

static CGFloat const margin = 20;

@interface LNPhotoPreviewViewController ()

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)LNPhotoPreviewDelegateModel *delegateModel;

/**
 *  展示当前选择照片的动态
 */
@property(nonatomic,strong)UILabel * middle;
/**
 *  导航栏右侧的按钮
 */
@property(nonatomic,strong)UIButton * selectStatus;
/**
 *  中间的标题
 */
@property(nonatomic,strong)UILabel * titleLable;

@end

@implementation LNPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadTestData];
    
    [self setUpUI];
    [self bindViewModel];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    CGSize asize = [UIScreen mainScreen].bounds.size;
    [self.collectionView setContentOffset:CGPointMake(self.clickNum * (asize.width + margin), 0)];
}

- (void)loadTestData{
    
    NSArray *arr = @[@"http://img0.bdstatic.com/img/image/shouye/leimu/mingxing.jpg",
                     @"http://img.baidu.com/img/image/3bf33a87e950352a5947ae485143fbf2b2.jpg",
                     @"http://img1.bdstatic.com/img/image/8662934349b033b5bb5c55e5d9834d3d539b700bcce.jpg",
                     @"http://imgstatic.baidu.com/img/image/7af40ad162d9f2d3cdc19be8abec8a136227cce1.jpg",
                     @"http://imgstatic.baidu.com/img/image/weimeiyijing0207.jpg",
                     @"http://e.hiphotos.baidu.com/image/w%3D400/sign=2e56c8010ed79123e0e095749d355917/ae51f3deb48f8c5470385d2638292df5e1fe7fd4.jpg",
                     @"http://c.hiphotos.baidu.com/image/w%3D400/sign=e37cc47c6509c93d07f20ff7af3cf8bb/7a899e510fb30f2468cc6271ca95d143ad4b0369.jpg",
                     @"http://b.hiphotos.baidu.com/image/w%3D400/sign=ac0b8e2b92ef76c6d0d2fa2bad17fdf6/a71ea8d3fd1f4134dedc5974271f95cad0c85ed4.jpg",
                     @"http://imgstatic.baidu.com/img/image/huacaozhiwu0207.jpg",
                     @"http://d.hiphotos.baidu.com/image/w%3D400/sign=7d27c75af4246b607b0eb374dbf81a35/5882b2b7d0a20cf4f28367d674094b36acaf99ac.jpg",
                     @"http://f.hiphotos.baidu.com/image/w%3D400/sign=657110132ff5e0feee1888016c6134e5/c83d70cf3bc79f3d6db2fb3ab8a1cd11728b296c.jpg",
                     @"http://g.hiphotos.baidu.com/image/w%3D400/sign=4be7f3c141166d223877149476230945/e850352ac65c10384d5fbac8b0119313b07e8992.jpg"];
    self.clickNum = 3;
    for(int i=0;i<arr.count;i++){
        LNPhotoPreviewModel *model = [LNPhotoPreviewModel new];
        model.bigPicUrl = arr[i];
        model.type = 1;
//        if(i == self.clickNum){
//            model.isSelected = YES;
//        }
        [self.dataArr addObject:model];
    }
    
    
    
}

- (void)setUpUI{
    [self.view addSubview:self.collectionView];
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLable.text = [NSString stringWithFormat:@"%d/%d",(int)self.clickNum,(int)self.dataArr.count];
    _titleLable = titleLable;
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleleAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)deleleAction:(UIBarButtonItem *)sender{
    [self.delegateModel deleteCurrentItem];
}

- (void)bindViewModel{
    @weakify(self);
    self.delegateModel = [[LNPhotoPreviewDelegateModel alloc] initWithDataArr:self.dataArr collectionView:self.collectionView cellClassNames:@[NSStringFromClass(LNPhotoPreviewBigCell.class)] cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        @strongify(self);
        
    }];
    
    self.delegateModel.titleChangeBlcok = ^(NSString *atitle){
        @strongify(self);
        self.titleLable.text = atitle;
    };
    
    [self.collectionView reloadData];
    self.delegateModel.navgation = self.navigationController;
}

#pragma mark - lazyload
- (UICollectionView *)collectionView{
    if(!_collectionView){
        CGSize asize = [UIScreen mainScreen].bounds.size;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = margin;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
        flowLayout.itemSize = CGSizeMake(asize.width, asize.height );
        _collectionView = [LNPhotoPreviewDelegateModel createCollectionViewWithLayout:flowLayout rigistNibCellNames:@[NSStringFromClass(LNPhotoPreviewBigCell.class)] rigistClassCellNames:nil];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.frame = CGRectMake(-margin/2, 0, asize.width + margin, asize.height);
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray <LNPhotoPreviewModel *>*)chooseArr{
    if(!_chooseArr){
        _chooseArr = [NSMutableArray array];
    }
    return _chooseArr;
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
