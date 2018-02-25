//
//  LPhotoSmartModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

@interface LPhotoSmartModel : NSObject

@property (nonatomic,strong)PHAsset *asset;

@property (nonatomic,assign,getter=isSelected)BOOL selected;

@end
