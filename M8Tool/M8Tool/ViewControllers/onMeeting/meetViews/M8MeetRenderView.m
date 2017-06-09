//
//  M8MeetRenderView.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRenderView.h"
#import "M8MeetRenderCell.h"


@interface M8MeetRenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *renderCollection;


@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (nonatomic, strong) NSMutableArray *membersArray;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight_render;

@end


@implementation M8MeetRenderView

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
}


#pragma mark - 界面相关
- (void)shouldReloadData {
    [self.renderCollection reloadData];
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

#pragma mark - actions
- (IBAction)invite:(id)sender {
    TILLiveManager *manager = [TILLiveManager getInstance];
    
    ILVLiveCustomMessage *msg = [[ILVLiveCustomMessage alloc] init];
    msg.cmd = ILVLIVE_IMCMD_INVITE;     //邀请信令
    msg.recvId = @"user2";              //被邀请者id
    msg.type = ILVLIVE_IMTYPE_C2C;      //C2C消息类型
    
    [manager sendCustomMessage:msg succ:^{
        WCLog(@"invite succ");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        WCLog(@"invite fail");
    }];
}

- (IBAction)removeGuest:(id)sender {
    
}

#pragma mark - MeetDeviceActionInfo:
- (void)renderActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(MeetRenderActionInfo:)]) {
        [self.WCDelegate MeetRenderActionInfo:actionInfo];
    }
}



#pragma mark - 事件回调
#pragma mark -- ILVLiveAVListener
- (void)onUserUpdateInfo:(ILVLiveAVEvent)event users:(NSArray *)users {
//    TILLiveManager *manager = [TILLiveManager getInstance];

    switch (event) {
            /**
             * 无事件
             */
        case ILVLIVE_AVEVENT_NONE:
        {
            
        }
            break;
            
            /**
             * 有成员进房
             */
        case ILVLIVE_AVEVENT_MEMBER_ENTER:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){  // 刚进房间，只保存 成员ID
                    [self addModelWithID:user];
                }
                else{   // 主播
                    
                }
            }
        }
            break;
            
            /**
             * 有成员退房
             */
        case ILVLIVE_AVEVENT_MEMBER_EXIT:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]) {
//                    [self removeModelWithID:user];
                    M8MeetRenderModel *model = [self getModelWithID:user];
                    model.isLeaveRoom = YES;
                    [self updateMemberArrayWithModel:model];
                }
                else {  // 主播退房
                    
                }
            }
        }
            break;
            
            /**
             * 有成员开摄像头
             */
        case ILVLIVE_AVEVENT_CAMERA_ON:
        {
            for (NSString *user in users) {
                [self addModelWithID:user];
                
                if(![user isEqualToString:_host]) {
                    M8MeetRenderModel *model = [self getModelWithID:user];
                    model.isCameraOn = YES;
                    model.videoScrType = QAVVIDEO_SRC_TYPE_CAMERA;
                    [self updateMemberArrayWithModel:model];
                }
                else {

                }
            }
            
        }
            break;
            
            /**
             * 有成员关摄像头
             */
        case ILVLIVE_AVEVENT_CAMERA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    M8MeetRenderModel *model = [self getModelWithID:user];
                    model.isCameraOn = NO;
                    model.videoScrType = QAVVIDEO_SRC_TYPE_NONE;
                    [self updateMemberArrayWithModel:model];
                }
                else{
                    
                }
            }
        }
            break;
            
            /**
             * 有成员打开屏幕分享
             */
        case ILVLIVE_AVEVENT_SCREEN_ON:
        {
//            for (NSString *user in users) {
//                if(![user isEqualToString:_host]){
//                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
//                    [_identifierArray addObject:user];
//                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_SCREEN)];
//                }
//                else{
//                }
//            }
        }
            break;
            
            /**
             * 有成员关闭屏幕分享
             */
        case ILVLIVE_AVEVENT_SCREEN_OFF:
        {
//            for (NSString *user in users) {
//                if(![user isEqualToString:_host]){
//                    NSInteger index = [_identifierArray indexOfObject:user];
//                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
//                    [_identifierArray removeObjectAtIndex:index];
//                    [_srcTypeArray removeObjectAtIndex:index];
//                }
//                else {
            
//                }
//            }
            
        }
            break;
            
            /**
             * 有成员开启声音
             */
        case ILVLIVE_AVEVENT_AUDIO_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    M8MeetRenderModel *model = [self getModelWithID:user];
                    model.isMicOn = YES;
                    model.videoScrType = QAVVIDEO_SRC_TYPE_MEDIA;
                    [self updateMemberArrayWithModel:model];
                }
                else {
                    
                }
            }
        }
            break;
            
            /**
             * 有成员关闭声音
             */
        case ILVLIVE_AVEVENT_AUDIO_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    M8MeetRenderModel *model = [self getModelWithID:user];
                    model.isMicOn = NO;
                    model.videoScrType = QAVVIDEO_SRC_TYPE_NONE;
                    [self updateMemberArrayWithModel:model];
                }
                else {
                    
                }
                
            }
        }
            break;
            
            /**
             * 有成员播放视频文件
             */
        case ILVLIVE_AVEVENT_MEDIA_ON:
        {
            
        }
            break;
            
            /**
             * 有成员关闭视频文件
             */
        case ILVLIVE_AVEVENT_MEDIA_OFF:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [self shouldReloadData];
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

@end
