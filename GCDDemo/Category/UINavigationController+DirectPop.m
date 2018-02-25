//
//  UINavigationController+DirectPop.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/24.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "UINavigationController+DirectPop.h"
#import "objc/runtime.h"

static char directClassNameKey;

@implementation UINavigationController (DirectPop)

- (NSMutableArray *)directClassArr{
    NSMutableArray *muArr = objc_getAssociatedObject(self, &directClassNameKey);
    if(!muArr){
        muArr = [NSMutableArray array];
        objc_setAssociatedObject(self, &directClassNameKey, muArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return muArr;
    
}

- (void)saveDirectViewControllerName:(NSString *)className{
    if(![self invaleClassName:className]) return;
    [[self directClassArr] addObject:className];
}
- (void)removeDirectViewControllerName:(NSString *)className{
    if(![self invaleClassName:className]) return;
    if([[self directClassArr] containsObject:className]){
        [[self directClassArr] removeObject:className];
    }
    
}
- (void)removeAllDirect{
    [[self directClassArr] removeAllObjects];
}
- (UIViewController *)findDirectViewController{
    NSString *findClassName = [[self directClassArr] lastObject];
    if(!findClassName) return nil;
    [self removeDirectViewControllerName:findClassName];
    UIViewController *findController;
    Class findClass = NSClassFromString(findClassName);
    for(UIViewController *controller in self.viewControllers){
        if([controller isKindOfClass:findClass]){
            findController = controller;
            break;
        }
    }
    
    return findController;
}
- (void)directTopControllerPop{
    UIViewController *controller = [self findDirectViewController];
    if(controller){
        [self popToViewController:controller animated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

- (BOOL)invaleClassName:(NSString *)className{
    if(!className) return NO;
    return [NSClassFromString(className) isSubclassOfClass:[UIViewController class]];
}

@end
