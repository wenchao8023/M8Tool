//
//  M8RegistSuccViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SetPwdType){
    SetPwdTypeForgetPwd = 0,
    SetPwdTypeRegistSucc
};

@interface M8RegistSuccViewController : UIViewController

@property (nonatomic, assign) SetPwdType setPwdType;

@property (nonatomic, copy, nullable) NSString *nickName;
@property (nonatomic, copy, nullable) NSString *phoneNum;
@property (nonatomic, copy, nullable) NSString *veriCode;

@end
