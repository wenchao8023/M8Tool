//
//  M8CallRenderView.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderView.h"

#import "M8MeetRenderCell.h"
#import "M8CallNoteView.h"

#import "UserContactViewController.h"

@interface M8CallRenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *renderCollection;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight_render;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop_render;

@property (strong, nonatomic) M8CallNoteView *noteView;

@property (nonatomic, strong) NSMutableArray *membersArray;

/**
 记录当前处在背景视图的成员
 */
@property (nonatomic, strong) M8MeetRenderModel *currentInBackModel;

@property (nonatomic, copy) NSString *loginIdentify;

@end


@implementation M8CallRenderView

- (NSMutableArray *)membersArray {
    if (!_membersArray) {
        _membersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _membersArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _myFrame = frame;
        
        _loginIdentify = [[ILiveLoginManager getInstance] getLoginId];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // reset self.frame
    self.frame = _myFrame;
    
    // reset collection
    CGFloat itemWidth  = (SCREEN_WIDTH - 50) / 4;
    CGFloat itemHeight = itemWidth * 4 / 3;
    
    _layoutHeight_render.constant = itemHeight;
    
    WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:1 itemCountPerRow:4];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing       = 10;
    layout.minimumInteritemSpacing  = 0;
    layout.headerReferenceSize      = CGSizeMake(10, 0);
    layout.footerReferenceSize      = CGSizeMake(10, 0);
    
    [self.renderCollection setCollectionViewLayout:layout];
    [self.renderCollection setDelegate:self];
    [self.renderCollection setDataSource:self];
    [self.renderCollection setPagingEnabled:YES];
    [self.renderCollection registerNib:[UINib nibWithNibName:@"M8MeetRenderCell" bundle:nil] forCellWithReuseIdentifier:@"M8MeetRenderCellID"];
    
    /// add noteView
    _noteView = [[M8CallNoteView alloc] initWithFrame:CGRectMake(0, self.height - 270, self.width, 200)];
    [self addSubview:_noteView];
}

#pragma mark - Delegate
#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.membersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    M8MeetRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M8MeetRenderCellID" forIndexPath:indexPath];
    
    M8MeetRenderModel *model = self.membersArray[indexPath.row];

    [cell configCall:self.call model:model];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 只需要交换，然后保存对应的数据在本地，不需要刷新数据，因为没有新的事件进来
    M8MeetRenderModel *model = self.membersArray[indexPath.row];
    [self.call switchRenderView:model.identify with:_currentInBackModel.identify];
    
    // 保存状态
    M8MeetRenderModel *tempModel = model;
    [self.membersArray replaceObjectAtIndex:[self getIndexWithID:model.identify] withObject:_currentInBackModel];
    _currentInBackModel = tempModel;
    
}


#pragma mark - 处理 Model
/**
 根据<!--成员ID--!>获取<!--数组下标--!>
 @param identify 成员ID
 @return 数组下标
 */
- (NSInteger)getIndexWithID:(NSString *)identify {
    return [self.membersArray indexOfObject:[self getModelWithID:identify]];
}


/**
 根据<!--成员ID--!>获取<!--数据模型--!>
 @param identify 成员ID
 @return 数据模型
 */
- (M8MeetRenderModel *)getModelWithID:(NSString *)identify {
    for (M8MeetRenderModel *model in self.membersArray) {
        if ([model.identify isEqualToString:identify]) {
            return model;
        }
    }
    NSAssert(1, @"此时房间没成员");
    return nil;
}


/**
 根据<!--成员ID--!>判断该成员是否添加进了数组
 @param identify 成员ID
 @return 是否存在
 */
- (BOOL)isExistInMemberArray:(NSString *)identify {
    for (M8MeetRenderModel *model in self.membersArray) {
        if ([model.identify isEqualToString:identify]) {
            return YES;
        }
    }
    return NO;
}


/**
 成员刚进入房间的时候添加
 @param identify 添加成员
 */
- (void)addModelWithID:(NSString *)identify {
    if (![self isExistInMemberArray:identify]) {    //保证每个成员只添加一次
        M8MeetRenderModel *model = [[M8MeetRenderModel alloc] init];
        model.identify = identify;
        model.isEnterRoom = YES;
        if ([identify isEqualToString:_loginIdentify]) {    // 第一次检测到是自己，用currentModel保存，不保存进数组
            _currentInBackModel = model;
        }
        
        [self.membersArray addObject:model];
        
    }
    else {  //如果成员存在，但是是离开后有进入房间的，就将是否离开的状态记为 NO
        [self recordModelIsLeaveRoom:NO WithID:identify];
    }
}


/**
 有成员离开房间
 @param identify 记录离开成员状态
 */
