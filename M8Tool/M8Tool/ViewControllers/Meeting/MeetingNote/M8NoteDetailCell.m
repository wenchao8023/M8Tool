//
//  M8NoteDetailCell.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8NoteDetailCell.h"

#import "M8NoteDetailModel.h"


static const CGFloat kContentTrailing_buttonHidden = 10;
static const CGFloat kContentTrailing_buttonUnHidden = 50;


@interface M8NoteDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *showAllButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Layout_contentTrailing;

@end




@implementation M8NoteDetailCell


- (void)configWithModel:(M8NoteDetailModel *)model hiddenShowAll:(BOOL)isShowAll {
    if (isShowAll) {
        self.showAllButton.hidden = NO;
        self.Layout_contentTrailing.constant = kContentTrailing_buttonUnHidden;
    }
    else {
        self.showAllButton.hidden = YES;
        self.Layout_contentTrailing.constant = kContentTrailing_buttonHidden;
    }
    
    self.identifyLabel.text = model.noteDetailIdentify;
    self.contentLabel.text  = model.noteDetailContent;
    self.timeLabel.text     = model.noteDetailTime;
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
