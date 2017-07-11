//
//  M8RecordDetailCollectionHeader.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecordDetailCollectionHeader.h"



@interface M8RecordDetailCollectionHeader ()
{
    CGRect _myFrame;
}


@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;

@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;

@property (weak, nonatomic) IBOutlet UILabel *unresponseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statuImg;

@end

@implementation M8RecordDetailCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.frame = _myFrame;
}

- (void)configRecNum:(NSInteger)recNum rejNum:(NSInteger)rejNum unrNum:(NSInteger)unrNum
{
    self.recieveLabel.text      = [self numString:recNum];
    self.rejectLabel.text       = [self numString:rejNum];
    self.unresponseLabel.text   = [self numString:unrNum];
}

- (NSString *)numString:(NSInteger)num
{
    return [NSString stringWithFormat:@"%ld人", num];
}
@end
