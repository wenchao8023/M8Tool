//
//  M8CallRenderView.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderView.h"

#import "M8CallRenderModelManager.h"

#import "M8CallRenderCell.h"
#import "M8CallRenderNote.h"



@interface M8CallRenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *renderCollection;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight_render;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop_render;

@property (strong, nonatomic) M8CallRenderNote *noteView;

@property (nonatomic, strong) M8CallRenderModelManager *modelManager;


@property (nonatomic, copy) NSString *currentIdentify;

@property (nonatomic, strong) NSArray *membersArray;

@property (nonatomic, copy) NSString *loginIdentify;

@end


@implementation M8CallRenderView




#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame item:(TCShowLiveListItem *)item isHost:(BOOL)isHost
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _myFrame    = frame;
        _liveItem   = item;
        _isHost     = isHost;
    }
    return self;
}

//- (M8CallRenderModelManager *)modelManager {
//    if (!_modelManager) {
//        M8CallRenderModelManager *modelManager = [[M8CallRenderModelManager  alloc] init];
//        modelManager.WCDelegate     = self;
//        modelManager.hostIdentify   = self.hostIdentify;
//        modelManager.loginIdentify  = self.loginIdentify;
//        modelManager.callType       = [self.call getCallType];
//        _modelManager = modelManager;
//    }
//    return _modelManager;
//}

- (NSString *)loginIdentify {
    if (!_loginIdentify) {
        NSString *loginIdentify = [[ILiveLoginManager getInstance] getLoginId];
        _loginIdentify = loginIdentify;
    }
    return _loginIdentify;
}

- (M8CallRenderNote *)noteView {
    if (!_noteView) {
        M8CallRenderNote *noteView = [[M8CallRenderNote alloc] initWithFrame:CGRectMake(0, self.height - 270, self.width, 200)];
        [self addSubview:(_noteView = noteView)];
    }
    return _noteView;
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
    [self.renderCollection registerNib:[UINib nibWithNibName:@"M8CallRenderCell" bundle:nil] forCellWithReuseIdentifier:@"M8CallRenderCellID"];
    
    /// add noteView
    [self noteView];
}






#pragma mark - Delegate
#pragma mark -- respondsToDelegate
- (void)callRenderActionInfoValue:(id)value key:(NSString *)key
{
    if (value)
    {
        NSDictionary *actionInfo = @{key : value};
        if ([self.WCDelegate respondsToSelector:@selector(CallRenderActionInfo:)])
        {
            [self.WCDelegate CallRenderActionInfo:actionInfo];
        }
    }
}


#pragma mark -- RenderModelManagerDelegate
//- (void)renderModelManager:(M8CallRenderModelManager *)modelManager currentModel:(M8CallRenderModel *)currentModel membersArray:(NSArray *)membersArray {
//    
//    self.membersArray = membersArray;
//    _currentIdentify = currentModel.identify;
//    
//    [self updateRenderCollection];
//    
//    
//    if (currentModel.identify) {
//        [self callRenderActionInfoValue:@{currentModel.identify : currentModel} key:kCallValue_model];
//    }
//    else {
//        if (membersArray.count) {
//            M8CallRenderModel *model = membersArray[0];
//            [self callRenderActionInfoValue:@{model.identify : model} key:kCallValue_model];
//        }
//    }
//}
- (void)updateWithModelManager:(M8CallRenderModelManager *)modelManger currentIdentifier:(NSString *)curId membersArray:(NSArray *)membersArray
{
    self.modelManager = nil;
    self.membersArray = nil;
    _currentIdentify = nil;
    
    self.modelManager = modelManger;
    self.membersArray = membersArray;
    _currentIdentify  = curId;
    
    [self.renderCollection reloadData];
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.membersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    M8CallRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M8CallRenderCellID" forIndexPath:indexPath];
    
    M8CallRenderModel *model = self.membersArray[indexPath.row];
    
    [cell configWithModel:model];
    
    [self setRenderViewFrame:cell.frame identify:model.identify];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.call getCallType] == TILCALL_TYPE_VIDEO)
    {
        if (self.modelManager &&
            ![self.modelManager onSelectItemAtIndexPath:indexPath])
        {
            [self addTextToView:@"没有成员开启摄像头"];
        }
    }
    else if ([self.call getCallType] == TILCALL_TYPE_AUDIO)
    {
        [self addTextToView:@"此时在音频模式下，不支持背景视图观看"];
    }
}

