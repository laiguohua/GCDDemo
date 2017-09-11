//
//  MBManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNMBProgressHUD.h"

@interface MBManager : NSObject

+ (MBManager *)shareManager;

+ (LNMBProgressHUD *)showHUD;
+ (LNMBProgressHUD *)showHUDMessage:(NSString *)message;
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message;
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block;
+ (LNMBProgressHUD *)showHUDInfor:(NSString *)infor;
+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview  animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block;

+ (void)hiddenHUD;
+ (void)hiddenHUDinview:(UIView *)aview;

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview;

@end
