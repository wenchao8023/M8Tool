//
//  M8RecordDetailCollection.h
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8RecordDetailCollection : UICollectionView

- (instancetype _Nonnull)initWithFrame:(CGRect)frame
                  collectionViewLayout:(UICollectionViewLayout * _Nonnull)layout
                             dataModel:(id _Nonnull)model;

@end
