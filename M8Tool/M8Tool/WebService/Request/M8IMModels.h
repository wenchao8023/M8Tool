//
//  M8IMModels.h
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IMSDK中 用户信息字段 tag
 */
static NSString * _Nonnull const kSnsProfileItemTag_Nick = @ "Tag_Profile_IM_Nick";


@interface M8IMModels : NSObject

@end



@interface M8FriendInfo : NSObject

@property (nonatomic, copy, nullable) NSString *Info_Account;
@property (nonatomic, strong, nullable) NSArray *SnsProfileItem;

@end
