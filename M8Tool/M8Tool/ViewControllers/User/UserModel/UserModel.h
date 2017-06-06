//
//  UserModel.h
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 加载有关用户界面的数据父类
 */
@interface UserModel : NSObject

@end

// 用户界面数据
@interface UserTableViewModel : UserModel

@property (nonatomic, copy, nullable) NSString *imgStr;

@property (nonatomic, copy, nullable) NSString *titleStr;

@end


// 用户名片数据
@interface UserCardModel : UserModel

@property (nonatomic, copy, nullable) NSString *itemStr;

@property (nonatomic, copy, nullable) NSString *contentStr;

@end
