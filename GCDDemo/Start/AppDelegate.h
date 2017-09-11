//
//  AppDelegate.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/7/30.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

