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


@property (nonatomic, strong) UITableView * _Nullable tableView;

@property (nonatomic, strong, nonnull) UIButton *shareButton;

@property (nonatomic, strong, nonnull) UIButton *addButton;


@property (nonatomic, strong) NSMutableArray * _Nullable sectionArray;

@property (nonatomic, strong) NSMutableArray * _Nullable itemArray;

@property (nonatomic, strong, nonnull) NSMutableArray *statuArray;


@property (nonatomic, copy, nullable) TCIVoidBlock ensureAddSelectMembersBlock;


@end
