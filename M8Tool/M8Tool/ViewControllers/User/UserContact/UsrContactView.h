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

@property (nonatomic, weak) id _Nullable WCDelegate;

/**
 分组标题
 默认是：我的好友，通讯录，常用群组，常用联系人
 如果有公司：那么会在后面添加公司组织架构
 */
@property (nonatomic, strong) NSMutableArray * _Nonnull sectionArray;

@property (nonatomic, strong) NSMutableArray * _Nonnull dataArray;



@end
