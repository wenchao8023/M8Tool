//
//  M8LiveViewController+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveViewController+Net.h"

@implementation M8LiveViewController (Net)


- (void)onNetReportRoomInfo
{
    WCWeakSelf(self);
    __block ReportRoomResponseData *reportRoomData = nil;
    ReportRoomRequest *reportReq                   = [[ReportRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        reportRoomData  = (ReportRoomResponseData *)request.response.data;
        weakself.curMid = reportRoomData.mid;
        
    } failHandler:^(BaseRequest *request) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errinfo = [NSString stringWithFormat:@"code=%ld,msg=%@",(long)request.response.errorCode,request.response.errorInfo];
            //            [AlertHelp alertWith:@"上传RoomInfo失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        });
    }];
    
    reportReq.token        = [AppDelegate sharedAppDelegate].token;
    reportReq.room         = [[ShowRoomInfo alloc] init];
    reportReq.room.title   = self.liveItem.info.title;
    reportReq.room.type    = self.liveItem.info.type;
    reportReq.room.roomnum = self.liveItem.info.roomnum;
    reportReq.room.groupid = self.liveItem.info.groupid;
    reportReq.room.cover   = self.liveItem.info.cover.length > 0 ? self.liveItem.info.cover : @"";
    reportReq.room.appid   = [ILiveAppId intValue];
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:reportReq];
}

- (void)onNetReportExitRoom
{
    ExitRoomRequest *exitReq = [[ExitRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        NSLog(@"上报退出房间成功");
    } failHandler:^(BaseRequest *request) {
        NSLog(@"上报退出房间失败");
    }];
    
    exitReq.token   = [AppDelegate sharedAppDelegate].token;
    exitReq.roomnum = self.liveItem.info.roomnum;
    exitReq.type    = self.liveItem.info.type;
    exitReq.mid     = self.curMid;
    [[WebServiceEngine sharedEngine] AFAsynRequest:exitReq];
}


@end
