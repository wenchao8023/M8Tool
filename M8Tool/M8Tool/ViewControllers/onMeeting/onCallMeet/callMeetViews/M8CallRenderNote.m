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
        self.delegate        = self;
        self.dataSource      = self;
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
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

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
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
        [cell configWithModel:self.itemsArray[indexPath.row] width:self.width];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.itemsArray.count)
    {
        return [self configWithModel:self.itemsArray[indexPath.row]] * 1.2 + 24;
    }
    return 40;
}

#pragma mark - -- 计算 cell高度
- (CGFloat)configWithModel:(M8CallNoteModel *)model
{
    NSMutableAttributedString *textAttStr = [[NSMutableAttributedString alloc] init];
    CGSize textSize;
    
    if (model.name)
    {
        if (model.tipInfo)
        {
            NSAttributedString *nameAttStr = [self nameAttString:model.name];
            [textAttStr appendAttributedString:nameAttStr];
            
            NSAttributedString *tipAttStr = [self msgAttString:model.tipInfo];
            [textAttStr appendAttributedString:tipAttStr];
        }
        else if (model.msgInfo)
        {
            NSAttributedString *nameAttStr = [self nameAttString:[NSString stringWithFormat:@"%@ : ", model.name]];
            [textAttStr appendAttributedString:nameAttStr];
            
            NSAttributedString *tipAttStr = [self msgAttString:model.msgInfo];
            [textAttStr appendAttributedString:tipAttStr];
            
        }
    }
    else
    {
        if (model.tipInfo)
        {
            NSAttributedString *tipAttStr = [self msgAttString:model.tipInfo];
            [textAttStr appendAttributedString:tipAttStr];
        }
    }
    
    textSize = [self sizeWithDefaultHeightAndAttString:textAttStr];
    if (textSize.width > self.width - 24)
    {
        textSize = [self sizeWithAttString:textAttStr];
    }
    
    return textSize.height;
}

- (NSAttributedString *)nameAttString:(NSString *)name
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置字体属性
    [attDict setValue:[UIFont fontWithName:@"DroidSansFallback" size:kAppMiddleFontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:WCYellow forKey:NSForegroundColorAttributeName];
    //设置字符间距
    [attDict setValue:@(2) forKey:NSKernAttributeName];
    
    return [[NSAttributedString alloc] initWithString:name attributes:attDict];
}

- (NSAttributedString *)msgAttString:(NSString *)msg
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置字体属性
    [attDict setValue:[UIFont fontWithName:@"DroidSansFallback" size:kAppSmallFontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:WCWhite forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 0.0;//增加行高
    paragraphStyle.headIndent = 0;//头部缩进，相当于左padding
    paragraphStyle.tailIndent = 0;//相当于右padding
    paragraphStyle.lineHeightMultiple = 1.2;//行间距是多少倍
    paragraphStyle.alignment = NSTextAlignmentLeft;//对齐方式
    paragraphStyle.firstLineHeadIndent = 0;//首行头缩进
    paragraphStyle.paragraphSpacing = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore = 0;//段落之前的间距
    
    [attDict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [[NSAttributedString alloc] initWithString:msg attributes:attDict];
}

- (CGSize)sizeWithAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake(self.width - 24, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

- (CGSize)sizeWithDefaultHeightAndAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果键盘是推出状态, 执行点击事件
    //如果键盘不是推出状态，菜单推出了，则执行隐藏菜单事件
    if ([M8UserDefault getPushMenuStatu] &&
        ![M8UserDefault getKeyboardShow])
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return ;
    }
    
    if (indexPath.row < self.itemsArray.count)
    {
        M8CallNoteModel *model = self.itemsArray[indexPath.row];
        
        model.record = !model.record;
        
        [self.itemsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - load data
- (void)loadItemsArray:(M8CallNoteModel *)model
{
    [self.itemsArray addObject:model];
    
    [self reloadData];
}


- (void)reloadData
{
    [super reloadData];
    
    [self scrollTableViewToBottom];
}

// 收到消息 和 发送消息 之后重新设置 tableView 的位置和刷新数据
- (void)scrollTableViewToBottom
{
    NSInteger lastRow = self.itemsArray.count - 1;
    
    if (lastRow < 0)
    {
        return ;
    }
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
