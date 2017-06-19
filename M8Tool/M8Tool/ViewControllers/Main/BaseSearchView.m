//
//  BaseSearchView.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseSearchView.h"

@implementation BaseSearchView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target {
    if (self = [super initWithFrame:frame]) {
        self.delegate = target;
        self.placeholder = @"搜索";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftView = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40)
                                                       ImageName:@"search"
                                                         BgColor:WCClear];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
