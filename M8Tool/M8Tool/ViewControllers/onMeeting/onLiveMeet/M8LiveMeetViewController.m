//
//  M8LiveMeetViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveMeetViewController.h"

#import "M8CallHeaderView.h"
#import "M8LiveRenderView.h"
#import "M8CallVideoDevice.h"

#import "M8LiveNoteView.h"








@interface M8LiveMeetViewController ()<MeetDeviceDelegate>  ///<ILVLiveIMListener, ILVLiveAVListener>

@property (nonatomic, strong) M8CallHeaderView *headerView;
@property (nonatomic, strong) M8LiveRenderView *renderView;
@property (nonatomic, strong) M8CallVideoDevice *deviceView;
@property (nonatomic, strong) M8LiveNoteView   *noteView;




@end

@implementation M8LiveMeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _host = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginIdentifier];
    
    [self createUI];
    
    [self createLive];
}
    
#pragma mark - TILLiveSDK相关接口
- (void)createLive{
    
    TILLiveRoomOption *option = [TILLiveRoomOption defaultHostLiveOption];
    option.controlRole = @"LiveMaster";

    TILLiveManager *manager = [TILLiveManager getInstance];
    [manager setAVListener:self.renderView];
    [manager setIMListener:self.noteView];
    [manager setAVRootView:self.renderView];
    
    WCWeakSelf(self);   
    [manager createRoom:(int)_roomId option:option succ:^{
        [weakself addTextToView:@"创建房间成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [weakself addTextToView:[NSString stringWithFormat:@"创建房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
}


#pragma mark - 界面相关

- (M8LiveRenderView *)renderView {
    if (!_renderView) {
        M8LiveRenderView *renderView = [[M8LiveRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:(_renderView = renderView)];
    }
    return _renderView;
}

- (M8CallHeaderView *)headerView {
    if (!_headerView) {
        M8CallHeaderView *headerView = [[M8CallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}


- (M8CallVideoDevice *)deviceView {
    if (!_deviceView) {
        M8CallVideoDevice *deviceView = [[M8CallVideoDevice alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight - kDefaultMargin, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [self.view addSubview:(_deviceView = deviceView)];
    }
    return _deviceView;
}

- (M8LiveNoteView *)noteView {
    if (!_noteView) {
        M8LiveNoteView *noteView = [[M8LiveNoteView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 200)];
        [self.view addSubview:(_noteView = noteView)];
    }
    return _noteView;
}



- (void)createUI {
 
    [self renderView];
    self.renderView.roomId = self.roomId;
    self.renderView.host   = self.host;
    [self headerView];
    [self deviceView];
    [self noteView];
}
    
#pragma mark - views delegate
#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
//    WCLog(@"%@", actionInfo);
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kDeviceAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"quitRoomSucc"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self addTextToView:actionInfo[infoKey]];
        }
        
        /*
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"onShareAction"]) {
            
        }
        
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"onNoteAction"]) {
            
        }
        */
    }
    else {
        [self addTextToView:actionInfo[infoKey]];
    }
}



- (void)addTextToView:(NSString *)newText {
    WCLog(@"%@", newText );
    NSString *text = self.noteView.textView.text;
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:newText];
    self.noteView.textView.text = text;
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
