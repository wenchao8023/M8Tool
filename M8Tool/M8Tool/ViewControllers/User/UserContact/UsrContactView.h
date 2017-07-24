//
//  UsrContactView.h
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UsrContactDelegate <NSObject>

- (void)usrContactDidSelectContacts:(NSArray *_Nonnull)contacts;

@end


@interface UsrContactView : UITableView

- (instancetype _Nullable )initWithFrame:(CGRect)frame style:(UITableViewStyle)style contactType:(ContactType)contactType;

@property (nonatomic, assign) ContactType contactType;

@property (nonatomic, weak) id _Nullable WCDelegate;

/**
 第一分组：我的好友，通讯录，常用群组，常用联系人   保存的是字符串信息
 如果有公司：那么会在后面添加公司组织架构          保存的是 Model
 最后一分组：保存一个添加按钮，用于用户添加公司
 */
@property (nonatomic, strong) NSMutableArray * _Nonnull sectionArray;

@property (nonatomic, strong) NSMutableArray * _Nonnull dataArray;

@property (nonatomic, strong) NSArray * _Nonnull actionArray;

@property (nonatomic, assign) NSInteger clickSection;

@property (nonatomic, strong, nullable) NSMutableArray *statuArray;

@property (nonatomic, strong, nonnull) UIAlertAction *saveAction;


- (void)configStatuArray;

- (void)onSubviewAddAction;



@end
