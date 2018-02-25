//
//  LNPhotoPreviewDelegateModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LBaseCollectionDelegateModel.h"

@interface LNPhotoPreviewDelegateModel : LBaseCollectionDelegateModel

@property (nonatomic,weak)UINavigationController *navgation;

@property (nonatomic,copy)void(^titleChangeBlcok)(NSString *atitle);

- (void)deleteCurrentItem;

@end
