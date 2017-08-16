//
//  M8CallRenderCell.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M8CallRenderCell : UICollectionViewCell

@property (nonatomic, copy, nullable) M8StrBlock removeBlock;
@property (nonatomic, copy, nullable) M8StrBlock inviteBlock;

- (void)configWithModel:(id _Nullable)model radius:(CGFloat)radius;

@end
