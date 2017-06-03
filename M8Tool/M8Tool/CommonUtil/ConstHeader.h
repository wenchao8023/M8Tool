
//#import "WCMacroDefinitionHeader.h"

#ifndef ConstHeader_h
#define ConstHeader_h


#define ShowAppId       @"1400025495"
#define ShowAccountType @"11456"


/******************** font ********************************/
//font size
//#if ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)
//static const int kAppNaviFontSize   = 18;
//static const int kAppLargeFontSize  = 15;
//static const int kAppMiddleFontSize = 13;
//static const int kAppSmallFontSize  = 11;
//#elif iPhone6_6s
//static const int kAppNaviFontSize   = 19;
//static const int kAppLargeFontSize  = 16;
//static const int kAppMiddleFontSize = 14;
//static const int kAppSmallFontSize  = 12;
//#else 
//static const int kAppNaviFontSize   = 20;
//static const int kAppLargeFontSize  = 17;
//static const int kAppMiddleFontSize = 15;
//static const int kAppSmallFontSize  = 13;
//#endif
#define kAppNaviFontSize    (iPhone5SE ? 18 : (iPhone6_6s ? 19 : 20))
#define kAppLargeFontSize   (iPhone5SE ? 15 : (iPhone6_6s ? 16 : 17))
#define kAppMiddleFontSize  (iPhone5SE ? 13 : (iPhone6_6s ? 14 : 15))
#define kAppSmallFontSize   (iPhone5SE ? 11 : (iPhone6_6s ? 12 : 13))


//font name defalut is Heiti SC
#define kFontNameDroidSansFallback      @"DroidSansFallback"
#define kFontNameSTHeiti                @"STHeiti"
#define kFontNameHeiti_SC               @"Heiti SC"

//text kern defalut is 0
static const int kAppKern_0 = 0;
static const int kAppKern_2 = 2;
static const int kAppKern_4 = 4;
static const int kAppKern_8 = 8;

/******************** icon ********************************/
#define kDefaultUserIcon            [UIImage imageNamed:@"default_head"]
#define kDefaultCoverIcon           [UIImage imageNamed:@"default_cover"]

/******************** default *****************************/
static const int kDefaultCellHeight     = 44;
static const int kDefaultMargin         = 8;
static const int kDefaultNaviHeight     = 64;
static const int kDefaultTabbarHeight   = 49;
static const int kDefaultStatuHeight    = 20;




/******************** block *******************************/
typedef void (^ActionHandle)(UIAlertAction * _Nonnull action);
typedef void (^EditAlertHandle)(NSString * _Nonnull editString);

/******************** custom msg cmd **********************/
typedef NS_ENUM(NSInteger, ShowCustomCmd)
{
    AVIMCMD_Text = -1,          // 普通的聊天消息
    
    AVIMCMD_None,               // 无事件：0
    
    // 以下事件为TCAdapter内部处理的通用事件
    AVIMCMD_EnterLive,          // 用户加入直播, Group消息 ： 1
    AVIMCMD_ExitLive,           // 用户退出直播, Group消息 ： 2
    AVIMCMD_Praise,             // 点赞消息, Demo中使用Group消息 ： 3
    AVIMCMD_Host_Leave,         // 主播或互动观众离开, Group消息 ： 4
    AVIMCMD_Host_Back,          // 主播或互动观众回来, Group消息 ： 5
    
//    ShowCustomCmd_Begin = ILVLIVE_IMCMD_CUSTOM_LOW_LIMIT,
//    ShowCustomCmd_Praise,
//    ShowCustomCmd_JoinRoom,
//    ShowCustomCmd_DownVideo,//主播发送下麦通知
    
    AVIMCMD_Multi = ILVLIVE_IMCMD_CUSTOM_LOW_LIMIT,              // 多人互动消息类型 ： 2048
    
    AVIMCMD_Multi_Host_Invite,          // 多人主播发送邀请消息, C2C消息 ： 2049
    AVIMCMD_Multi_CancelInteract,       // 已进入互动时，断开互动，Group消息，带断开者的imUsreid参数 ： 2050
    AVIMCMD_Multi_Interact_Join,        // 多人互动方收到AVIMCMD_Multi_Host_Invite多人邀请后，同意，C2C消息 ： 2051
    AVIMCMD_Multi_Interact_Refuse,      // 多人互动方收到AVIMCMD_Multi_Invite多人邀请后，拒绝，C2C消息 ： 2052
    
    // =======================
    // 暂未处理以下
    AVIMCMD_Multi_Host_EnableInteractMic,  // 主播打开互动者Mic，C2C消息 ： 2053
    AVIMCMD_Multi_Host_DisableInteractMic, // 主播关闭互动者Mic，C2C消息 ：2054
    AVIMCMD_Multi_Host_EnableInteractCamera, // 主播打开互动者Camera，C2C消息 ：2055
    AVIMCMD_Multi_Host_DisableInteractCamera, // 主播关闭互动者Camera，C2C消息 ： 2056
    // ==========================
    
    
    AVIMCMD_Multi_Host_CancelInvite,            // 取消互动, 主播向发送AVIMCMD_Multi_Host_Invite的人，再发送取消邀请， 已发送邀请消息, C2C消息 ： 2057
    AVIMCMD_Multi_Host_ControlCamera,           // 主动控制互动观众摄像头, 主播向互动观众发送,互动观众接收时, 根据本地摄像头状态，来控制摄像头开关（即控制对方视频是否上行视频）， C2C消息 ： 2058
    AVIMCMD_Multi_Host_ControlMic,              // 主动控制互动观众Mic, 主播向互动观众发送,互动观众接收时, 根据本地MIC状态,来控制摄像头开关（即控制对方视频是否上行音频），C2C消息 ： 2059
};

typedef NS_ENUM(NSInteger, BeautyViewType)
{
    BeautyViewType_Beauty = 0,
    BeautyViewType_White,
};
/******************** notification **********************/
#define kUserParise_Notification        @"kUserParise_Notification"
//#define kUserJoinRoom_Notification      @"kUserJoinRoom_Notification"
//#define kUserExitRoom_Notification      @"kUserExitRoom_Notification"
#define kUserMemChange_Notification      @"kUserMemChange_Notification"
#define kUserUpVideo_Notification       @"kUserUpVideo_Notification"
#define kUserDownVideo_Notification     @"kUserDownVideo_Notification"
#define kUserSwitchRoom_Notification    @"kUserSwitchRoom_Notification"
#define kGroupDelete_Notification       @"kGroupDelete_Notification"
#define kPureDelete_Notification        @"kPureDelete_Notification"
#define kNoPureDelete_Notification      @"kNoPureDelete_Notification"
#define kClickConnect_Notification      @"kClickConnect_Notification"
#define kCancelConnect_Notification     @"kCancelConnect_Notification"
#define kEnterBackGround_Notification   @"kEnterBackGround_Notification"

/******************** role string **********************/
#define kSxbRole_Host       @"LiveMaster"
#define kSxbRole_Guest      @"Guest"
#define kSxbRole_Interact   @"LiveGuest"

/******************** local param **********************/
#define kLoginParam         @"kLoginParam"
#define kLoginIdentifier    @"kLoginIdentifier"
#define kLoginPassward      @"kLoginPassward"
#define kEnvParam           @"kEnvParam"
#define kLogLevel           @"kLogLevel"
#define kUserProtocol       @"kUserProtocol"
#define kHasLogin           @"kHasLogin"

/******************** appstore **********************/
#define kIsAppstoreVersion 0


#endif /* ConstHeader_h */
