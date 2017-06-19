//
//  RecordDetailCollectionHeader.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordDetailCollectionHeader.h"



@interface RecordDetailCollectionHeader ()
{
    CGRect _myFrame;
}


@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;

@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;

@property (weak, nonatomic) IBOutlet UILabel *unresponseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statuImg;

@end

@implementation RecordDetailCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    self.frame = _myFrame;
}

- (void)config:(NSArray *)array {
    self.unresponseLabel.text = [NSString stringWithFormat:@"%ld人", array.count];
}

@end
