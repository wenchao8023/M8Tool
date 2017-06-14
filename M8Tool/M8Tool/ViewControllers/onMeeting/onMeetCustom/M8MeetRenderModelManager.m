//
//  M8MeetRenderModelManager.m
//  M8Tool
//
//  Created by chao on 2017/6/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRenderModelManager.h"

#import "M8MeetRenderModel.h"


@interface M8MeetRenderModelManager ()

@property (nonatomic, strong) NSMutableArray *membersArray;

/**
 记录当前处在背景视图的成员
 */
@property (nonatomic, strong, nullable) M8MeetRenderModel *currentInBackModel;

@end


@implementation M8MeetRenderModelManager

- (NSString *)loginIdentify {
    if (!_loginIdentify) {
        NSString *loginIdentify = [[ILiveLoginManager getInstance] getLoginId];
        _loginIdentify = loginIdentify;
    }
    return _loginIdentify;
}

- (NSMutableArray *)membersArray {
    if (!_membersArray) {
        _membersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _membersArray;
}

#pragma mark - record member with nofified
- (void)memberNotifyWithID:(NSString *)identify {
    // 记录所有发送过通知的成员
    if (![self isMemberNotified:identify]) {
    
        M8MeetRenderModel *model = [[M8MeetRenderModel alloc] init];
        model.identify = identify;
    
        if ([identify isEqualToString:self.hostIdentify])
        {
            model.meetMemberStatus = MeetMemberStatus_receive;
            model.isMicOn = YES;
            model.isCameraOn = YES;
            _currentInBackModel = model;
        }
        else if ([identify isEqualToString:self.loginIdentify])
        {
            model.meetMemberStatus = MeetMemberStatus_receive;
            model.isMicOn = YES;
            model.isCameraOn = YES;
            [self.membersArray addObject:model];
        }
        else
        {
            [self.membersArray addObject:model];
        }
    }
    
    [self reloadMemberModels];
}

#pragma mark - onRecvNotification
#pragma mark -- onLineBusy
- (void)memberLineBusyWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_linebusy;
    [self updateMember:model];
}


#pragma mark -- onReject
- (void)memberRejectInviteWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_reject;
    [self updateMember:model];
}


#pragma mark -- onTimeout
- (void)memberTimeoutWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_timeout;
    [self updateMember:model];
}


#pragma mark -- onWaiting
// 如果上面的两个条件都为 NO，则表示 “接听中”


#pragma mark -- onReceive
- (void)memberReceiveWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_receive;
    [self updateMember:model];
}


#pragma mark -- onDisconnet
- (void)memberDisconnetWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_disconnect;
    [self updateMember:model];
}


#pragma mark -- onHangup
- (void)memberHangupWithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_hangup;
    [self updateMember:model];
}




#pragma mark - onCallMemberEventListener
- (void)onMemberAudioOn:(BOOL)isOn WithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.isMicOn = isOn;
    [self updateMember:model];
}

- (void)onMemberCameraVideoOn:(BOOL)isOn WithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getMemberWithID:identify];
    model.isCameraOn = isOn;
    [self updateMember:model];
}


#pragma mark - on action
- (BOOL)onSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isExitVideoCaption]) {
        M8MeetRenderModel *tempModel;
        if (_currentInBackModel) {
            tempModel = _currentInBackModel;
            _currentInBackModel = self.membersArray[indexPath.row];
            [self.membersArray replaceObjectAtIndex:[self getMemberIndexInArray:_currentInBackModel.identify] withObject:tempModel];
        }
        else {
            _currentInBackModel = self.membersArray[indexPath.row];
            [self.membersArray removeObjectAtIndex:indexPath.row];
        }
        
        [self respondsToDelegate];
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - private actions

#pragma mark -- get member model
- (M8MeetRenderModel *)getMemberWithID:(NSString *)identify {
    if ([identify isEqualToString:_currentInBackModel.identify]) {
        return _currentInBackModel;
    }
    else {
        for (M8MeetRenderModel *model in self.membersArray) {
            if ([model.identify isEqualToString:identify]) {
                return model;
            }
        }
    }
    NSAssert(0, @"此时房间没成员");
    return nil;
}


#pragma mark -- update member model in container
- (void)updateMember:(M8MeetRenderModel *)newModel {
    if ([newModel.identify isEqualToString:_currentInBackModel.identify])
    {
        _currentInBackModel = newModel;
    }
    else
    {
        if (self.membersArray.count && newModel) {
            [self.membersArray replaceObjectAtIndex:[self getMemberIndexInArray:newModel.identify] withObject:newModel];
        }
    }
    
    [self reloadMemberModels];
}


#pragma mark -- get member index in member array
- (NSInteger)getMemberIndexInArray:(NSString *)identify {
    return [self.membersArray indexOfObject:[self getMemberWithID:identify]];
}


#pragma mark -- member notified
- (BOOL)isMemberNotified:(NSString *)identify {
    if ([identify isEqualToString:_currentInBackModel.identify]) {
        return YES;
    }
    else {
        for (M8MeetRenderModel *model in self.membersArray) {
            if ([model.identify isEqualToString:identify])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark --
- (BOOL)isExitVideoCaption {
    if (_currentInBackModel.isCameraOn) {
        return YES;
    }
    else {
        for (M8MeetRenderModel *model in self.membersArray) {
            if (model.isCameraOn) {
                return YES;
            }
        }
    }

    return NO;
}

#pragma mark -- reload member models in array and currentModel
- (void)reloadMemberModels {
    if (!_currentInBackModel.isCameraOn) {
        for (M8MeetRenderModel *model in self.membersArray) {
            if (model.isCameraOn) { // 交换成员信息
                if (_currentInBackModel == nil) {
                    _currentInBackModel = model;
                    [self.membersArray removeObject:model];
                }
                else {
                    M8MeetRenderModel *tempModel = _currentInBackModel;
                    _currentInBackModel = model;
                    [self.membersArray replaceObjectAtIndex:[self getMemberIndexInArray:model.identify]
                                                 withObject:tempModel];
                }
                // 刷新视图 并终止循环
                [self respondsToDelegate];
                return ;
            }
        }
        
        // 没有成员开启摄像头
        if (_currentInBackModel) {
            [self.membersArray addObject:_currentInBackModel];
            _currentInBackModel = nil;  // 只有房间中没有成员开启摄像头时 currentModel 才会置空
        }
    }
    
    // 只要处在背景视图的成员开启摄像头，就直接给这个成员设置视图显示区域
    [self respondsToDelegate];
}

#pragma mark - respondsToDelegate
- (void)respondsToDelegate {
    if ([self.WCDelegate respondsToSelector:@selector(renderModelManager:currentModel:membersArray:)]) {
        [self.WCDelegate renderModelManager:self
                               currentModel:self.currentInBackModel
                               membersArray:self.membersArray
         ];
    }
}



@end