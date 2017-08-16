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

@property (nonatomic, assign) TILCallType callType;
@property (nonatomic, copy, nullable) NSString *groupId;
@property (nonatomic, copy, nullable) NSString *hostIdentify;
@property (nonatomic, copy, nullable) NSString *loginIdentify;

@property (nonatomic, strong) NSMutableArray *invitedArray;     //记录会议历史邀请的成员

@end




@implementation M8CallRenderModelManger

- (instancetype)initWithItem:(TCShowLiveListItem *)item
{
    if (self = [super init])
    {
        self.loginIdentify  = item.uid;
        self.callType       = item.callType;
        self.hostIdentify   = item.info.host;
        self.groupId        = item.info.groupid;
    }
    return self;
}

- (NSMutableArray *)invitedArray
{
    if (!_invitedArray)
    {
        _invitedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _invitedArray;
}


- (void)loadInvitedArray:(NSArray *)members
{
    // 只添加不再房间中的成员 - 音视频通知发生在了这里之前
    NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:0];
    for (TILCallMember *member in members)
    {
        if (![self getMemberExistInRoomWithID:member.identifier])
        {
            M8CallRenderModel *model = [[M8CallRenderModel alloc] initWithTILCallMember:member];
            [self.invitedArray addObject:model];
            
            [idArray addObject:member.identifier];
        }
        else if (!((M8CallRenderModel *)[self getMemberWithID:member.identifier].nick)) //昵称为空的成员需要去获取昵称
        {
            [idArray addObject:member.identifier];
        }
    }
    
    WCWeakSelf(self);
    // 获取成员昵称
    [[TIMFriendshipManager sharedInstance] GetUsersProfile:idArray succ:^(NSArray *friends) {
        
        for (TIMUserProfile *userProfile in friends)
        {
            [weakself memberNick:userProfile.nickname WithID:userProfile.identifier];
        }
        
        // 获取在房间内的成员
        [[TIMGroupManager sharedInstance] GetGroupMembers:self.groupId succ:^(NSArray *members) {
            
            for (TIMGroupMemberInfo *mInfo in members)
            {
                [weakself memberIsInRoom:YES WithID:mInfo.member];
            }
            
            [weakself reloadInvitedArray];
            
        } fail:^(int code, NSString *msg) {
            
        }];
        
    } fail:^(int code, NSString *msg) {
        
    }];
}


- (void)reloadInvitedArray
{
    NSArray *tempInvitedArr = [NSArray arrayWithArray:self.invitedArray];
    for (M8CallRenderModel *model in tempInvitedArr)
    {
        if (model.isInRoom)
        {
            if (model.isMicOn ||
                model.isCameraOn)
            {
                model.meetMemberStatus = MeetMemberStatus_receive;
                model.isInRoom = YES;
                model.isRemoved = NO;
            }
            else
            {
                model.meetMemberStatus = MeetMemberStatus_none;
            }
        }
        
        [self updateMember:model];
    }
    
    [self reloadMemberModels];
}


- (void)memberNick:(NSString *)nick WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    if (!model.nick)
    {
        model.nick = nick;
        [self updateMember:model];
    }
}

- (void)memberIsInRoom:(BOOL)isInRoom WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.isInRoom = isInRoom;
    [self updateMember:model];
}






#pragma mark - on action
#pragma mark -- onUserAction (handle members without in room)
- (void)memberUserAction:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    [model onUserActionBegin];
    
    WCWeakSelf(self);
    model.userActionEndAutom = ^(id selfPtr) {
        
        if ([selfPtr isKindOfClass:[M8CallRenderModel class]])
        {
            [weakself updateMember:(M8CallRenderModel *)selfPtr];
        }
    };
    
    [self updateMember:model];
}

