//
//  M8MeetListTableView+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListTableView+UI.h"

@implementation M8MeetListTableView (UI)

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 会议记录 + 会议收藏
    if (self.listViewType == M8MeetListViewTypeRecord ||
        self.listViewType == M8MeetListViewTypeCollect)
    {
        M8RecordDetailViewController *destinationVC = [[M8RecordDetailViewController alloc] initWithDataModel:self.dataArray[indexPath.row]];
        destinationVC.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
    }
    // 会议笔记
    else if (self.listViewType == M8MeetListViewTypeNote)
    {
        M8NoteDetailViewController *destinationVC = [[M8NoteDetailViewController alloc] init];
        destinationVC.isExitLeftItem = YES;
        destinationVC.dataModel = self.dataArray[indexPath.row];
        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
    }
    // 会议收藏
//    else if (self.listViewType == M8MeetListViewTypeCollect)
//    {
//        M8CollectDetaiilViewController *destinationVC = [[M8CollectDetaiilViewController alloc] init];
//        destinationVC.isExitLeftItem = YES;
//        destinationVC.dataModel = self.dataArray[indexPath.row];
//        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
//    }

}

@end
