//
//  MBManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "MBManager.h"

static const NSTimeInterval delayTime = 3.0;

@interface MBManager()

@end

@implementation MBManager

+ (MBManager *)shareManager{
    static MBManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[MBManager alloc] init];
    });
    return manager;
}



+ (LNMBProgressHUD *)showHUD{
    return [self showHUDMessage:nil];
}
+ (LNMBProgressHUD *)showHUDMessage:(NSString *)message{
    [self mostTopViewWithIsshow:YES comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeIndeterminate;
        if(message){
            hud.label.text = message;
        }
        hud.detailsLabel.text = nil;
    }];
    return nil;
}
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:[block copy]];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDInfor:(NSString *)infor{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = infor;
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(![aview isKindOfClass:[UIWindow class]]){
        if(!aview.window){
            return nil;
        }
    }
    if(!hud){
        hud = [LNMBProgressHUD showHUDAddedTo:aview animated:animated];
        hud.square = NO;
    }
    hud.completionBlock = [block copy];
    
    return hud;
}

+ (void)hiddenHUD{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        [self hiddenHUDinview:aview];
    }];
    
}
+ (void)hiddenHUDinview:(UIView *)aview{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(hud){
        [hud hideAnimated:YES];
    }
}

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview{
    NSAssert(aview, @"aview can not be nil");
    LNMBProgressHUD *hud = (LNMBProgressHUD *)[LNMBProgressHUD HUDForView:aview];
    if(!hud || hud.hasFinished){
        return nil;
    }
    hud.graceTime = .2;
    hud.minShowTime = .2;
    [aview bringSubviewToFront:hud];
    return hud;
}

+ (void)mostTopViewWithIsshow:(BOOL)isShow comple:( void(^)(UIView *))block{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController){
        if(block){
            block(window);
        }
        
        return;
    }
    NSTimeInterval adelayTime = .3;
//    if(!isShow){
//        
//        adelayTime = .3;
//    }
    
    //延迟，避免在viewDidLoad中加载，这时候控制器还没有present或者push 过来
    NSTimer *atimer = [NSTimer scheduledTimerWithTimeInterval:adelayTime target:self selector:@selector(delayFindController:) userInfo:@{@"acontroller":rootController,@"ablock":[block copy]} repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:atimer forMode:NSRunLoopCommonModes];
    
}

+ (void)delayFindController:(NSTimer *)timer{
    NSDictionary *dict = timer.userInfo;
    UIViewController *topViewController = [self getCurrentControllerWithController:dict[@"acontroller"]];
    void (^ablock)(UIView *) = dict[@"ablock"];
    if(ablock){
        ablock(topViewController.view);
    }
}

+ (UIViewController *)getCurrentControllerWithController:(UIViewController *)vc{
    if([vc isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *nav= (UINavigationController *)vc;
        if(nav.presentedViewController){
            return [self getCurrentControllerWithController:nav.presentedViewController];
        }
        return nav.visibleViewController;
        
    }else if([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        UIViewController *avc = tab.selectedViewController;
        return [self getCurrentControllerWithController:avc];
    }
    return vc;
}



@end
