//
//  LNDelegateModel.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/21.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNDelegateModel.h"

@implementation LNDelegateModel

#pragma mark - 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndetifi = @"acell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifi];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifi];
    }
    cell.textLabel.text = self.viewModel.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectSubject sendNext:@(indexPath.row)];
}

- (RACSubject *)selectSubject{
    if(!_selectSubject){
        _selectSubject = [RACSubject subject];
    }
    return _selectSubject;
}

@end
