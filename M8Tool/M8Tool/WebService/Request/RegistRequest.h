//
//  RegistRequest.h
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/11/30.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "BaseRequest.h"

@interface RegistRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *nick;
@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *pwd;

@end

