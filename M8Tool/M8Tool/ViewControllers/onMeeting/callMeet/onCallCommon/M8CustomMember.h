//
//  M8CustomMember.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <TILCallSDK/TILCallSDK.h>

@interface M8CustomMember : TILCallMember

/*
 来电房间内成员类型
@interface TILCallMember : NSObject

 成员id
@property(nonatomic,strong) NSString * identifier;

 是否有音频上行
@property(nonatomic,assign) BOOL isAudio;

 是否有视频上行
@property(nonatomic,assign) BOOL isCameraVideo;

@end
*/

/**
 是否在背景视图显示
 */
@property (nonatomic, assign) BOOL isInback;

@end
