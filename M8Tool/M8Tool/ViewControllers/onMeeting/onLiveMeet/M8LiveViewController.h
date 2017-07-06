//
//  M8LiveViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MBaseMeetViewController.h"

#import "M8LiveInfoView.h"
#import "M8LivePlayView.h"
#import "M8LiveJoinTableView.h"


@interface M8LiveViewController : MBaseMeetViewController

@property (nonatomic, strong, nullable) UIScrollView    *scrollView;
@property (nonatomic, strong, nullable) M8LivePlayView  *livePlayView;
@property (nonatomic, strong, nullable) M8LiveInfoView  *liveInfoView;
@property (nonatomic, strong, nullable) M8LiveJoinTableView *tableView;

@end
