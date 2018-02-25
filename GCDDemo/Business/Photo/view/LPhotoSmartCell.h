//
//  LPhotoSmartCell.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCellConfigDelegate.h"


@interface LPhotoSmartCell : UICollectionViewCell<LCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end
