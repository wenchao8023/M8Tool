//
//  UserSettingTabelView.m
//  M8Tool
//
//  Created by chao on 2017/5/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserSettingTabelView.h"

@interface UserSettingTabelView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation UserSettingTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView    = [WCUIKitControl createViewWithFrame:CGRectZero];
        self.tableHeaderView    = [WCUIKitControl createViewWithFrame:CGRectZero];
        self.dataSource         = self;
        self.delegate           = self;
        self.scrollEnabled      = NO;
        self.backgroundColor    = WCClear;
        
    }
    return self;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSArray *dataArrray = @[@"密码设置", @"新消息设置", @"关于iBuild"];
        _dataArray = dataArrray;
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UserSettingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WCClear;
        [cell.textLabel setAttributedText:[CommonUtil customAttString:self.dataArray[indexPath.row]
                                                             fontSize:kAppLargeFontSize
                                                            textColor:WCBlack
                                                            charSpace:kAppKern_4]
         ];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height / 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
