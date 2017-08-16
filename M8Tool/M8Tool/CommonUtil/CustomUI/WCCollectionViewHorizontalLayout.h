//
//  WCCollectionViewHorizontalLayout.h
//  PageCollectionDemo
//
//  Created by chao on 2017/5/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCCollectionViewHorizontalLayout : UICollectionViewFlowLayout

- (instancetype)initWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow;
/**
 一行中 cell 的个数
 */
@property (nonatomic, assign) NSUInteger itemCountPerRow;

/**
 一页显示多少行
 */
@property (nonatomic, assign) NSUInteger rowCount;


@end
