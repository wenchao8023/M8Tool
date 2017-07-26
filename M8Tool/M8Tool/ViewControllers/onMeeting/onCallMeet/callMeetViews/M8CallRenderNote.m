//
//  M8CallRenderNote.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderNote.h"
#import "M8CallNoteCell.h"
#import "M8CallNoteModel.h"



@interface M8CallRenderNote()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemsArray;

@end



@implementation M8CallRenderNote

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.backgroundColor = WCClear;
        self.scrollEnabled   = NO;
        self.delegate        = self;
        self.dataSource      = self;
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray)
    {
        _itemsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemsArray;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    M8CallNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M8CallNoteCellID"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"M8CallNoteCell" owner:self options:nil] firstObject];
    }
    
    if (indexPath.row < self.itemsArray.count)
    {
        [cell configWithModel:self.itemsArray[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



#pragma mark - load data
- (void)loadItemsArray:(M8CallNoteModel *)model
{
    [self.itemsArray addObject:model];
    
    [self reloadData];
}

@end
