//
//  M8LiveMeetViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveMeetViewController.h"

@interface M8LiveMeetViewController ()<ILVLiveIMListener, ILVLiveAVListener>
    
@property (nonatomic, strong) NSMutableArray *identifierArray;
    
@property (nonatomic, strong) NSMutableArray *srcTypeArray;
    
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation M8LiveMeetViewController

    
- (NSMutableArray *)identifierArray {
    if (!_identifierArray) {
        NSMutableArray *identifierArray = [NSMutableArray arrayWithCapacity:0];
        _identifierArray = identifierArray;
    }
    return _identifierArray;
}
    
- (NSMutableArray *)srcTypeArray {
    if (!_srcTypeArray) {
        NSMutableArray *srcTypeArray = [NSMutableArray arrayWithCapacity:0];
        _srcTypeArray = srcTypeArray;
    }
    return _srcTypeArray;
}


    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _host = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginIdentifier];
    
    [self createLive];
}
    
#pragma mark - TILLiveSDK相关接口
- (void)createLive{
    TILLiveRoomOption *option = [TILLiveRoomOption defaultHostLiveOption];
    option.controlRole = @"LiveMaster";
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    [manager setAVListener:self];
    [manager setIMListener:self];
    [manager setAVRootView:self.view];
    
    WCWeakSelf(self);   
    [manager createRoom:(int)_roomId option:option succ:^{
//        [AppDelegate showAlert:self title:nil message:@"创建房间成功" okTitle:nil cancelTitle:nil ok:nil cancel:nil];
        [weakself addTextToView:@"创建房间成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
//        [AppDelegate showAlert:self title:nil message:@"创建房间失败" okTitle:nil cancelTitle:nil ok:nil cancel:nil];
        [weakself addTextToView:[NSString stringWithFormat:@"创建房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];

    }];
}

#pragma mark - 事件回调
#pragma mark -- ILVLiveAVListener
- (void)onUserUpdateInfo:(ILVLiveAVEvent)event users:(NSArray *)users {
    TILLiveManager *manager = [TILLiveManager getInstance];
    
    switch(event) {
        case ILVLIVE_AVEVENT_CAMERA_ON:
        {
            //视频事件
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_CAMERA)];
                }
                else{
                    [manager addAVRenderView:self.view.bounds forIdentifier:_host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                }
            }
        }
        break;
        case ILVLIVE_AVEVENT_CAMERA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        break;
        case ILVLIVE_AVEVENT_SCREEN_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_SCREEN)];
                }
                else{
                }
            }
        }
        break;
        case ILVLIVE_AVEVENT_SCREEN_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        case ILVLIVE_AVEVENT_MEDIA_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_MEDIA)];
                }
                else{
                }
            }
        }
        break;
        case ILVLIVE_AVEVENT_MEDIA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        default:
        break;
    }
}
    
#pragma mark - 消息回调
- (void)onTextMessage:(ILVLiveTextMessage *)msg {
    [self addTextToView:[NSString stringWithFormat:@"收到文本消息:%@",msg.text]];
}
    
- (void)onCustomMessage:(ILVLiveCustomMessage *)msg {
    switch (msg.cmd) {
        case ILVLIVE_IMCMD_INTERACT_REJECT:
        [self addTextToView:[NSString stringWithFormat:@"%@拒绝了你的上麦邀请",msg.sendId]];
        break;
        case ILVLIVE_IMCMD_INVITE_CLOSE:
        [self addTextToView:[NSString stringWithFormat:@"%@已经下麦",msg.sendId]];
        break;
        case ILVLIVE_IMCMD_INTERACT_AGREE:
        [self addTextToView:[NSString stringWithFormat:@"%@同意了你的上麦邀请",msg.sendId]];
        break;
        case ILVLIVE_IMCMD_LEAVE:
        [self addTextToView:[NSString stringWithFormat:@"%@退出房间",msg.sendId]];
        break;
        case ILVLIVE_IMCMD_ENTER:
        [self addTextToView:[NSString stringWithFormat:@"%@进入房间",msg.sendId]];
        break;
        case ILVLIVE_IMCMD_CUSTOM_LOW_LIMIT:
        {
            //用户自定义消息
            NSString *text = [NSString stringWithFormat:@"收到自定义消息:cmd=%ld,data=%@",(long)msg.cmd,[[NSString alloc] initWithData:msg.data encoding:NSUTF8StringEncoding]];
            [self addTextToView:text];
            break;
        }
        default:
        break;
    }
}
    
    
- (void)addTextToView:(NSString *)newText {
    WCLog(@"%@", newText );
    NSString *text = _textView.text;
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:newText];
    _textView.text = text;
    
}
    
#pragma mark - 界面相关
- (CGRect)getRenderFrame:(NSInteger)count{
    if(count == 3){
        return CGRectZero;
    }
    CGFloat height = (self.view.frame.size.height - 2*20 - 3 * 10)/3;
    CGFloat width = height*3/4;//宽高比3:4
    CGFloat y = 20 + (count * (height + 10));
    CGFloat x = 20;
    return CGRectMake(x, y, width, height);
}
    
- (void)updateRenderFrame{
    TILLiveManager *manager = [TILLiveManager getInstance];
    for(NSInteger index = 0; index < _identifierArray.count; index++){
        CGRect frame = [self getRenderFrame:index];
        NSString *identifier = _identifierArray[index];
        avVideoSrcType srcType = [_srcTypeArray[index] intValue];
        [manager modifyAVRenderView:frame forIdentifier:identifier srcType:srcType];
    }
}

    
    
    
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
