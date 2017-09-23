//
//  LNDelegateModel.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/21.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNRacTestTwoModel.h"

@interface LNDelegateModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)LNRacTestTwoModel *viewModel;

@property (nonatomic,strong)RACSubject *selectSubject;

@end
