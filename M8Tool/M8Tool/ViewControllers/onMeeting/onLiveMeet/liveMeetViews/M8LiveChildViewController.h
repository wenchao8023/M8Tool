//
//  M8LiveChildViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 只用作显示内容区域，不做直接的逻辑处理
 */
@interface M8LiveChildViewController : UIViewController


/**
 同步cell的位置

 @param offsetY 当前cell的 Y 坐标
 */
- (void)updateFrameWithOffsetY:(CGFloat)offsetY;

@end
