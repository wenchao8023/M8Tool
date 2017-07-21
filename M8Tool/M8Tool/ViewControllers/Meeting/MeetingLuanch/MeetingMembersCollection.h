//
//  MeetingMembersCollection.h
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>




/**
 添加 和 移除 之后的数据都要和 最近联系人是否选中状态同步
 */
@protocol MeetingMembersCollectionDelegate <NSObject>

//返回当前删除的用户
- (void)MeetingMembersCollectionDeletedMember:(NSString *_Nullable)delNameStr;
//返回当前的self.height
- (void)MeetingMembersCollectionContentHeight:(CGFloat)contentHeight;
//返回当前的成员
- (void)MeetingMembersCollectionCurrentMembers:(NSArray *_Nullable)currenMembers;

@end



@interface MeetingMembersCollection : UICollectionView


@property (nonatomic, assign) NSInteger totalNumbers;

@property (nonatomic, weak) id<MeetingMembersCollectionDelegate> WCDelegate;


- (void)shouldReloadDataFromSelectContact:(TCIVoidBlock _Nullable )succHandle;


- (void)syncDataMembersArrayWithDic:(NSDictionary *_Nullable)memberInfo ;

- (NSArray *_Nullable)getMembersArray;

@end
