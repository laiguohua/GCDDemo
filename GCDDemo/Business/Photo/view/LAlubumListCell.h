//
//  LAlubumListCell.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/10/15.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCellConfigDelegate.h"
#import "LPhotoLibiraryManager.h"

@interface LAlubumListCell : UITableViewCell<LCellConfigDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
