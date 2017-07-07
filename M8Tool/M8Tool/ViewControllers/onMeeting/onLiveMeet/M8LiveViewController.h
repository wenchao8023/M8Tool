//
//  M8LiveViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseMeetViewController.h"

#import "M8LiveJoinTableView.h"
#import "M8LivePlayView.h"
#import "M8LiveInfoView.h"

#import "M8LiveHeaderView.h"
#import "M8LiveNoteView.h"
#import "M8MeetDeviceView.h"


@interface M8LiveViewController : M8BaseMeetViewController

/**
 视图层级
 self.view ->   tableView
 self.view ->   livePlayView
 self.view ->   scrollView
 self.view ->   liveInfoView
 
                liveInfoView -> headerView
                liveInfoView -> noteView
                liveInfoView -> deviceView
 */
@property (nonatomic, strong, nullable) M8LiveJoinTableView *tableView;
@property (nonatomic, strong, nullable) M8LivePlayView  *livePlayView;
@property (nonatomic, strong, nullable) UIScrollView    *scrollView;
@property (nonatomic, strong, nullable) M8LiveInfoView  *liveInfoView;

@property (nonatomic, strong, nullable) M8LiveHeaderView *headerView;
@property (nonatomic, strong, nullable) M8LiveNoteView   *noteView;
@property (nonatomic, strong, nullable) M8MeetDeviceView *deviceView;



/**
 DataSource
 */
@property (nonatomic, strong, nullable) NSMutableArray *identifierArray;
@property (nonatomic, strong, nullable) NSMutableArray *srcTypeArray;

@end
