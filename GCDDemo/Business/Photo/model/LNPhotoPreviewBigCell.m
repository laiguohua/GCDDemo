//
//  LNPhotoPreviewBigCell.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNPhotoPreviewBigCell.h"

@implementation LNPhotoPreviewBigCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(void)showIndicator{
    self.Indicator.hidden = NO;
    if(![self.Indicator isAnimating]){
        [self.Indicator startAnimating];
    }
}
-(void)hideIndicator{
    
    if([self.Indicator isAnimating]){
        [self.Indicator stopAnimating];
    }
    self.Indicator.hidden = YES;
}

- (void)ln_configCellWithInfor:(LNPhotoPreviewModel *)model{
    [self hideIndicator];
    if(model.type == 1){

        [self showIndicator];
        __weak __typeof(self)weakSelf= self;
        [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.bigPicUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong __typeof(self)strongSelf = weakSelf;
            strongSelf.ImageView.image = image;
            [strongSelf hideIndicator];
        }];

    }else if(model.type == 2){
        self.ImageView.image = [UIImage imageNamed:model.bigPicName];
        
    }else if(model.type == 3){
        self.ImageView.image = model.bigImage;
    }
}

@end
