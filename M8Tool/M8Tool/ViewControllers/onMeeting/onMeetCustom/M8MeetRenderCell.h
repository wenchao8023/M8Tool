//
//  M8MeetRenderCell.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8MeetRenderModel.h"

@interface M8MeetRenderCell : UICollectionViewCell

- (void)config:(M8MeetRenderModel *)model;

- (void)configWithModel:(M8MeetRenderModel *)model;

@end
