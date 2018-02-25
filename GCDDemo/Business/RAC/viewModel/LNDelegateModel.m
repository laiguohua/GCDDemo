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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor redColor];
        line.tag = 100;
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.width.equalTo(@1);
        }];
    }
    cell.textLabel.text = self.viewModel.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
