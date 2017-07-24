//
//  MangerTeamViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, MangerTeamType)
{
    MangerTeamType_Company, //管理公司
    MangerTeamType_Partment //管理部门
};



@interface MangerTeamViewController : BaseViewController

- (instancetype _Nullable )initWithType:(MangerTeamType)type isManager:(BOOL)isManager contactType:(ContactType)contactType;

/**
 进入视图类型
 */
@property (nonatomic, assign) ContactType contactType;

/**
 判断管理的是公司还是部门
 */
@property (nonatomic, assign) MangerTeamType teamType;

/**
 判断是管理者还是员工
 */
@property (nonatomic, assign) BOOL isManger;

/**
 公司信息
 */
@property (nonatomic, strong, nonnull) M8CompanyInfo *cInfo;

/**
 部门信息
 */
@property (nonatomic, strong, nonnull) M8DepartmentInfo *dInfo;

@property (nonatomic, assign)  BOOL isInviteBack;     //判断是不是会议中邀请好友的时候 点击返回，如果是则返回数据，跳过代理，如果不是，就是退出，应该清空数据;


@property (nonatomic, strong) UITableView * _Nullable tableView;

@property (nonatomic, strong, nonnull) UIButton *shareButton;

@property (nonatomic, strong, nonnull) UIButton *addButton;


@property (nonatomic, strong) NSMutableArray * _Nullable sectionArray;

@property (nonatomic, strong) NSMutableArray * _Nullable itemArray;

@property (nonatomic, strong, nonnull) NSMutableArray *statuArray;


@property (nonatomic, copy, nullable) M8VoidBlock ensureAddSelectMembersBlock;

@property (nonatomic, copy, nullable) M8VoidBlock delCompanySucc;


@end
