//
//  M8CallRenderView.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderView.h"
#import "M8CallRenderCell.h"
//#import "M8CallRenderNote.h"
#import "M8CallRenderModelManger.h"
#import "M8CallRenderModel.h"



@interface M8CallRenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *renderCollection;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight_render;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop_render;

//@property (strong, nonatomic) M8CallRenderNote *noteView;
@property (nonatomic, strong) M8CallRenderModelManger *modelManager;

@property (nonatomic, copy) NSString *bgViewIdentify;
@property (nonatomic, strong) NSArray *membersArray;    //记录为有音视频上行的成员
@property (nonatomic, strong) NSArray *inviteArray;     //记录会议开始前邀请的成员



@end


@implementation M8CallRenderView




#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame item:(TCShowLiveListItem *)item isHost:(BOOL)isHost
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _myFrame  = frame;
        _liveItem = item;
        _isHost   = isHost;
        [self inviteArray];
    }
    return self;
}




- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // reset self.frame
    self.frame = _myFrame;
    
    // reset collection
    CGFloat itemWidth  = (SCREEN_WIDTH - 50) / 4;
    CGFloat itemHeight = itemWidth * 5 / 3;
    
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
//    [self noteView];
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
- (void)updateWithRenderModelManager:(id)renderModelManger
                      bgViewIdentify:(NSString *)bgViewIdentify
                     renderViewArray:(NSArray *)renderViewArray
{
    self.modelManager = nil;
    self.membersArray = nil;
    _bgViewIdentify   = nil;

    self.modelManager = renderModelManger;
    self.membersArray = renderViewArray;
    _bgViewIdentify   = bgViewIdentify;

    [self.call modifyRenderView:self.bounds forIdentifier:_bgViewIdentify];
    [self.call sendRenderViewToBack:_bgViewIdentify];
    [self.renderCollection reloadData];
}




#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.membersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    M8CallRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"M8CallRenderCellID" forIndexPath:indexPath];
    
    if (cell)
    {
        WCWeakSelf(self);
        cell.removeBlock = ^(NSString * _Nullable info) {
        
            [weakself callRenderActionInfoValue:@{@"remove" : info} key:kCallAction];
        };
        
        cell.inviteBlock = ^(NSString * _Nullable info) {
          
            [weakself callRenderActionInfoValue:@{@"invite" : info} key:kCallAction];    
        };
    }
    
    if (indexPath.row < self.membersArray.count)
    {
        M8CallRenderModel *model = self.membersArray[indexPath.row];
        
        [cell configWithModel:model radius:(SCREEN_WIDTH - 50) / 4 / 4];
        
        if (model.isCameraOn)
        {
            [self setRenderViewFrame:cell.frame identify:model.identify];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL ret = [M8UserDefault getPushMenuStatu];
    if (ret)
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return ;
    }

    if ([self.call getCallType] == TILCALL_TYPE_VIDEO)
    {
        if (self.modelManager)
        {
            [self.modelManager onCollectionDidSelectModel:self.membersArray[indexPath.row]];
        }
    }
    else if ([self.call getCallType] == TILCALL_TYPE_AUDIO)
    {
//        [self addTextToView:@"此时在音频模式下，不支持背景视图观看"];
    }
}

#pragma mark - 界面相关
// 如果成员超出 5 个，也就是超出手机界面，需要滑动的时候，调用 scrollViewDelegate 同步 renderView 与 cell 的 位置
- (void)setRenderViewFrame:(CGRect)cellFrame identify:(NSString *)identify
{
    CGRect frame = cellFrame;
    frame.origin.y = 70;
    [self.call modifyRenderView:frame forIdentifier:identify];
}


- (void)setIsFloatView:(BOOL)isFloatView
{
    _isFloatView = isFloatView;
}


//- (void)addTextToView:(id)newText
//{
//    NSString *text = self.noteView.textView.text;
//    
//    NSString *dicStr = [NSString stringWithFormat:@"%@", newText];
//    dicStr = [dicStr stringByAppendingString:@"\n"];
//    dicStr = [dicStr stringByAppendingString:text];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        self.noteView.textView.text = dicStr;
//    });
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BOOL ret = [M8UserDefault getPushMenuStatu];
    if (ret)
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return ;
    }
    [self endEditing:YES];
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}




@end
