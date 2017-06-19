//
//  BaseSearchView.h
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


static const CGFloat kSearchView_height = 40.f;


@interface BaseSearchView : UITextField

- (instancetype)initWithFrame:(CGRect)frame target:(id)target;

@end
