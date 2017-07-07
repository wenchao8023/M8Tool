//
//  MeetingView.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingView.h"

#import "MeetingAgendaCollection.h"
#import "MeetingButtonsCollection.h"

#import "M8MeetWindow.h"
#import "M8LiveViewController.h"


@interface MeetingView ()<AgendaCollectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView                *bannerImage;

@property (weak, nonatomic) IBOutlet MeetingAgendaCollection    *agendaCollection;
@property (weak, nonatomic) IBOutlet MeetingButtonsCollection   *buttonsCollection;
@property (weak, nonatomic) IBOutlet UIPageControl              *pageControl;


@property (weak, nonatomic) IBOutlet UILabel *agendaCollectionHeadLabel;
@property (weak, nonatomic) IBOutlet UIButton *agendaCollectionMoreButton;

@end


@implementation MeetingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_agendaCollectionHeadLabel setAttributedText:[CommonUtil customAttString:@"会议议程"
                                                     fontSize:kAppLargeFontSize
                                                    textColor:WCWhite
                                                    charSpace:kAppKern_0]
     ];
    
    [_agendaCollectionMoreButton.titleLabel setAttributedText:[CommonUtil customAttString:@"更多"
                                                                fontSize:kAppLargeFontSize
                                                               textColor:WCWhite
                                                               charSpace:kAppKern_0]
     ];

    
    self.agendaCollection.agendaDelegate = self;
    
    self.pageControl.pageIndicatorTintColor = WCLightGray;
    self.pageControl.currentPageIndicatorTintColor = WCWhite;
}


- (IBAction)moreAgendaAction:(id)sender {
    WCLog(@"更多会议议程   --> 测试直播");

    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [[ILiveLoginManager getInstance] getLoginId];
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = @"木木的会议";
    item.info.type = @"live";
    item.info.roomnum = 10003;
    item.info.groupid = @"10003";
    item.info.appid = [ShowAppId intValue];
    item.info.host = @"user2";

    M8LiveViewController *baseMeetVC = [[M8LiveViewController alloc] initWithItem:item isHost:NO];
    [M8MeetWindow M8_addMeetSource:baseMeetVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
    
}



#pragma mark - AgendaCollectionDelegate
- (void)AgendaCollectionNumberPage:(int)pageNumber {
    WCLog(@"numberOfPages is : %d", pageNumber);
    self.pageControl.numberOfPages = pageNumber;
    [self.pageControl setWidth:20 * pageNumber];
}

- (void)AgendaCollectionCurrentPage:(int)pageIndex {
    WCLog(@"pageIndex is : %d", pageIndex);
    self.pageControl.currentPage = pageIndex;
}


@end
