//
//  LatestMembersCollection.h
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LatestMembersCollectionDelegate <NSObject>

/**
 返回选择用户之后的状态

 @param memberInfo {key: 用户id, value: 是否被选中 @"1"-表示选中 @"0"-表示反选}
 */
- (void)LatestMembersCollectionDidSelectedMembers:(NSDictionary *)memberInfo;

@end



@interface LatestMembersCollection : UICollectionView

@property (nonatomic, assign) NSInteger totalNumbers;

@property (nonatomic, weak) id WCDelegate;


- (void)syncDataMembersArrayWithIdentifier:(NSString *)identifier;
- (void)syncCurrentNumbers:(NSInteger)currentNumbers;

@end
