//
//  M8CallNoteCell.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallNoteCell.h"
#import "M8CallNoteModel.h"


@interface M8CallNoteCell ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end





@implementation M8CallNoteCell


- (void)configWithModel:(M8CallNoteModel *)model
{
//    WCViewBorder_Radius(self.effectView, 4);
    
    if (model.name)
    {
        if (model.tipInfo)
        {
            self.infoLable.text = [NSString stringWithFormat:@"%@ %@", model.name, model.tipInfo];
        }
        else if (model.msgInfo)
        {
            self.infoLable.text = [NSString stringWithFormat:@"%@ %@", model.name, model.msgInfo];
        }
    }
    else
    {
        if (model.tipInfo)
        {
            self.infoLable.text = [NSString stringWithFormat:@"%@", model.tipInfo];
        }
    }
}













- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
