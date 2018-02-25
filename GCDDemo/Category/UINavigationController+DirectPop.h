//
//  UINavigationController+DirectPop.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/24.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (DirectPop)
- (void)saveDirectViewControllerName:(NSString *)className;
- (void)removeDirectViewControllerName:(NSString *)className;
- (void)removeAllDirect;
- (UIViewController *)findDirectViewController;
- (void)directTopControllerPop;

@end
