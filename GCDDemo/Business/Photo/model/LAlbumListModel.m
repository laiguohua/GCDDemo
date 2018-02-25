//
//  LAlbumListModel.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LAlbumListModel.h"

@implementation LAlbumListModel

- (id)initWithModel:(LNPhotoList *)model{
    self = [super init];
    if(self){
        self.title = model.title;
        self.photoNum = model.photoNum;
        self.firstAsset = model.firstAsset;
        self.assetCollection = model.assetCollection;
    }
    return self;
}

@end
