//
//  M8CallRenderCell.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8CallRenderModel.h"

@interface M8CallRenderCell : UICollectionViewCell

- (void)config:(M8CallRenderModel *)model;

- (void)configWithModel:(M8CallRenderModel *)model;

@end
