//
//  M8LivePlayView.m
//  M8Tool
//
//  Created by chao on 2017/6/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LivePlayView.h"


@interface M8LivePlayView ()

@property (nonatomic, strong) NSMutableArray *identifierArray;
@property (nonatomic, strong) NSMutableArray *srcTypeArray;

@end




@implementation M8LivePlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _identifierArray = [[NSMutableArray alloc] init];
        _srcTypeArray = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -- ILVLiveAVListener
- (void)onUserUpdateInfo:(ILVLiveAVEvent)event users:(NSArray *)users{
    TILLiveManager *manager = [TILLiveManager getInstance];
    switch(event) {
        case ILVLIVE_AVEVENT_MEMBER_ENTER:
        {
            
        }
        case ILVLIVE_AVEVENT_MEMBER_EXIT:
        {
            
        }
        case ILVLIVE_AVEVENT_CAMERA_ON:
        {
            //视频事件
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_CAMERA)];
                }
                else{
                    [manager addAVRenderView:self.bounds forIdentifier:_host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_CAMERA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
            break;
        case ILVLIVE_AVEVENT_SCREEN_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_SCREEN)];
                }
                else{
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_SCREEN_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        case ILVLIVE_AVEVENT_MEDIA_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    [manager addAVRenderView:[self getRenderFrame:_identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [_identifierArray addObject:user];
                    [_srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_MEDIA)];
                }
                else{
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_MEDIA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:_host]){
                    NSInteger index = [_identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [_identifierArray removeObjectAtIndex:index];
                    [_srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        default:
            break;
    }
}

- (CGRect)getRenderFrame:(NSInteger)count{
    if(count == 3){
        return CGRectZero;
    }
    CGFloat height = (self.height - 2*20 - 3 * 10)/3;
    CGFloat width = height*3/4;//宽高比3:4
    CGFloat y = 20 + (count * (height + 10));
    CGFloat x = 20;
    return CGRectMake(x, y, width, height);
}

- (void)updateRenderFrame{
    TILLiveManager *manager = [TILLiveManager getInstance];
    for(NSInteger index = 0; index < _identifierArray.count; index++){
        CGRect frame = [self getRenderFrame:index];
        NSString *identifier = _identifierArray[index];
        avVideoSrcType srcType = [_srcTypeArray[index] intValue];
        [manager modifyAVRenderView:frame forIdentifier:identifier srcType:srcType];
    }
}


@end
