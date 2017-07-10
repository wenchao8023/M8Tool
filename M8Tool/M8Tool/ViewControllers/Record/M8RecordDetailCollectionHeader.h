//
//  M8RecordDetailCollectionHeader.h
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8RecordDetailCollectionHeader : UIView


/**
 配置头部信息

 @param recNum 接受人数
 @param rejNum 拒绝人数
 @param unrNum 未响应人数
 */
- (void)configRecNum:(NSInteger)recNum rejNum:(NSInteger)rejNum unrNum:(NSInteger)unrNum;

@end
