//
//  LNPhotoPreviewViewController.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNBaseViewController.h"

#import "LNPhotoPreviewModel.h"

@interface LNPhotoPreviewViewController : LNBaseViewController

/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray * dataArr;
/**
 *  已经选择的照片
 */
@property(nonatomic,strong)NSMutableArray <LNPhotoPreviewModel *>* chooseArr;
/**
 *  能选择照片的上限
 */
@property(nonatomic,assign)NSInteger addNum;
/**
 *  点击的图片
 */
@property(nonatomic,assign)NSInteger clickNum;

/**
 *  YES则为从第一个界面进入大图浏览，否则是从小图浏览直接进入大图浏览
 */
@property(nonatomic,assign)BOOL chooseState;

@end
