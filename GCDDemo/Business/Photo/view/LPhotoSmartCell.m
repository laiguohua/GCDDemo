//
//  LPhotoSmartCell.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LPhotoSmartCell.h"
#import "LPhotoSmartModel.h"
#import "LPhotoLibiraryManager.h"
@implementation LPhotoSmartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ln_configCellWithInfor:(LPhotoSmartModel *)model{
    CGSize size = self.frame.size;
    size.width *= [UIScreen mainScreen].scale;
    size.height *= [UIScreen mainScreen].scale;
    [[LPhotoLibiraryManager defaultLPhotoLibiraryManager] getImageByAsset:model.asset makeSize:size makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *AssetImage) {
        self.picImageView.image = AssetImage;
    }];
}

@end
