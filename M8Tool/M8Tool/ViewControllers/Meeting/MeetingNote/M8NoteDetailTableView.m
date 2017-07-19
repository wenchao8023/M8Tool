//
//  M8NoteDetailTableView.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8NoteDetailTableView.h"

#import "M8MeetRecordModel.h"


@interface M8NoteDetailTableView () ///<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) M8MeetRecordModel *dataModel;


@end


@implementation M8NoteDetailTableView

//- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataModel:(M8MeetRecordModel *)model {
//    if (self = [super initWithFrame:frame style:style]) {
//        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.backgroundColor = WCClear;
//        self.scrollEnabled = NO;
//        self.delegate   = self;
//        self.dataSource = self;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        _dataModel = model;
//    }
//    
//    return self;
//}

- (void)shareAction {
    WCLog(@"分享");
}

@end
