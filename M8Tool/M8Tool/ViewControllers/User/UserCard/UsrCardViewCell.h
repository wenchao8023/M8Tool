//
//  UsrCardViewCell.h
//  M8Tool
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UsrCardViewCell : UITableViewCell

- (void)config:(UserCardModel *)model isFirstItem:(BOOL)isFirstItem isLastItem:(BOOL)isLastItem;
//- (void)config:(NSString *)contentStr item:(NSString *)itemStr;

@end
