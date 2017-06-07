//
//  UsrCardView.m
//  M8Tool
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrCardView.h"
#import "UsrCardViewCell.h"

#import "UserHeadIconViewController.h"


static const CGFloat kHeadHeight = 88;



@interface UsrCardView ()<UITableViewDelegate, UITableViewDataSource, ModifyViewDelegate>


/**
 item 名
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;

/**
 保存方法名
 */
@property (nonatomic, strong) NSArray *actionsArray;

@end

@implementation UsrCardView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = WCClear;
        self.delegate = self;
        self.dataSource = self;
        self.tableHeaderView = [WCUIKitControl createViewWithFrame:CGRectZero];
        self.tableFooterView = [WCUIKitControl createViewWithFrame:CGRectZero];
        [self registerNib:[UINib nibWithNibName:@"UsrCardViewCell" bundle:nil] forCellReuseIdentifier:@"UsrCardViewCellID"];
        
        [self loadData];
    }
    return self;
}


- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:0];
        _itemsArray = itemsArray;
    }
    return _itemsArray;
}

- (NSArray *)actionsArray {
    if (!_actionsArray) {
        NSArray *actionsArray = @[@"onIconAction", @"onNickNameAction:", @"onPhoneNumberAction:",
                                  @"onSexAction:", @"onBirthdayAction", @"onAddressAction", @"onQRCodeAction", ];
        _actionsArray = actionsArray;
    }
    return _actionsArray;
}

- (void)loadData {
    NSArray *itemsArr = @[@"头像", @"昵称", @"电话", @"性别", @"生日", @"地区", @"我的二维码"];
    NSArray *contentArr = @[@"", @"木木", @"13012345678", @"不详", @"2001.03.08", @"八国混血", @"太丑"];
    for (int i = 0; i < itemsArr.count; i++) {
        UserCardModel *model = [UserCardModel new];
        model.itemStr = itemsArr[i];
        model.contentStr = contentArr[i];
        [self.itemsArray addObject:model];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UsrCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrCardViewCellID" forIndexPath:indexPath];

    [cell config:self.itemsArray[indexPath.row] isFirstItem:(indexPath.row == 0) isLastItem:(indexPath.row == self.itemsArray.count - 1)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row ? kDefaultCellHeight : kHeadHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selStr = self.actionsArray[indexPath.row];
    if ([selStr containsString:@":"])
        [self performSelector:NSSelectorFromString(selStr) withObject:indexPath];
    else
        [self performSelector:NSSelectorFromString(selStr)];
}


#pragma mark - actions
- (void)onIconAction {
    WCLog(@"头像");
    UserHeadIconViewController *headVC = [[UserHeadIconViewController alloc] init];
    headVC.isExitLeftItem = YES;
    headVC.headerTitle    = @"头像";
    headVC.imgStr         = @"jinshenku";
    [[AppDelegate sharedAppDelegate] pushViewController:headVC];
}

- (void)onNickNameAction:(NSIndexPath *)indexPath {
    [self pushToModify:indexPath];
}

- (void)onPhoneNumberAction:(NSIndexPath *)indexPath {
    [self pushToModify:indexPath];
}

- (void)onSexAction:(NSIndexPath *)indexPath {
    [self pushToModify:indexPath];
}

- (void)onBirthdayAction {
    WCLog(@"生日");
}

- (void)onAddressAction {
    WCLog(@"地区");
}

- (void)onQRCodeAction {
    WCLog(@"二维码");
}

- (void)pushToModify:(NSIndexPath *)indexPath {
    
    UserCardModel *model = self.itemsArray[indexPath.row];
    
    ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
    modifyVC.naviTitle      = model.itemStr;
    modifyVC.originContent  = model.contentStr;
    modifyVC.modifyType     = Modify_text;
    modifyVC.indexPath      = indexPath;
    modifyVC.WCDelegate     = self;
    [[AppDelegate sharedAppDelegate] pushViewController:modifyVC];
}

#pragma mark - ModifyViewDelegate
- (void)modifyViewMofifyInfo:(NSDictionary *)modifyInfo indexPath:(NSIndexPath *)indexPath {
    if ([[[modifyInfo allKeys] firstObject] isEqualToString:@"text"]) {
        
        NSString *text = [modifyInfo objectForKey:@"text"];
        
        UserCardModel *model = self.itemsArray[indexPath.row];
        model.contentStr = text;
        [self.itemsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        [self reloadData];
    }
    
    
    
}

@end
