//
//  M8LiveLabel.m
//  M8Tool
//
//  Created by chao on 2017/6/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveLabel.h"

@implementation M8LiveLabel

- (void)configLiveText {
    self.shadowColor     = kLiveStrokeColor;
    self.shadowOffset    = kLiveShadowOffset;
    self.shadowBlur      = kLiveShadowBlur;
    self.strokeColor     = kLiveStrokeColor;
    self.strokeSize      = kLiveStrokeSize;
    self.textColor       = WCWhite;
}

- (void)configLiveRenderText {
    self.shadowColor     = kLiveStrokeColor;
    self.shadowOffset    = kLiveShadowOffset;
    self.shadowBlur      = kLiveShadowBlur / 2;
    self.strokeColor     = kLiveStrokeColor;
    self.strokeSize      = kLiveStrokeSize;
    self.textColor       = WCWhite;
}

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//}


@end
