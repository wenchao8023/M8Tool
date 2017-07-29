//
//  M8MeetListViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListViewController.h"
#import "MeetListCollectionViewCell.h"
#import "BaseRequest.h"
#import "LiveListRequest.h"

#import "M8MeetWindow.h"
#import "M8LiveViewController.h"


@interface M8MeetListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *collectionListView;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, assign) int pageNums;
@property (nonatomic, assign) int pageOffset;


@end

@implementation M8MeetListViewController

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray)
    {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:0];
        _itemsArray = itemsArray;
    }
    return _itemsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageNums = 20;
    
    [self reloadSuperViews];
    [self loadListData];
    [self configUI];

    
}

-(void)configUI
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionListView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60) collectionViewLayout:layout];
    _collectionListView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionListView];
    _collectionListView.delegate = self;
    _collectionListView.dataSource = self;
    [_collectionListView registerNib:[UINib nibWithNibName:@"MeetListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MeetListCollectionViewCell"];
    
    WCWeakSelf(self);
    _collectionListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself loadListData];
    }];
    
    _collectionListView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreListData)];
    
    [_collectionListView.mj_header endRefreshing];
    [_collectionListView.mj_footer endRefreshing];
}

- (void)loadListData
{
    self.pageOffset = 0;
    [self.itemsArray removeAllObjects];
    
    if (_collectionListView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        [_collectionListView.mj_footer resetNoMoreData];
    }
    
    [self loadListDataWithOffset:self.pageOffset];
}

- (void)loadMoreListData
{
    self.pageOffset = (int)self.itemsArray.count;
    [self loadListDataWithOffset:self.pageOffset];
}


/**
 请求会议记录数据
 */
- (void)loadListDataWithOffset:(int)offset
{
    WCWeakSelf(self);
    LiveListRequest *listReq = [[LiveListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LiveListResponseData *listData = (LiveListResponseData *)request.response.data;
        [self loadRespondData:listData.rooms];
        
        [weakself endAllRefresh:NO];
        
    } failHandler:^(BaseRequest *request) {
        
        [weakself endAllRefresh:(request.response.errorCode == 10086)];
    }];
    
    listReq.token = [AppDelegate sharedAppDelegate].token;
    listReq.type  = @"live";
    listReq.index = offset;
    listReq.size  = self.pageNums;
    listReq.appid = [ShowAppId integerValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:listReq];
}





- (void)loadRespondData:(NSArray *)rooms
{
    for (NSDictionary *roomDic in rooms)
    {
        M8LiveRoomModel *model = [M8LiveRoomModel new];
        model.uid = [roomDic objectForKey:@"uid"];
        
        M8LiveRoomInfo *rInfo = [M8LiveRoomInfo new];
        NSDictionary *iDic = [roomDic objectForKey:@"info"];
        [rInfo setValuesForKeysWithDictionary:iDic];
        
        model.info = rInfo;
        
        [self.itemsArray addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [_collectionListView reloadData];
    });
}


- (void)endAllRefresh:(BOOL)isNOMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_collectionListView.mj_header.isRefreshing)
        {
            [_collectionListView.mj_header endRefreshing];
        }
        
        if (_collectionListView.mj_footer.isRefreshing)
        {
            if (isNOMoreData)
            {
                [_collectionListView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [_collectionListView.mj_footer endRefreshing];
            }
        }
    });
}


#pragma mark  代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetListCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.itemsArray.count)
    {
        [cell config:self.itemsArray[indexPath.row]];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.itemsArray.count)
    {
        M8LiveRoomModel *model = self.itemsArray[indexPath.row];
        
        M8LiveRoomInfo  *info  = model.info;
        
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
        item.uid = [M8UserDefault getLoginId];
        item.info = [[ShowRoomInfo alloc] init];
        item.info.title = info.title;
        item.info.type = @"live";
        item.info.roomnum = [info.roomnum integerValue];
        item.info.groupid = info.groupid;
//        item.info.cover = coverUrl ? coverUrl : @"";
        
        item.info.appid = [ShowAppId intValue];
        item.info.host = model.uid;
        
        M8LiveViewController *liveVC = [[M8LiveViewController alloc] initWithItem:item isHost:NO];
        [M8MeetWindow M8_addMeetSource:liveVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
    }
}



// 返回大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2/3*5);
}
// 返回每个section与上左下右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
// 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
// 最小单元格间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议列表"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadSuperViews {
    
    self.contentView.hidden = YES;
    
    [self.view sendSubviewToBack:self.bgImageView];
}


@end
