//
//  LAlbumViewModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPhotoLibiraryManager.h"
#import "LAlbumListModel.h"

@interface LAlbumViewModel : NSObject

@property (nonatomic,strong)NSMutableArray <LAlbumListModel *> *dataArr;

@property (nonatomic,strong)RACCommand *photoCmmand;
@property (nonatomic,strong)RACSubject *refreshUISubject;

@end