//
//#pragma mark -- 音视频事件回调
//- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
//{
//    for (TILCallMember *member in members) {
//        
//        NSString *identify = member.identifier;
//        [self.modelManager memberNotifyWithID:identify];
//        [self.modelManager onMemberAudioOn:isOn WithID:identify];
//    }
//}
//
//- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
//{
//    for (TILCallMember *member in members) {
//
//        NSString *identify = member.identifier;
//        [self.modelManager memberNotifyWithID:identify];
//        [self.modelManager onMemberCameraVideoOn:isOn WithID:identify];
//        
//        if (isOn) {
//            [self.call addRenderFor:identify atFrame:CGRectZero];
//        }
//        else {
//            [self.call removeRenderFor:identify];
//        }
//    }
//}
//
//
//
//
//#pragma mark -- 通知回调
//- (void)onRecvNotification:(TILCallNotification *)notify
//{
//    NSInteger notifId = notify.notifId;
//    NSString *sender = notify.sender;
//    NSString *target = [notify.targets componentsJoinedByString:@";"];
//    
//    [self.modelManager memberNotifyWithID:sender];
//    
//    switch (notifId) {
//        case TILCALL_NOTIF_INVITE:
//            [self addTextToView:[NSString stringWithFormat:@"%@邀请%@通话",sender,target]];
//            break;
//        case TILCALL_NOTIF_ACCEPTED:
//        {   /*
//             * sender 不会是发起方
//             * sender 不会是 App登录用户 的接收方
//             */
//            [self reportCallMem:sender statu:1];
//            [self addTextToView:[NSString stringWithFormat:@"%@接受了%@的邀请",sender,target]];
//            [self callRenderActionInfoValue:[NSString stringWithFormat:@"%d", (self.shouldHangup = YES)] key:kCallValue_bool];
//            [self.modelManager memberReceiveWithID:sender];
//        }
//            
//            break;
//        case TILCALL_NOTIF_CANCEL:
//        {
//            [self addTextToView:[NSString stringWithFormat:@"%@取消了对%@的邀请",sender,target]];
//            if([notify.targets containsObject:self.loginIdentify]){
//                [self addTextToView:@"通话被取消"];
//                [self selfDismiss];
//            }
//        }
//            break;
//        case TILCALL_NOTIF_TIMEOUT:
//        {
//            if([sender isEqualToString:self.loginIdentify]) {
//                [self addTextToView:[NSString stringWithFormat:@"%@呼叫超时",sender]];
//                [self selfDismiss];
//            }
//            else{
//                [self reportCallMem:sender statu:0];
//                [self addTextToView:[NSString stringWithFormat:@"%@手机可能不在身边",sender]];
//                [self.modelManager memberTimeoutWithID:sender];
//            }
//        }
//            break;
//        case TILCALL_NOTIF_REFUSE:
//        {
//            [self reportCallMem:sender statu:2];
//            [self addTextToView:[NSString stringWithFormat:@"%@拒绝了%@的邀请",sender,target]];
//            [self.modelManager memberRejectInviteWithID:sender];
//        }
//            break;
//        case TILCALL_NOTIF_HANGUP:
//        {
//            [self addTextToView:[NSString stringWithFormat:@"%@挂断了%@邀请的通话",sender,target]];
//            
//            [self.modelManager memberHangupWithID:sender];
//        }
//            break;
//        case TILCALL_NOTIF_LINEBUSY:
//        {
//            [self addTextToView:[NSString stringWithFormat:@"%@占线，无法接受%@的邀请",sender,target]];
//            [self.modelManager memberLineBusyWithID:sender];
//        }
//            
//            break;
//        case TILCALL_NOTIF_HEARTBEAT:
//        {
//            [self addTextToView:[NSString stringWithFormat:@"%@发来心跳",sender]];
//        }
//            
//            break;
//        case TILCALL_NOTIF_DISCONNECT:
//        {
//            [self addTextToView:[NSString stringWithFormat:@"%@失去连接",sender]];
//            if([sender isEqualToString:self.loginIdentify]){
//                [self selfDismiss];
//            }
//            else {
//                [self.modelManager memberDisconnetWithID:sender];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}


