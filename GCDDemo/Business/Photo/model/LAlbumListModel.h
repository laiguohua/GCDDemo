//
//  LAlbumListModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPhotoLibiraryManager.h"

@interface LAlbumListModel : NSObject
/**
 *  相册的名字
 */
@property(nonatomic,strong)NSString * title;
/**
 *  该相册的照片数量
 */
@property(nonatomic,assign)NSInteger  photoNum;
/**
 *  该相册的第一张图片
 */
@property(nonatomic,strong)PHAsset * firstAsset;
/**
 *  同过该属性可以取得该相册的所有照片
 */
@property(nonatomic,strong)PHAssetCollection * assetCollection;

- (id)initWithModel:(LNPhotoList *)model;

@end
