//
//  MeetingAgendaCell.h
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingAgendaCell : UICollectionViewCell

//- (void)configWithTitle:(NSString *)title imageStr:(NSString *)imageStr ;

- (void)configWithDay:(NSString *_Nullable)day monthImg:(NSString *_Nullable)monthImg dayColor:(UIColor *_Nullable)dayColor;

@end
