//
//  M8LoginWebService+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService.h"

@interface M8LoginWebService (UI)

- (void)onLoginFailAlertInfo:(NSString *)errorInfo;

- (void)onRegistFailAlertInfo:(NSString *)errorInfo;

- (void)onLoginSucc:(NSString *)identifier password:(NSString *)password;


@end
