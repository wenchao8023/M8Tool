//
//  UsrView.h
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  在创建 View 的时候，不能与 viewController 的 View 同名
 *  否则在创建 xib 文件的时候，会自动绑定到该 viewController，如果没有绑定就会报错，提示为绑定
 */
@interface UsrView : UIView



@end
