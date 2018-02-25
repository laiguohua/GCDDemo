//
//  LNPhotoPreviewBigCell.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/17.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCellConfigDelegate.h"
#import "LNPhotoPreviewModel.h"

@interface LNPhotoPreviewBigCell : UICollectionViewCell<LCellConfigDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

-(void)showIndicator;
-(void)hideIndicator;

@end
