//
//  M8CallVideoRenderView.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallVideoRenderView.h"

#import "M8MeetRenderCell.h"
#import "M8CallVideoNoteView.h"

@interface M8CallVideoRenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *renderCollection;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight_render;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop_render;

@property (strong, nonatomic) M8CallVideoNoteView *noteView;

@property (nonatomic, strong) NSMutableArray *membersArray;

@end


@implementation M8CallVideoRenderView

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
        
        [self.renderCollection reloadData];
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
    _noteView = [[M8CallVideoNoteView alloc] initWithFrame:CGRectMake(0, _layoutTop_render.constant + _layoutHeight_render.constant + 60, self.width, 200)];
    [self addSubview:_noteView];
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.membersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    M8MeetRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M8MeetRenderCellID" forIndexPath:indexPath];
    
    [cell config:self.membersArray[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WCLog(@"点击第 %ld 个按钮", (long)indexPath.row);
}

#pragma mark -- 处理 Model

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
    if (![self isExistInMemberArray:identify]) {
        M8MeetRenderModel *model = [[M8MeetRenderModel alloc] init];
        model.identify = identify;
        model.isEnterRoom = YES;
        if ([identify isEqualToString:_host]) {
            model.isInBack = YES;
        }
        [self.membersArray addObject:model];
    }
    
}


/**
 更新已添加成员状态
 
 @param model 更新后的Model
 */
- (void)updateMemberArrayWithModel:(M8MeetRenderModel *)model {
    [self.membersArray replaceObjectAtIndex:[self getIndexWithID:model.identify] withObject:model];
}

#pragma mark - actions
- (IBAction)inviteAction:(id)sender {
}

- (IBAction)removeAction:(id)sender {
}

#pragma mark - 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    NSString *myId = [[ILiveLoginManager getInstance] getLoginId];
    
    if(isOn){
        for (TILCallMember *member in members) {
            
//            NSString *identifier = member.identifier;
//            
//            if (![self.indexArray containsObject:identifier]) {
//                [_call addRenderFor:identifier atFrame:CGRectZero];
//                
//                if ([identifier isEqualToString:myId]) {
//                    [self.indexArray insertObject:identifier atIndex:0];
//                    [self.statuArray insertObject:@"1" atIndex:0];
//                } else {
//                    [self.indexArray addObject:identifier];
//                    [self.statuArray addObject:@"0"];
//                }
//            }
        }
    }
    else{
        for (TILCallMember *member in members) {
            
//            NSString *identifier = member.identifier;
//            
//            NSInteger curIndex = [self.indexArray indexOfObject:identifier];
//            
//            [_call removeRenderFor:identifier];
//            [self.indexArray removeObject:identifier];
//            
//            if ([self.statuArray[curIndex] isEqualToString:@"1"]) {
//                if (curIndex == 0) {
//                    [self.statuArray exchangeObjectAtIndex:curIndex withObjectAtIndex:1];
//                }
//                else {
//                    [self.statuArray exchangeObjectAtIndex:curIndex withObjectAtIndex:0];
//                }
//            }
//            
//            [self.statuArray removeObjectAtIndex:curIndex];
        }
    }
    
//    [self layoutRenderView];
//    [self reloadMemberScroll];
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
            [self addTextToView:[NSString stringWithFormat:@"%@挂断了%@邀请的通话",sender,target]];
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
    
//    [self.numberButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"number%lu", (unsigned long)self.membersArray.count]] forState:UIControlStateNormal];
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
#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(CallVideoRenderActionInfo:)]) {
        [self.WCDelegate CallVideoRenderActionInfo:actionInfo];
    }
}



@end
