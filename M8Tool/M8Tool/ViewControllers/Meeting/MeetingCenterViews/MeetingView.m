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
#import "M8LiveJoinViewController.h"



/////////////////////////////////////////////////
/**
 添加 ‘会议议程’ 标题，和 ‘更多’ 按钮
 */
@interface AgendaHeaderView : UICollectionReusableView

@end


@implementation AgendaHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createHeaderUI];
    }
    return self;
}

- (void)createHeaderUI {
    UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(20, 0, 80, self.height)
                                                          Text:@"会议议程"
                                                      FontSize:kAppLargeFontSize
                                                       BgColor:WCClear
                           ];
    [titleLabel setAttributedText:[CommonUtil customAttString:@"会议议程"
                                                          fontSize:kAppLargeFontSize
                                                         textColor:WCWhite
                                                         charSpace:kAppKern_0]
     ];
    
    [self addSubview:titleLabel];
    
    UIButton *moreButton = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 60, self.height)
                                                       ImageName:@""
                                                          Target:self
                                                          Action:@selector(moreAgendaAction)
                                                           Title:@"更多"
                            ];
    
    [moreButton.titleLabel setAttributedText:[CommonUtil customAttString:@"更多"
                                                     fontSize:kAppLargeFontSize
                                                    textColor:WCWhite
                                                    charSpace:kAppKern_0]
     ];
    [self addSubview:moreButton];
}

- (void)moreAgendaAction {
    WCLog(@"点击去更多会议议程");
    
}

@end
/////////////////////////////////////////////////


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

- (MeetingAgendaCollection *)agendaCollection {
    if (!_agendaCollection) {
        
    }
    return _agendaCollection;
}

- (MeetingButtonsCollection *)buttonsCollection {
    if (!_buttonsCollection) {
        
    }
    return _buttonsCollection;
}

- (IBAction)moreAgendaAction:(id)sender {
    WCLog(@"更多会议议程   --> 测试直播");
    M8LiveJoinViewController *joinVC = [[M8LiveJoinViewController alloc] init];
    joinVC.host = @"user1";
    joinVC.roomId = 101401;
    [M8MeetWindow M8_addLiveSource:joinVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
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
