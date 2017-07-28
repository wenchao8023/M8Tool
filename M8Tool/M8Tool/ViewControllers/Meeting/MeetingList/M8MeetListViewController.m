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


@interface M8MeetListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionListView;
}

@end

@implementation M8MeetListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self reloadSuperViews];
    [self loadRecordData:0];
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


}


/**
 请求会议记录数据
 
 @param offset 偏移位置
 */
- (void)loadRecordData:(int)offset
{
    WCWeakSelf(self);
    LiveListRequest *listReq = [[LiveListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LiveListResponseData *listData = (LiveListResponseData *)request.response.data;
        if (listData.livesArr.count > 0) {
            [weakself loadRespondData:listData];
        }
        
//        [weakself endAllRefresh:NO];
        
    } failHandler:^(BaseRequest *request) {
        
//        [weakself endAllRefresh:(request.response.errorCode == 10086)];
    }];
    
    listReq.token = [AppDelegate sharedAppDelegate].token;
    listReq.type   = @"live";
    listReq.index = 0;
    listReq.size  = 10;
    listReq.appid = [ShowAppId integerValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:listReq];
}

- (void)loadRespondData:(LiveListResponseData *)responseData
{
    for (NSDictionary *dataDic in responseData.livesArr)
    {
//        M8MeetRecordModel *model = [[M8MeetRecordModel alloc] init];
//        [model setValuesForKeysWithDictionary:dataDic];
//        
//        if (self.listViewType == M8MeetListViewTypeCollect) //如果是会议收藏中获取到的数据，需要本地添加一个 collect = 1
//        {
//            model.collect = 1;
//        }
//        
//        NSMutableArray *tempMembers = [NSMutableArray arrayWithCapacity:0];
//        for (NSDictionary *infoDic in model.members)
//        {
//            M8MeetMemberInfo *info = [[M8MeetMemberInfo alloc] init];
//            [info setValuesForKeysWithDictionary:infoDic];
//            [tempMembers addObject:info];
//        }
//        
//        model.members = (NSArray *)tempMembers;
//        [self.dataArray addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self reloadData];
        
    });
}



#pragma mark  代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetListCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

// 返回大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2/3*5);
}
// 返回每个section与上左下右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
// 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
// 最小单元格间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
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