//#pragma mark - 上报成员信息
//- (void)reportCallMem:(NSString *)mem statu:(int)statu {
//    /* *token;
//     *uid;
//     ger mid;
//     ger statu*/
//    WCWeakSelf(self);
//    ReportCallMemRequest *reportMemReq = [[ReportCallMemRequest alloc] initWithHandler:^(BaseRequest *request) {
//        [weakself addTextToView:[NSString stringWithFormat:@"上报成员:%@ -- 状态:%d, 成功", mem, statu]];
//    } failHandler:^(BaseRequest *request) {
//        [weakself addTextToView:[NSString stringWithFormat:@"上报成员状态失败\n错误码:%ld，错误信息: %@", (long)request.response.errorCode, request.response.errorInfo]];
//    }];
//    reportMemReq.token = [AppDelegate sharedAppDelegate].token;
//    reportMemReq.uid = mem;
//    reportMemReq.mid = self.mid;
////    reportMemReq.statu = statu;
//    reportMemReq.statu = [NSString stringWithFormat:@"%d", statu];
//    
////    WebServiceEngine *engine = [WebServiceEngine sharedEngine];
////    engine.testReportCallMemBlock = ^(NSString *str) {
////        [weakself addTextToView:str];
////    };
////    [engine asyncRequest:reportMemReq];
//    [[WebServiceEngine sharedEngine] asyncRequest:reportMemReq];
//}




#pragma mark - 界面相关
// 如果成员超出 5 个，也就是超出手机界面，需要滑动的时候，调用 scrollViewDelegate 同步 renderView 与 cell 的 位置
- (void)setRenderViewFrame:(CGRect)cellFrame identify:(NSString *)identify
{
    CGRect frame = cellFrame;
    frame.origin.y = 70;
    [self.call modifyRenderView:frame forIdentifier:identify];
}

/**
 更新 renderCollection

 所有进入过房间的成员最新的状态都保存在了 数组和currentModel 里面了
 */
- (void)updateRenderCollection {

    if (!_isFloatView) {
        [self.call modifyRenderView:self.bounds forIdentifier:_currentIdentify];
        [self.call sendRenderViewToBack:_currentIdentify];
        
        [self.renderCollection reloadData];
    }
}

- (void)setIsFloatView:(BOOL)isFloatView {
    _isFloatView = isFloatView;
}

- (void)addTextToView:(id)newText {
    NSString *text = self.noteView.textView.text;
    
    NSString *dicStr = [NSString stringWithFormat:@"%@", newText];
    dicStr = [dicStr stringByAppendingString:@"\n"];
    dicStr = [dicStr stringByAppendingString:text];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noteView.textView.text = dicStr;
    });
    
}

- (void)selfDismiss {
    [self callRenderActionInfoValue:@"selfDismiss" key:kCallAction];
}

- (IBAction)inviteAction:(id)sender {
    [self callRenderActionInfoValue:@"inviteAction" key:kCallAction];
}

- (IBAction)removeAction:(id)sender {
    [self callRenderActionInfoValue:@"removeAction" key:kCallAction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
