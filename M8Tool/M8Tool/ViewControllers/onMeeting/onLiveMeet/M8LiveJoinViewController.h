//
//  M8LiveJoinViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveBaseViewController.h"

@interface M8LiveJoinViewController : M8LiveBaseViewController
{
    TCShowLiveListItem *_liveItem;
    BOOL _isHost;
}

- (instancetype _Nonnull )initWithItem:(id _Nonnull)item;
//@property (nonatomic, assign) int roomId;
//@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) TIMUserProfile * _Nullable selfProfile;//自己的信息

@end
