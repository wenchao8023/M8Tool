//
//  M8CallRenderModelManger.m
//  M8Tool
//
//  Created by chao on 2017/7/20.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderModelManger.h"
#import "M8CallRenderModel.h"



@interface M8CallRenderModelManger()

@property (nonatomic, copy, nullable) NSString *hostIdentify;
@property (nonatomic, copy, nullable) NSString *loginIdentify;
@property (nonatomic, assign) TILCallType callType;

@property (nonatomic, strong) NSMutableArray *inviteArray;     //记录会议开始前邀请的成员

/**
 记录当前处在背景视图的成员
 
 * 音频模式下 currentModel 一直为空
 * 视频模式下 根据用户操作进行设置
 * 在最后回调的时候将数据重新分离并回传
 */
//@property (nonatomic, strong, nullable) M8CallRenderModel *currentModel;

@end




@implementation M8CallRenderModelManger

- (instancetype)initWithItem:(TCShowLiveListItem *)item
{
    if (self = [super init])
    {
        self.hostIdentify   = item.info.host;
        self.loginIdentify  = item.uid;
        self.callType       = item.callType;
        
        [self initInviteArray];
    }
    return self;
}

/**
 初始化成员数组，这里的成员来自单例中保存的邀请的人的信息，self在初始值是在最前面
 */
- (void)initInviteArray
{
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    
    NSMutableArray *inviteArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MemberInfo *memberInfo in modelManger.inviteMemberArray)
    {
        M8CallRenderModel *model = [[M8CallRenderModel alloc] init];
        model.identify = memberInfo.uid;
        model.nick = memberInfo.nick;
        
        if ([model.identify isEqualToString:self.loginIdentify] ||
            [model.identify isEqualToString:self.hostIdentify])
        {
            model.meetMemberStatus = MeetMemberStatus_receive;
        }
        
        [inviteArr addObject:model];
    }
    
    [self.inviteArray removeAllObjects];
    [self.inviteArray addObjectsFromArray:inviteArr];
}

- (NSMutableArray *)inviteArray
{
    if (!_inviteArray)
    {
        _inviteArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _inviteArray;
}


#pragma mark - onRecvNotification
#pragma mark -- onLineBusy
- (void)memberLineBusyWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_linebusy;
    [self updateMember:model];
}


#pragma mark -- onReject
- (void)memberRejectInviteWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_reject;
    [self updateMember:model];
}


#pragma mark -- onTimeout
- (void)memberTimeoutWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_timeout;
    [self updateMember:model];
}


#pragma mark -- onWaiting (private)
- (void)memberWaitingWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_none;
    [self updateMember:model];
}



#pragma mark -- onReceive
- (void)memberReceiveWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_receive;
    [self updateMember:model];
}


#pragma mark -- onDisconnet
- (void)memberDisconnetWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_disconnect;
    [self updateMember:model];
}


#pragma mark -- onHangup
- (void)memberHangupWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_hangup;
    [self updateMember:model];
}


#pragma mark -- onUserAction
- (void)memberUserAction:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    [model onUserActionBegin];
    
    model.userActionEndAutom = ^{
        
        WCLog(@"操作时间已过");
    };
    
    [self updateMember:model];
}

- (void)memberUserAction:(NSString *)identify onAction:(NSString *)actionStr
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    if ([actionStr isEqualToString:@"invite"])
    {
        [model onUserActionEnd];
    }
    else if ([actionStr isEqualToString:@"remove"])
    {
        
    }
    [self updateMember:model];
}


#pragma mark - onCallMemberEventListener
- (void)onMemberAudioOn:(BOOL)isOn WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.isMicOn = isOn;
    [self updateMember:model];
}

- (void)onMemberCameraVideoOn:(BOOL)isOn WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.isCameraOn = isOn;
    [self updateMember:model];
}



#pragma mark - on action
- (BOOL)onSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self isExitVideoCaption])
//    {
//        M8CallRenderModel *tempModel;
//        if (_currentModel)
//        {
//            tempModel = _currentModel;
//            _currentModel = self.membersArray[indexPath.row];
//            [self.membersArray replaceObjectAtIndex:[self getMemberIndexInArray:_currentModel.identify] withObject:tempModel];
//        }
//        else
//        {
//            _currentModel = self.membersArray[indexPath.row];
//            [self.membersArray removeObjectAtIndex:indexPath.row];
//        }
//        
//        [self respondsToDelegate];
//        return YES;
//    }
//    else {
//        return NO;
//    }
    return NO;
}

- (void)onCollectionDidSelectModel:(M8CallRenderModel *)selectedModel
{
    //如果不是接听中、或者是已接听，就表示重新call
    if (!(selectedModel.meetMemberStatus == MeetMemberStatus_none ||
        selectedModel.meetMemberStatus == MeetMemberStatus_receive))
    {
        [self memberUserAction:selectedModel.identify];        
//        if ([self.WCDelegate respondsToSelector:@selector(renderModelManger:inviteMember:)])
//        {
//            
//        }
    }
    else
    {
        if (selectedModel.isCameraOn)
        {
            NSInteger index = [self getMemberIndexInArray:selectedModel.identify];
            if (index == 0)
            {
                NSAssert(1, @"点击的cell在数组中下标不能为0");
            }
            else
            {
                [self.inviteArray exchangeObjectAtIndex:index withObjectAtIndex:0];
            }
        }
        
        [self reloadMemberModels];
    }
}


