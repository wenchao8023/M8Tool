//
//  MeetingButtonsCollection.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingButtonsCollection.h"
#import "MeetingButtonsCell.h"
#import "MeetingLuanchViewController.h"
#import "MeetingOrderViewController.h"
#import "M8MeetListViewController.h"
#import "UserContactViewController.h"



static NSString * const kMeetingButtonsCellID = @"MeetingButtonsCellID";


@interface MeetingButtonsCollection ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@end


@implementation MeetingButtonsCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = WCClear;
//        _myFrame = frame;
        self.delegate               = self;
        self.dataSource             = self;
        self.scrollEnabled          = NO;
        self.delaysContentTouches   = NO;   // 此时当点击的时候会立刻调用点击事件的begin方法，率先变成高亮状态。
        
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MeetingButtonsCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kMeetingButtonsCellID];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    self.frame = _myFrame;
//}

- (NSArray *)titleArray {
    if (!_titleArray) {
        NSArray *titleArray = @[@"语音会议", @"视频会议", @"直播会议", @"手机通话",
                                @"预约会议", @"会议笔记", @"会议收藏", @"通讯录"];
        _titleArray = titleArray;
    }
    return _titleArray;
}
- (NSArray *)imageArray {
    if (!_imageArray) {
        NSArray *imageArray = @[@"btnImg_voiceMeeting", @"btnImg_videoMeeting", @"btnImg_liveMeeting", @"btnImg_phoneMeeting",
                                @"btnImg_meetingOrder", @"btnImg_meetingNote", @"btnImg_meetingCollect", @"btnImg_contact"];
        _imageArray = imageArray;
    }
    return _imageArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:2 itemCountPerRow:4];
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
//    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing       = 0;
//    layout.headerReferenceSize      = CGSizeMake(0, 0);
//    layout.minimumInteritemSpacing  = 0;
//    
//    
//    self.collectionViewLayout   = layout;
//    self.delegate               = self;
//    self.dataSource             = self;
//    self.scrollEnabled          = NO;
//    self.delaysContentTouches   = NO;   // 此时当点击的时候会立刻调用点击事件的begin方法，率先变成高亮状态。
//    
//    
//    [self registerNib:[UINib nibWithNibName:NSStringFromClass([MeetingButtonsCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kMeetingButtonsCellID];
}


#pragma mark -
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeetingButtonsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMeetingButtonsCellID forIndexPath:indexPath];
    
    [cell configWithTitle:self.titleArray[indexPath.row] imageStr:self.imageArray[indexPath.row]];
    
    
    // 设置 cell 底部边框
    [cell setBorder_bottom_color:[UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1] width:1];
    // 设置 cell 侧边边框
    if ((indexPath.row + 1) % 4) {
        [cell setBorder_right_color:[UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1] width:1];
    }
    // 设置 cell 顶部边框
    if (indexPath.row < 4) {
        [cell setBorder_top_color:[UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1] width:1];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MeetingButtonsCell *cell = (MeetingButtonsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = cell.contentView.bounds;
    effectView.alpha = 0.8;
    cell.backgroundView = effectView;
    
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    MeetingButtonsCell *cell = (MeetingButtonsCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
    cell.backgroundView = [WCUIKitControl createViewWithFrame:cell.contentView.bounds BgColor:WCClear];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"第 %f 页", self.contentOffset.x / SCREEN_WIDTH);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WCLog(@"点击第 %ld 个按钮", (long)indexPath.row);
    [self pushViewControllerWithIndex:indexPath.row];
    
    
    
}

#pragma mark - --
- (void)pushViewControllerWithIndex:(NSInteger)index {
    
    if (index == 0 ||
        index == 1 ||
        index == 2 ||
        index == 4) {       //发起 手机会议、视频会议、直播会议、会议预约
        MeetingLuanchViewController *luanchVC = [[MeetingLuanchViewController alloc] init];
        luanchVC.isExitLeftItem = YES;
        luanchVC.luanchMeetingType = index;
        [[AppDelegate sharedAppDelegate] pushViewController:luanchVC];
    }
    else if (index == 3 ||
             index == 7) {  //发起 手机通话，进入 联系人
        UserContactViewController *contactVC = [[UserContactViewController alloc] init];
        contactVC.isExitLeftItem = YES;
        contactVC.contactType = index == 3 ? ContactType_tel : ContactType_contact;
        [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
    }
//    else if (index == 4) {  //发起 会议预约
//        MeetingOrderViewController *orderVC = [[MeetingOrderViewController alloc] init];
//        orderVC.isExitLeftItem = YES;
//        [[AppDelegate sharedAppDelegate] pushViewController:orderVC];
//    }
    else if (index == 5 ||
             index == 6) {  //进入 会议笔记、会议收藏
        M8MeetListViewController *recordvc = [[M8MeetListViewController alloc] init];
        recordvc.listViewType = index - 4;
        recordvc.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:recordvc];
    }
}


@end
