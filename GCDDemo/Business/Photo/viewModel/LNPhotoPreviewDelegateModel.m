//
//  LNPhotoPreviewDelegateModel.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNPhotoPreviewDelegateModel.h"

#import "LNPhotoPreviewBigCell.h"

@implementation LNPhotoPreviewDelegateModel

- (void)ln_delegateConfig{
    @weakify(self);
    self.ln_collectionViewRowCellBlock = ^(NSIndexPath *indexPath,UICollectionViewCell<LCellConfigDelegate> *acell){
        @strongify(self);
        LNPhotoPreviewBigCell *cell = (LNPhotoPreviewBigCell *)acell;
        cell.ScrollView.delegate = self;
        [self addGestureTapToScrollView:cell.ScrollView];
    };
}

- (void)deleteCurrentItem{
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger current = floorf(self.weakCollectionView.contentOffset.x / (size.width + 20))  ;
    if(self.dataArr.count > current){
        [self.weakCollectionView performBatchUpdates:^{
            [self.dataArr removeObjectAtIndex:current];
            [self.weakCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:current inSection:0]]];
        } completion:^(BOOL finished) {
            CGFloat acurrent = self.weakCollectionView.contentOffset.x / (size.width + 20) + 1;
            if(self.dataArr.count == 0){
                acurrent --;
            }
            if(self.titleChangeBlcok){
                self.titleChangeBlcok([NSString stringWithFormat:@"%.f/%d",acurrent,(int)self.dataArr.count]);
            }
            
            if(self.dataArr.count){
                self.navgation.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                self.navgation.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }];
        
        
    }
    
}

#pragma mark --- ScrollView 代理
/**
 *  动态改变图片展示的状态
 *
 *  @param scrollView 当前的_bigCollect
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == (UIScrollView *)self.weakCollectionView) {//UICollectionView是继承于UIScrollView的
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat current = scrollView.contentOffset.x / (size.width + 20) + 1;
        if(self.dataArr.count == 0){
            current --;
        }
        if(self.titleChangeBlcok){
            self.titleChangeBlcok([NSString stringWithFormat:@"%.f/%d",current,(int)self.dataArr.count]);
        }
    }
}
/**
 *  即将出现的不被方法或者缩小的视图
 *
 *  @param cell           将要出现的Cell
 *  @param indexPath      cell在数据源中得位置
 */
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    LNPhotoPreviewBigCell * WillCell = (LNPhotoPreviewBigCell *)cell;
    WillCell.ScrollView.zoomScale = 1;
}
/**
 *  返回的是图片的视图
 *
 *  @param scrollView 当前的scrollView
 *
 *  @return 返回一个放大或缩小的视图
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}
#pragma mark ---  scrollView 添加手势
-(void)addGestureTapToScrollView:(UIScrollView *)scrollView{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnScrollView:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [scrollView addGestureRecognizer:doubleTap];
}
/**
 *  隐藏导航栏和NavgationBar
 *
 *  @param singleTap 单击
 */
-(void)singleTapOnScrollView:(UITapGestureRecognizer *)singleTap{
    if (self.navgation.navigationBar.isHidden) {
        [self showNavBarAndStatusBar];
    }else{
        [self hideNavBarAndStatusBar];
    }
}
#pragma mark ---  隐藏或者显示导航栏
-(void)showNavBarAndStatusBar{
    self.navgation.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
-(void)hideNavBarAndStatusBar{
    self.navgation.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
/**
 *  放大缩小
 *
 *  @param doubleTap 双击
 */
-(void)doubleTapOnScrollView:(UITapGestureRecognizer *)doubleTap{
    
    UIScrollView * scrollView = (UIScrollView *)doubleTap.view;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3) {
        scale = 3;
    }else{
        scale = 1;
    }
    [self CGRectForScale:scale WithCenter:[doubleTap locationInView:doubleTap.view] ScrollView:scrollView Completion:^(CGRect Rect) {
        [scrollView zoomToRect:Rect animated:YES];
    }];
}
-(void)CGRectForScale:(CGFloat)scale WithCenter:(CGPoint)center ScrollView:(UIScrollView *)scrollView Completion:(void(^)(CGRect Rect))completion{
    CGRect Rect;
    Rect.size.height = scrollView.frame.size.height / scale;
    Rect.size.width  = scrollView.frame.size.width  / scale;
    Rect.origin.x    = center.x - (Rect.size.width  /2.0);
    Rect.origin.y    = center.y - (Rect.size.height /2.0);
    completion(Rect);
}
#pragma mark--
#pragma mark 通知注册及销毁

@end
