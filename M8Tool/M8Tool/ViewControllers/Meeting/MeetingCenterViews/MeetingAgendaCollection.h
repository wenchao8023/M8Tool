//
//  MeetingAgendaCollection.h
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AgendaCollectionDelegate <NSObject>

- (void)AgendaCollectionNumberPage:(int)pageNumber;

- (void)AgendaCollectionCurrentPage:(int)pageIndex;

@end



@interface MeetingAgendaCollection : UICollectionView

@property (nonatomic, weak) id agendaDelegate;

@end
