//
//  M8CallViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+UI.h"

@implementation M8CallViewController (UI)


#pragma mark - views delegate
#pragma mark -- MeetHeaderDelegate
- (void)MeetHeaderActionInfo:(NSDictionary *)actionInfo {
    
//    [self addTextToView:[actionInfo allValues][0]];
//    
//    NSString *infoKey = [[actionInfo allKeys] firstObject];
//    //    NSString *infoValue = [actionInfo objectForKey:infoKey];
//    if ([infoKey isEqualToString:kHeaderAction]) {
//        [self showFloatView];
//    }
}


#pragma mark -- M8DeviceDelegate
- (void)M8DeviceViewActionInfo:(NSDictionary *)actionInfo
{
    
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo {
    
//    [self addTextToView:[actionInfo allValues][0]];
//    
//    NSString *infoKey = [[actionInfo allKeys] firstObject];
//    
//    if ([infoKey isEqualToString:kCallValue_model]) {   // value : @{identify : model}
//        NSDictionary *valueDic = [actionInfo objectForKey:infoKey];
//        NSString *valueKey = [valueDic allKeys][0];
//        self.currentIdentify = valueKey;
//        
//        // config float view with model
//        [self.floatView configWithRenderModel:[valueDic objectForKey:valueKey]];
//    }
//    
//    if ([infoKey isEqualToString:kCallAction]) {
//        NSString *infoValue = [actionInfo objectForKey:infoKey];
//        if ([infoValue isEqualToString:@"inviteAction"]) {
//            UserContactViewController *contactVC = [[UserContactViewController alloc] init];
//            contactVC.isExitLeftItem = YES;
//            contactVC.contactType = ContactType_sel;
//            //            [self.navigationController pushViewController:contactVC animated:YES];
//            [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
//        }
//    }
}




@end
