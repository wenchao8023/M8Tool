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
@property (nonatomic, strong, nullable) M8MeetRenderModel *currentInBackModel;

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
    CGFloat itemWidth  = (SCREEN_WIDTH - 50 - 40) / 4;
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
    
    [cell configWithModel:model];
    
    [self setRenderViewFrame:cell.frame identify:model.identify];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isExitVideoCaption]) {
        M8MeetRenderModel *tempModel;
        if (_currentInBackModel) {
            tempModel = _currentInBackModel;
            _currentInBackModel = self.membersArray[indexPath.row];
            [self.membersArray replaceObjectAtIndex:[self getIndexWithID:_currentInBackModel.identify] withObject:tempModel];
        }
        else {
            _currentInBackModel = self.membersArray[indexPath.row];
            [self.membersArray removeObjectAtIndex:indexPath.row];
        }
        
        [self updateRenderCollection];
    }
    else {
        [self addTextToView:@"没有成员开启摄像头"];
    }
}



#pragma mark -- 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members) {
        
        [self addModelWithID:member.identifier];
        
        M8MeetRenderModel *model = [self getModelWithID:member.identifier];
        model.isMicOn = isOn;
        [self updateMemberArrayWithModel:model];
    }
    
    [self reloadModels];
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
    
    [self reloadModels];
}


#pragma mark -- 通知回调
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
            [self addModelWithID:sender];
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
//            [self recordModelIsLeaveRoom:YES WithID:sender];
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


#pragma mark -- MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(CallRenderActionInfo:)]) {
        [self.WCDelegate CallRenderActionInfo:actionInfo];
    }
}


#pragma mark - 处理 Model
/**
 成员刚进入房间的时候添加
 * 整个会议过程，进入房间的成员只添加一次
 * 所有进入房间的成员保存在 成员数组和currentModel 里面
 @param identify 添加成员
 */
- (void)addModelWithID:(NSString *)identify {
    if (![self isExistInMemberArray:identify]) {
        [self addTextToView:[NSString stringWithFormat:@"添加成员: %@", identify]];
        M8MeetRenderModel *model = [[M8MeetRenderModel alloc] init];
        model.identify = identify;
        model.isEnterRoom = YES;
        if ([identify isEqualToString:_loginIdentify])    // 第一次检测到是自己，用currentModel保存，不保存进数组
        {
            _currentInBackModel = model;
        }
        else
        {
            [self.membersArray addObject:model];
        }
    }
    else {  //如果成员存在，但是是离开后又进入房间的，就将是否离开的状态记为 NO
        
    }
}

/**
 更新已添加成员状态
 @param model 更新后的Model
 */
- (void)updateMemberArrayWithModel:(M8MeetRenderModel *)model {
    NSAssert(model, @"model 不能为空");
    if ([model.identify isEqualToString:_currentInBackModel.identify])
        _currentInBackModel = model;
    else
        [self.membersArray replaceObjectAtIndex:[self getIndexWithID:model.identify] withObject:model];
}

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

/**
 根据<!--成员ID--!>判断该成员是否添加进了数组
 @param identify 成员ID
 @return 改成员是否添加过
 */
- (BOOL)isExistInMemberArray:(NSString *)identify {
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



#pragma mark - 界面相关
// 如果成员超出 5 个，也就是超出手机界面，需要滑动的时候，调用 scrollViewDelegate 同步 renderView 与 cell 的 位置
- (void)setRenderViewFrame:(CGRect)cellFrame identify:(NSString *)identify {
    CGRect frame = cellFrame;
    frame.origin.y = 70;
    
    [self.call modifyRenderView:frame forIdentifier:identify];
}

/**
 更新 renderCollection

 所有进入过房间的成员最新的状态都保存在了 数组和currentModel 里面了
 */
- (void)updateRenderCollection {

    [self addTextToView:[NSString stringWithFormat:@"<!--用户 : %@, 位置 : %@--!>", _currentInBackModel.identify, NSStringFromCGRect(self.bounds)]];
    [self.call modifyRenderView:self.bounds forIdentifier:_currentInBackModel.identify];
    [self.call sendRenderViewToBack:_currentInBackModel.identify];
    
    [self.renderCollection reloadData];
}

- (void)reloadModels {
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
                    [self.membersArray replaceObjectAtIndex:[self getIndexWithID:model.identify]
                                                 withObject:tempModel];
                }
                // 刷新视图 并终止循环
                [self updateRenderCollection];
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
    [self updateRenderCollection];
}

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

- (void)addTextToView:(NSString *)newText {
    NSString *text = self.noteView.textView.text;
    newText = [newText stringByAppendingString:@"\n"];
    newText = [newText stringByAppendingString:text];
    self.noteView.textView.text = newText;
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
