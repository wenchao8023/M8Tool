//
//  M8CallViewController+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+Net.h"

@implementation M8CallViewController (Net)

- (void)onNetReportRoomInfo
{
    WCWeakSelf(self);
    __block ReportRoomResponseData *reportRoomData = nil;
    ReportRoomRequest *reportReq = [[ReportRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        reportRoomData = (ReportRoomResponseData *)request.response.data;
        weakself.curMid = reportRoomData.mid;
        [weakself addTextToView:[NSString stringWithFormat:@"%d", reportRoomData.mid]];
        [weakself addTextToView:@"上报房间信息成功"];
        
    } failHandler:^(BaseRequest *request) {
        
        // 上传失败
        [weakself addTextToView:@"上报房间信息失败"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errinfo = [NSString stringWithFormat:@"code=%ld,msg=%@",(long)request.response.errorCode,request.response.errorInfo];
            [AlertHelp alertWith:@"上传RoomInfo失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        });
    }];
    
    reportReq.token = [AppDelegate sharedAppDelegate].token;
    reportReq.members = self.liveItem.members;
    reportReq.room = [[ShowRoomInfo alloc] init];
    reportReq.room.title = self.liveItem.info.title;
    reportReq.room.type = self.liveItem.info.type;
    reportReq.room.roomnum = self.liveItem.info.roomnum;
    reportReq.room.groupid = self.liveItem.info.groupid;
    reportReq.room.appid = [ShowAppId intValue];
    
    [[WebServiceEngine sharedEngine] asyncRequest:reportReq];
}

#pragma mark - 上报成员信息
- (void)onNetReportCallMem:(NSString *)mem statu:(int)statu
{
    WCWeakSelf(self);
    ReportCallMemRequest *reportMemReq = [[ReportCallMemRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        [weakself addTextToView:[NSString stringWithFormat:@"上报成员:%@ -- 状态:%d, 成功", mem, statu]];
        
    } failHandler:^(BaseRequest *request) {
        
        [weakself addTextToView:[NSString stringWithFormat:@"上报成员状态失败\n错误码:%ld，错误信息: %@", (long)request.response.errorCode, request.response.errorInfo]];
    }];
    
    reportMemReq.token = [AppDelegate sharedAppDelegate].token;
    reportMemReq.uid = mem;
    reportMemReq.mid = self.curMid;
    reportMemReq.statu = [NSString stringWithFormat:@"%d", statu];
    [[WebServiceEngine sharedEngine] asyncRequest:reportMemReq];
}

- (void)onNetReportExitRoom
{
    //通知业务服务器，退房
    ExitRoomRequest *exitReq = [[ExitRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        NSLog(@"上报退出房间成功");
    } failHandler:^(BaseRequest *request) {
        NSLog(@"上报退出房间失败");
    }];
    
    exitReq.token   = [AppDelegate sharedAppDelegate].token;
    exitReq.type    = self.liveItem.info.type;
    exitReq.roomnum = self.liveItem.info.roomnum;
    [[WebServiceEngine sharedEngine] asyncRequest:exitReq wait:NO];
}
@end