#pragma mark -- on back from floatView
- (void)onBackFromFloatView
{
    [self respondsToDelegate];
}


#pragma mark -- on get host camera statu
- (BOOL)onGetHostCameraStatu
{
    M8CallRenderModel *hostModel = [self getMemberWithID:self.hostIdentify];
    return hostModel.isCameraOn;
}

#pragma mark - private actions
#pragma mark -- get member model
- (M8CallRenderModel *)getMemberWithID:(NSString *)identify
{
    for (M8CallRenderModel *model in self.inviteArray)
    {
        if ([model.identify isEqualToString:identify])
        {
            return model;
        }
    }
    
    NSAssert(0, @"此时房间没成员");
    return nil;
}


#pragma mark -- update member model in container
- (void)updateMember:(M8CallRenderModel *)newModel
{
    if (self.inviteArray.count && newModel)
    {
        [self.inviteArray replaceObjectAtIndex:[self getMemberIndexInArray:newModel.identify] withObject:newModel];
    }
    
    [self reloadMemberModels];
}


#pragma mark -- get member index in member array
- (NSInteger)getMemberIndexInArray:(NSString *)identify
{
    return [self.inviteArray indexOfObject:[self getMemberWithID:identify]];
}


#pragma mark -- 房间内是否存在视频流
- (BOOL)isExitVideoCaption
{
    for (M8CallRenderModel *model in self.inviteArray)
    {
        if (model.isCameraOn)
        {
            return YES;
        }
    }

    return NO;
}

#pragma mark -- reload member models in array and currentModel
- (void)reloadMemberModels
{

    /** 重新设置数组中元素的顺序
     *  有视频流 >> 有(无)音频流 >> 挂断 >> 接听中 >> 未响应 >> 用户忙 >> 拒绝
     */
    NSMutableArray *videoArr    = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *audioArr    = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *hangupArr   = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *callingArr  = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *timeoutArr  = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *busyArr     = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *rejectArr   = [NSMutableArray arrayWithCapacity:0];
    
    for (M8CallRenderModel *model in self.inviteArray)
    {
        switch (model.meetMemberStatus)
        {
            case MeetMemberStatus_receive:
            {
                if (model.isCameraOn)
                {
                    [videoArr addObject:model];
                }
                else
                {
                    [audioArr addObject:model];
                }
            }
                break;
            case MeetMemberStatus_hangup:
            {
                [hangupArr addObject:model];
            }
                break;
            case MeetMemberStatus_none:
            {
                [callingArr addObject:model];
            }
                break;
            case MeetMemberStatus_timeout:
            {
                [timeoutArr addObject:model];
            }
                break;
            case MeetMemberStatus_linebusy:
            {
                [busyArr addObject:model];
            }
                break;
            case MeetMemberStatus_reject:
            {
                [rejectArr addObject:model];
            }
                break;
                
            default:
                break;
        }
    }
    
    [self.inviteArray removeAllObjects];
    [self.inviteArray addObjectsFromArray:videoArr];
    [self.inviteArray addObjectsFromArray:audioArr];
    [self.inviteArray addObjectsFromArray:hangupArr];
    [self.inviteArray addObjectsFromArray:callingArr];
    [self.inviteArray addObjectsFromArray:timeoutArr];
    [self.inviteArray addObjectsFromArray:busyArr];
    [self.inviteArray addObjectsFromArray:rejectArr];
    
    [self respondsToDelegate];
}

#pragma mark - respondsToDelegate
- (void)respondsToDelegate
{
    //分离 inviteArray
    //  bgViewModel     : 如果有视频流，则将最前面有视频流的成员保存
    //  renderViewArr   : 保存其他处在 renderView 中的成员
    
    M8CallRenderModel *bgViewModel = nil;
    
    NSMutableArray *renderViewArr = [NSMutableArray arrayWithCapacity:0];
    for (M8CallRenderModel *model in self.inviteArray)
    {
        if (model.isCameraOn &&
            !bgViewModel)
        {
            bgViewModel = model;
            continue;
        }
        
        [renderViewArr addObject:model];
    }
    
    
    if ([self.WCDelegate respondsToSelector:@selector(renderModelManager:bgViewIdentify:renderViewArray:)])
    {
        NSString *bgViewIdentify = nil;
        if (bgViewModel)
        {
            bgViewIdentify = bgViewModel.identify;
        }
        
        [self.WCDelegate renderModelManager:self
                             bgViewIdentify:bgViewIdentify
                            renderViewArray:renderViewArr
         ];
    }
}




@end
