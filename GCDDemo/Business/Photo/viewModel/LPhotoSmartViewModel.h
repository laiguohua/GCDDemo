//
//  LPhotoSmartViewModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPhotoLibiraryManager.h"
#import "LAlbumListModel.h"
#import "LPhotoSmartModel.h"

@interface LPhotoSmartViewModel : NSObject
@property (nonatomic,strong)LAlbumListModel *model;
@property (nonatomic,strong)NSMutableArray <LPhotoSmartModel *> *dataArr;
@property (nonatomic,strong)RACCommand *photoCmmand;
@property (nonatomic,strong)RACSubject *refreshUISubject;
@end
