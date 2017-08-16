//
//  M8MeetRecordTableView.h
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8MeetRecordModel.h"

#import "M8RecordDetailViewController.h"
#import "M8CollectDetaiilViewController.h"
#import "M8NoteDetailViewController.h"


@interface M8MeetRecordTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int pageNums;
@property (nonatomic, assign) int pageOffset;

@property (nonatomic, assign) M8MeetListViewType listViewType;




- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style listViewType:(M8MeetListViewType)listViewType;


@end