- (void)memberUserAction:(NSString *)identify onAction:(NSString *)actionStr
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    if ([actionStr isEqualToString:@"invite"])
    {
        [model onUserActionEnd];
        //重新邀请了，状态也要设置为连接中
        model.meetMemberStatus = MeetMemberStatus_none;
        [self updateMember:model];
    }
    else if ([actionStr isEqualToString:@"remove"])
    {
        [model onUserActionEnd];
        
        if (model)
        {
            [self.invitedArray removeObject:model];
            
            [self reloadMemberModels];
        }
    }
}

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
                [self.invitedArray exchangeObjectAtIndex:index withObjectAtIndex:0];
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

#pragma mark -- on invite from user contact
- (void)onInviteMembers
{
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    
    NSMutableArray *inviteArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MemberInfo *memberInfo in modelManger.selectMemberArray)
    {
        M8CallRenderModel *model = [[M8CallRenderModel alloc] init];
        model.identify  = memberInfo.uid;
        model.nick      = memberInfo.nick;
        
        [inviteArr addObject:model];
    }
    
    [self.invitedArray addObjectsFromArray:inviteArr];
    [modelManger mergeSelectToInvite];
}

#pragma mark -- on get host camera statu
- (BOOL)onGetHostCameraStatu
{
    M8CallRenderModel *hostModel = [self getMemberWithID:self.hostIdentify];
    return hostModel.isCameraOn;
}


#pragma mark - used in self protocol
#pragma mark -- get member model
- (M8CallRenderModel *)getMemberWithID:(NSString *)identify
{
    for (M8CallRenderModel *model in self.invitedArray)
    {
        if ([model.identify isEqualToString:identify])
        {
            return model;
        }
    }
    
    // 如果房间中没有改成员，则添加该成员
    M8CallRenderModel *model = [[M8CallRenderModel alloc] init];
    model.identify = identify;
    [self.invitedArray addObject:model];
    
    return model;
}

#pragma mark -- update member model in container
- (void)updateMember:(M8CallRenderModel *)newModel
{
    if (self.invitedArray.count && newModel)
    {
        [self.invitedArray replaceObjectAtIndex:[self getMemberIndexInArray:newModel.identify] withObject:newModel];
    }
    
    [self reloadMemberModels];
}

#pragma mark - private actions

#pragma mark -- get member is in room
- (BOOL)getMemberExistInRoomWithID:(NSString *)identify
{
    for (M8CallRenderModel *model in self.invitedArray)
    {
        if ([model.identify isEqualToString:identify])
        {
            return YES;
        }
    }
    
    return NO;
}




#pragma mark -- get member index in member array
- (NSInteger)getMemberIndexInArray:(NSString *)identify
{
    return [self.invitedArray indexOfObject:[self getMemberWithID:identify]];
}


#pragma mark -- is exist video caption in room
- (BOOL)isExistVideoCaption
{
    for (M8CallRenderModel *model in self.invitedArray)
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
    
    for (M8CallRenderModel *model in self.invitedArray)
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
    
    [self.invitedArray removeAllObjects];
    [self.invitedArray addObjectsFromArray:videoArr];
    [self.invitedArray addObjectsFromArray:audioArr];
    [self.invitedArray addObjectsFromArray:hangupArr];
    [self.invitedArray addObjectsFromArray:callingArr];
    [self.invitedArray addObjectsFromArray:timeoutArr];
    [self.invitedArray addObjectsFromArray:busyArr];
    [self.invitedArray addObjectsFromArray:rejectArr];
    
    [self respondsToDelegate];
}

#pragma mark - respondsToDelegate
- (void)respondsToDelegate
{
    //分离 invitedArray
    //  bgViewModel     : 如果有视频流，则将最前面有视频流的成员保存
    //  renderViewArr   : 保存其他处在 renderView 中的成员
    
    M8CallRenderModel *bgViewModel = nil;
    
    NSMutableArray *renderViewArr = [NSMutableArray arrayWithCapacity:0];
    for (M8CallRenderModel *model in self.invitedArray)
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


- (NSString *)toNickWithUid:(NSString *)uid
{
    M8CallRenderModel *model = [self getMemberWithID:uid];
    
    if (model)
    {
        return model.nick;
    }
    
    return uid;
}


@end
