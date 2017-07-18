//
//  WebModels.h
//  TCShow
//
//  Created by AlexiChen on 15/11/12.
//  Copyright © 2015年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, M8MeetType)
{
    M8MeetTypeCall,
    M8MeetTypeLive,
};



@interface ShowRoomInfo : NSObject

@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable type;    //live : 直播, call_video : 视频通话, call_audio : 音频通话
@property (nonatomic, assign) NSInteger roomnum;
@property (nonatomic, copy) NSString * _Nullable groupid;
@property (nonatomic, copy) NSString * _Nullable cover;
@property (nonatomic, copy) NSString * _Nullable host;
@property (nonatomic, assign) NSInteger appid;
@property (nonatomic, assign) int thumbup;//点赞数
@property (nonatomic, assign) int memsize;//观看人数
@property (nonatomic, assign) NSInteger device;
@property (nonatomic, assign) NSInteger videotype;

- (NSDictionary *_Nullable)toRoomDic;

@end


@interface TCShowLiveListItem : NSObject

@property (nonatomic, copy) NSString * _Nullable uid;
@property (nonatomic, strong) ShowRoomInfo * _Nullable info;
@property (nonatomic, strong, nullable) NSArray *members;  //通话中邀请的成员
@property (nonatomic, assign) TILCallType callType; //通话模式（音频、视频）


+ (instancetype _Nullable )loadFromToLocal;

- (void)saveToLocal;
- (void)cleanLocalData;

- (NSDictionary * _Nullable )toLiveStartJson;
- (NSDictionary * _Nullable )toHeartBeatJson;

@end

@interface RecordVideoItem : NSObject

@property (nonatomic, copy) NSString * _Nullable uid;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable cover;
@property (nonatomic, copy) NSString * _Nullable videoId;
@property (nonatomic, strong) NSMutableArray * _Nullable playurl;

@end

@interface MemberListItem : NSObject

@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, assign) int role;

//业务逻辑需要
@property (nonatomic, assign) BOOL isUpVideo;

@end

@interface LiveStreamListItem : NSObject

@property (nonatomic, copy) NSString * _Nullable uid;
@property (nonatomic, copy) NSString * _Nullable cover;
@property (nonatomic, copy) NSString * _Nullable address;//拼接地址
@property (nonatomic, copy) NSString * _Nullable address2;//拼接地址
@property (nonatomic, copy) NSString * _Nullable address3;//拼接地址

@end
