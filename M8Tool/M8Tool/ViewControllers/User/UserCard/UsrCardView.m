//
//  UsrCardView.m
//  M8Tool
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrCardView.h"
#import "UsrCardHeaderView.h"
#import "UsrCardViewCell.h"



@interface UsrCardView ()<UITableViewDelegate, UITableViewDataSource>


/**
 item 名
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;

/**
 保存方法名
 */
@property (nonatomic, strong) NSMutableArray *selsArray;

@end

@implementation UsrCardView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UsrCardViewCell" bundle:nil] forCellReuseIdentifier:@"UsrCardViewCellID"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:@[@[@"昵称", @"电话", @"性别", @"生日", @"地区"],
                                                                      @[@"个人实名认证"],
                                                                      @[@"所在企业"]]];
        _itemsArray = itemsArray;
    }
    return _itemsArray;
}







- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_itemsArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UsrCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrCardViewCellID" forIndexPath:indexPath];
    
    [cell config:@"" item:_itemsArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
