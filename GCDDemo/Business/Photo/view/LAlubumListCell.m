//
//  LAlubumListCell.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LAlubumListCell.h"
#import "LAlbumListModel.h"

@implementation LAlubumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ln_configCellWithInfor:(LAlbumListModel *)model{
  
    [[LPhotoLibiraryManager defaultLPhotoLibiraryManager] getImageByAsset:model.firstAsset makeSize:CGSizeMake(50 * [UIScreen mainScreen].scale, 50 * [UIScreen mainScreen].scale) makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *AssetImage) {
        self.picImageView.image = AssetImage;
        
    }];
    self.titleLabel.text = model.title;
    self.numLabel.text = [NSString stringWithFormat:@"(%ld)",model.photoNum];
}
@end
