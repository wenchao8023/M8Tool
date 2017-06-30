//
//  M8LiveMakeViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveBaseViewController.h"

@interface M8LiveMakeViewController : M8LiveBaseViewController
{
    TCShowLiveListItem *_liveItem;
    BOOL _isHost;
    
}

- (instancetype)initWithItem:(id _Nonnull)item;

@property (nonatomic, assign) int roomId;
@property (nonatomic, strong) NSString *host;

@end