- (void)recordModelIsLeaveRoom:(BOOL)isLeaveRoom WithID:(NSString *)identify {
    M8MeetRenderModel *model = [self getModelWithID:identify];
    model.isLeaveRoom = isLeaveRoom;
    [self updateMemberArrayWithModel:model];
}


/**
 更新已添加成员状态
 @param model 更新后的Model
 */
- (void)updateMemberArrayWithModel:(M8MeetRenderModel *)model {
    [self.membersArray replaceObjectAtIndex:[self getIndexWithID:model.identify] withObject:model];
}



#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members) {
        // 添加成员，如果存在就不添加
        [self addModelWithID:member.identifier];
        
        M8MeetRenderModel *model = [self getModelWithID:member.identifier];
        model.isMicOn = isOn;
        [self updateMemberArrayWithModel:model];
    }
    
    [self updateRenderCollection];
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members) {
        
        [self addModelWithID:member.identifier];
        
        M8MeetRenderModel *model = [self getModelWithID:member.identifier];
        model.isCameraOn = isOn;
        [self updateMemberArrayWithModel:model];
        
        if (isOn) {
            [self.call addRenderFor:model.identify atFrame:CGRectZero];
        }
        else {
            [self.call removeRenderFor:model.identify];
        }
    }
    
    [self updateRenderCollection];
}


#pragma mark - 通知回调
//注意：
//［通知回调］可以获取通话的事件通知
// [通话状态回调] 也可以获取通话的事件通知
- (void)onRecvNotification:(TILCallNotification *)notify
{
    NSInteger notifId = notify.notifId;
    NSString *sender = notify.sender;
    NSString *target = [notify.targets componentsJoinedByString:@";"];
    NSString *myId = [[ILiveLoginManager getInstance] getLoginId];
    
    switch (notifId) {
        case TILCALL_NOTIF_INVITE:
            [self addTextToView:[NSString stringWithFormat:@"%@邀请%@通话",sender,target]];
            break;
        case TILCALL_NOTIF_ACCEPTED:
            [self addTextToView:[NSString stringWithFormat:@"%@接受了%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_CANCEL:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@取消了对%@的邀请",sender,target]];
            if([notify.targets containsObject:myId]){
                [self selfDismiss];
            }
        }
            break;
        case TILCALL_NOTIF_TIMEOUT:
        {
            if([sender isEqualToString:myId]){
                [self addTextToView:[NSString stringWithFormat:@"%@呼叫超时",sender]];
                [self selfDismiss];
            }
            else{
                [self addTextToView:[NSString stringWithFormat:@"%@手机可能不在身边",sender]];
            }
        }
            break;
        case TILCALL_NOTIF_REFUSE:
            [self addTextToView:[NSString stringWithFormat:@"%@拒绝了%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_HANGUP:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@挂断了%@邀请的通话",sender,target]];
            [self recordModelIsLeaveRoom:YES WithID:sender];
        }
            break;
        case TILCALL_NOTIF_LINEBUSY:
            [self addTextToView:[NSString stringWithFormat:@"%@占线，无法接受%@的邀请",sender,target]];
            break;
        case TILCALL_NOTIF_HEARTBEAT:
            [self addTextToView:[NSString stringWithFormat:@"%@发来心跳",sender]];
            break;
        case TILCALL_NOTIF_DISCONNECT:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@失去连接",sender]];
            if([sender isEqualToString:myId]){
                [self selfDismiss];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 界面相关
/**
 更新 renderCollection
 */
- (void)updateRenderCollection {
    
    for (M8MeetRenderModel *model in self.membersArray) {   //只在第一次添加的时候才会触发
        if ([model isEqual:_currentInBackModel]) {
            [self.membersArray removeObject:model];
            
            [self.call modifyRenderView:self.bounds forIdentifier:model.identify];
            ILiveRenderView *rv = [self.call getRenderFor:model.identify];
            [self addSubview:rv];
            [self sendSubviewToBack:rv];
        }
    }
    
    [self.renderCollection reloadData];
}

- (void)addTextToView:(NSString *)newText {
    NSString *text = self.noteView.textView.text;
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:newText];
    self.noteView.textView.text = text;
}

- (void)selfDismiss {
    [self deviceActionInfoValue:@"selfDismiss" key:kCallAction];
}

- (IBAction)inviteAction:(id)sender {
    UserContactViewController *contactVC = [[UserContactViewController alloc] init];
    contactVC.isExitLeftItem = YES;
    [[[AppDelegate sharedAppDelegate] topViewController].navigationController pushViewController:contactVC animated:YES];
}

- (IBAction)removeAction:(id)sender {
    
}

#pragma mark -- MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(CallRenderActionInfo:)]) {
        [self.WCDelegate CallRenderActionInfo:actionInfo];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


@end
