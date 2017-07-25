//
//  MeetingViewController+IFlyMSC.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingViewController+IFlyMSC.h"

@implementation MeetingViewController (IFlyMSC)

- (void)onSpeechAction
{
    NSString *speechStr = nil;
    if ([self.speechBtn.titleLabel.text isEqualToString:@"听写"])
    {
        // begin speech recognize
        speechStr = @"停止";
        
        [self.iFlySpeechRecognizer startListening];
    }
    else if ([self.speechBtn.titleLabel.text isEqualToString:@"停止"])
    {
        // end speech recognize
        speechStr = @"听写";
        [self.iFlySpeechRecognizer stopListening];
    }
    
    [self.speechBtn setAttributedTitle:[CommonUtil customAttString:speechStr
                                                     fontSize:kAppMiddleFontSize
                                                    textColor:WCWhite
                                                    charSpace:kAppKern_0]
                         forState:UIControlStateNormal];
}


//IFlySpeechRecognizerDelegate 协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic)
    {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [self stringFromJson:resultString];
    
    if (isLast)
    {
        NSLog(@"听写结果(json)：%@测试",  resultString);
    }
    
    NSLog(@"_result=%@",resultString);
    NSLog(@"resultFromJson=%@",resultFromJson);
    
    
    if ([resultFromJson containsString:@"语音会议"])
    {
        [self onPush:0];
    }
    else if ([resultFromJson containsString:@"视频会议"])
    {
        [self onPush:1];
    }
    else if ([resultFromJson containsString:@"直播会议"])
    {
        [self onPush:2];
    }
    else if ([resultFromJson containsString:@"手机通话"])
    {
        [self onPush:3];
    }
    else if ([resultFromJson containsString:@"预约会议"])
    {
        [self onPush:4];
    }
    else if ([resultFromJson containsString:@"会议笔记"])
    {
        [self onPush:5];
    }
    else if ([resultFromJson containsString:@"会议收藏"])
    {
        [self onPush:6];
    }
    else if ([resultFromJson containsString:@"通讯录"])
    {
        [self onPush:7];
    }
}

- (void)onPush:(NSInteger)index
{
    [self.buttonsCollection pushViewControllerWithIndex:index];
    [self.iFlySpeechRecognizer stopListening];
}

//识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error
{
    WCLog(@"onError : %@", [error errorDesc]);
    if (self.iFlySpeechRecognizer.isListening)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}

//停止录音回调
- (void) onEndOfSpeech
{
    WCLog(@"onEndOfSpeech");
    if (self.iFlySpeechRecognizer.isListening)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}

//开始录音回调
- (void) onBeginOfSpeech
{
    WCLog(@"onBeginOfSpeech");
}

//音量回调函数
- (void) onVolumeChanged: (int)volume
{
    WCLog(@"onVolumeChanged : %d", volume);
}

//会话取消回调
- (void) onCancel
{
    WCLog(@"onCancel");
    if (self.iFlySpeechRecognizer.isListening)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}


- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

@end
