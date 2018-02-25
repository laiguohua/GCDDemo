//
//  LPhotoLibiraryManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

@interface LNPhotoList : NSObject
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


@end


@interface LPhotoLibiraryManager : NSObject

+(instancetype)defaultLPhotoLibiraryManager;
/**
 *  获得所有的相册
 *
 *  @return  FZJPhotoList样式的相册
 */

-(NSArray<LNPhotoList *> *)getAllPhotoList;

/**
 *  取到对应的照片实体
 *
 *  @param asset      索取照片实体的媒介
 *  @param size       实际想要的照片大小
 *  @param resizeMode 控制照片尺寸
 *  @param completion block返回照片实体
 */
-(void)getImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage * AssetImage))completion;

/**
 *   取得所有的照片资源
 *
 *  @param ascending 排序方式
 *
 *  @return 照片资源
 */

-(NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

/**
 *  获取指定相册内的所有图片
 */
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;


#pragma mark --  判断对相册和相机的使用权限
/**
 *  相册的使用权限
 *
 *  @return 是否
 */
-(BOOL)FZJhaveAlbumAuthority;
/**
 *  相机的使用权限
 *
 *  @return 是否
 */
-(BOOL)FZJhaveCameraAuthority;


@end
