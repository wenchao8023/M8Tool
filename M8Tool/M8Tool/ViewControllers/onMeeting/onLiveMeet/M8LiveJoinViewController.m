//
//  M8LiveJoinViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveJoinViewController.h"

#import "M8LiveJoinTableView.h"



/**
 视图层级
 *self.view
    *self.bgImg
    *self.tableView
    *self.livingPlayView --> self.livingInfoView
    *self.backBtn
 */
@interface M8LiveJoinViewController ()<LiveJoinTableViewDelegate>


/**
 显示主播列表
 */
@property (nonatomic, weak) M8LiveJoinTableView *tableView;



/**
 记录开始触摸的方向
 */
@property (assign, nonatomic) BOOL isBeginSlid;

/**
 记录tableView滑动之前的 offset
 */
@property (nonatomic, assign) CGPoint currentOffset;

@property (nonatomic, assign) CGRect livingPlayViewFrame;




@end

@implementation M8LiveJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.livingInfoView.host = self.host;
    self.livingPlayView.host = self.host;
    
    [self createUI];
    
    [self joinLive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TILLiveSDK相关接口
- (void)joinLive{
    TILLiveRoomOption *option = [TILLiveRoomOption defaultGuestLiveOption];
    option.controlRole = @"guestTest";
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    [manager setAVListener:self.livingPlayView];
    [manager setIMListener:self.livingInfoView];
    [manager setAVRootView:self.livingPlayView];
    
    __weak typeof(self) ws = self;
    [manager joinRoom:self.roomId option:option succ:^{
        [ws.livingInfoView addTextToView:@"进入房间成功"];
        //进群消息
        ILVLiveCustomMessage *msg = [[ILVLiveCustomMessage alloc] init];
        msg.cmd = ILVLIVE_IMCMD_ENTER;
        msg.type = ILVLIVE_IMTYPE_GROUP;
        [manager sendCustomMessage:msg succ:nil failed:nil];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.livingInfoView addTextToView:[NSString stringWithFormat:@"进入房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
}


#pragma mark - 代理相关
- (void)LiveJoinTableViewCurrentCellIndex:(NSInteger)index {
    WCLog(@"index is %ld", (long)index);
}

#pragma mark - 界面相关
- (void)createUI {
    [self.view insertSubview:self.tableView belowSubview:self.livingPlayView];
}
- (M8LiveJoinTableView *)tableView {
    if (!_tableView) {
        M8LiveJoinTableView *tableView = [[M8LiveJoinTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.WCDelegate = self;
        _tableView = tableView;
    }
    return _tableView;
}

- (void)selfDismiss {
    //退群消息
    ILVLiveCustomMessage *msg = [[ILVLiveCustomMessage alloc] init];
    msg.cmd = ILVLIVE_IMCMD_LEAVE;
    msg.type = ILVLIVE_IMTYPE_GROUP;
    TILLiveManager *manager = [TILLiveManager getInstance];
    [manager sendCustomMessage:msg succ:nil failed:nil];
    
    //退出房间
    __weak typeof(self) ws = self;
    [manager quitRoom:^{
        [ws.livingInfoView addTextToView:@"退出房间成功"];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.livingInfoView addTextToView:[NSString stringWithFormat:@"退出房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
    
    [super selfDismiss];
}


#pragma mark -- 界面的滑动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isBeginSlid = YES;
    _currentOffset = self.tableView.contentOffset;
    _livingPlayViewFrame = self.livingPlayView.frame;
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //    1.获取手指
    UITouch *touch = [touches anyObject];
    //    2.获取触摸的上一个位置
    CGPoint lastPoint;
    CGPoint currentPoint;
    
    //    3.获取偏移位置
    CGPoint tempCenter;
    
    CGPoint tempOffset;
    
    if (self.isBeginSlid) {//首次触摸进入
        lastPoint = [touch previousLocationInView:self.livingPlayView];
        currentPoint = [touch locationInView:self.livingPlayView];
        
        //判断是左右滑动还是上下滑动
        if (ABS(currentPoint.x - lastPoint.x) > ABS(currentPoint.y - lastPoint.y)) {
            //    3.获取偏移位置
            tempCenter = self.livingInfoView.center;
            tempCenter.x += currentPoint.x - lastPoint.x;//左右滑动
            //禁止向左划
            if (self.livingInfoView.frame.origin.x == 0 && currentPoint.x -lastPoint.x > 0) {//滑动开始是从0点开始的，并且是向右滑动
                self.livingInfoView.center = tempCenter;
            }
        }else{
            //    3.获取偏移位置
            tempCenter = self.livingPlayView.center;
            tempCenter.y += currentPoint.y - lastPoint.y;//上下滑动
            self.livingPlayView.center = tempCenter;
            
            tempOffset = self.tableView.contentOffset;
            tempOffset.y -= currentPoint.y - lastPoint.y;
            self.tableView.contentOffset = tempOffset;
        }
    }else{//滑动开始后进入，滑动方向要么水平要么垂直
        //垂直的优先级高于左右滑，因为左右滑的判定是不等于0
        if (self.livingPlayView.frame.origin.y != 0){    //上下滑动
            
            lastPoint = [touch previousLocationInView:self.livingPlayView];
            currentPoint = [touch locationInView:self.livingPlayView];
            
            tempCenter = self.livingPlayView.center;
            tempCenter.y += currentPoint.y -lastPoint.y;
            self.livingPlayView.center = tempCenter;
            
            tempOffset = self.tableView.contentOffset;
            tempOffset.y -= currentPoint.y - lastPoint.y;
            self.tableView.contentOffset = tempOffset;
            
        }else if (self.livingInfoView.frame.origin.x != 0) {//左右滑动
            
            lastPoint = [touch previousLocationInView:self.livingInfoView];
            currentPoint = [touch locationInView:self.livingInfoView];
            tempCenter = self.livingInfoView.center;
            
            tempCenter.x += currentPoint.x -lastPoint.x;
            
            //禁止向左划
            if (self.livingInfoView.frame.origin.x == 0 && currentPoint.x -lastPoint.x > 0) {//滑动开始是从0点开始的，并且是向右滑动
                self.livingInfoView.center = tempCenter;
                
            }else if(self.livingInfoView.frame.origin.x > 0){
                self.livingInfoView.center = tempCenter;
            }
        }
    }
    
    self.isBeginSlid = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    NSLog(@"%.2f-----%.2f",livingInfoView.frame.origin.y,SCREEN_HEIGHT * 0.8);
    
    //    水平滑动判断
    //在控制器这边滑动判断如果滑动范围没有超过屏幕的十分之八livingInfoView还是离开屏幕
    if (self.livingInfoView.frame.origin.x > SCREEN_WIDTH * 0.8) {
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.livingInfoView.frame = frame;
        }];
        
    }else{//否则则回到屏幕0点
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = 0;
            self.livingInfoView.frame = frame;
        }];
    }
    
    //    上下滑动判断
    if (self.livingPlayView.frame.origin.y > SCREEN_HEIGHT * 0.2) {
        //        切换到下一频道
//        self.livingPlayView.image = [UIImage imageNamed:@"PlayView2"];
        _currentOffset.y -= SCREEN_HEIGHT;
        _livingPlayViewFrame.origin.y += SCREEN_HEIGHT;
        
        [self resetlivingPlayViewWithChange:YES];
        
    }else if (self.livingPlayView.frame.origin.y < - SCREEN_HEIGHT * 0.2){
        //        切换到上一频道
//        self.livingPlayView.image = [UIImage imageNamed:@"PlayView"];
        _currentOffset.y += SCREEN_HEIGHT;
        _livingPlayViewFrame.origin.y -= SCREEN_HEIGHT;
        [self resetlivingPlayViewWithChange:YES];
    }else {
        //         回到原来位置
//        _currentOffset 不变
        [self resetlivingPlayViewWithChange:NO];
    }
}

- (void)resetlivingPlayViewWithChange:(BOOL)isChanged {
    // 频道切换成功
    if (isChanged) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.contentOffset = _currentOffset;
            self.livingPlayView.frame = _livingPlayViewFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                // 重新设置 livingPlayView 的位置，重新加载
                LoadView *load = [LoadView loadViewWith:@"loading"];
                [self.view addSubview:load];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [load removeFromSuperview];
                    _livingPlayViewFrame.origin.y = 0;
                    self.livingPlayView.frame = _livingPlayViewFrame;
                    self.livingInfoView.x = 0;
                });
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.contentOffset = _currentOffset;
            self.livingPlayView.frame = _livingPlayViewFrame;
        }];
    }
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    水平滑动判断
    //在控制器这边滑动判断如果滑动范围没有超过屏幕的十分之八livingInfoView还是离开屏幕
    if (self.livingInfoView.frame.origin.x > SCREEN_WIDTH * 0.8) {
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.livingInfoView.frame = frame;
        }];
        
    }else{//否则则回到屏幕0点
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.livingInfoView.frame;
            frame.origin.x = 0;
            self.livingInfoView.frame = frame;
        }];
    }
    
    //    上下滑动判断
    if (self.livingInfoView.frame.origin.y > SCREEN_HEIGHT * 0.2) {
        //        切换到下一频道，重新加载界面，这里用切换图片做演示。
//        self.livingInfoView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.5];
        
    }else if (self.livingInfoView.frame.origin.y < - SCREEN_HEIGHT * 0.2){
        //        切换到上一频道，重新加载界面，这里用切换图片做演示。
//        self.livingInfoView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.5];
        
    }
    //        回到原始位置等待界面重新加载
//    CGRect frame = self.livingInfoView.frame;
//    frame.origin.y = 0;
//    self.livingInfoView.frame = frame;
}



@end
