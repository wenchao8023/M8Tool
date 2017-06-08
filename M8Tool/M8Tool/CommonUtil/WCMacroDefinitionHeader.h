

#ifndef WCMacroDefinitionHeader_h
#define WCMacroDefinitionHeader_h

#pragma mark - 1 获取屏幕宽度与高度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark -- 1.1 需要横屏或者竖屏，获取屏幕宽度与高度
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
//
//#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
//#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
//#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
//#else
//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//#endif


#pragma mark - 2 获取通知中心
#define WCNotificationCenter [NSNotificationCenter defaultCenter]


#pragma mark - 3 设置颜色
#define WCBlack                 [UIColor blackColor]            //黑色
#define WCDarkGray              [UIColor darkGrayColor]         //深灰
#define WCLightGray             [UIColor lightGrayColor]        //浅灰
#define WCWhite                 [UIColor whiteColor]            //白色
#define WCGray                  [UIColor grayColor]             //灰色
#define WCRed                   [UIColor redColor]              //红色
#define WCGreen                 [UIColor greenColor]            //绿色
#define WCBlue                  [UIColor blueColor]             //蓝色
#define WCCyan                  [UIColor cyanColor]             //天蓝色
#define WCYellow                [UIColor yellowColor]           //黄色
#define WCMagenta               [UIColor magentaColor]          //洋红色
#define WCOrange                [UIColor orangeColor]           //橘色
#define WCPurple                [UIColor purpleColor]           //紫色
#define WCBrown                 [UIColor brownColor]            //棕色
#define WCClear                 [UIColor clearColor]            //透明色
#define WCRandomColor           [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]       //随机色
#define WCRGBColor(r, g, b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]   //设置RGB颜色
#define WCRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]     //设置RGBA颜色

#define WCBgColor               [UIColor colorWithRed:0.98 green:0.96 blue:0.93 alpha:1]    // 视图背景颜色
#define WCButtonColor           [UIColor colorWithRed:0.04 green:0.43 blue:0.4 alpha:1]     // 按钮背景颜色
#define WCTabbarSelectedColor   [UIColor colorWithRed:0.07 green:0.45 blue:0.43 alpha:1]    // 底部 tabBar 选中文字颜色
#define WCTabbarNormalColor     WCBlack                                                     // 底部 tabBar 未选中文字颜色



#pragma mark - 4 自定义高效率的 NSLog
#ifdef DEBUG
/**
 *  输出一 __func__    调用打印的函数
 *  输出二 __LINE__    打印日志的位置
 *  输出三 __VA_ARGS__ 打印日志的内容
 */
#define WCLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define WCLog(...)
#endif

#pragma mark - 5 弱引用/强引用
#define WCWeakSelf(type)    __weak typeof(type) weak##type = type;
#define WCStrongSelf(type)  __strong typeof(type) type = weak##type;

#pragma mark - 6 设置 view.layer
#pragma mark -- 6.1 设置 view 圆角
#define WCViewBorder_Radius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];

#pragma mark -- 6.2 设置 view 边框
#define WCViewBorder_Width_Color(View, Width, Color)\
\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#pragma mark -- 6.3 设置 view 圆角和边框
#define WCViewBorder_Radius_Width_Color(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


#pragma mark - 7 由角度转换弧度 由弧度转换角度
#define WCDegreesToRadian(x) (M_PI * (x) / 180.0)
#define WCRadianToDegrees(radian) (radian*180.0)/(M_PI)


#pragma mark - 8 获取 keyWindow 对象
#define kWindow [UIApplication sharedApplication].keyWindow


#pragma mark - 9 获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]


#pragma mark - 10 获取当前语言
#define WCCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark - 11 使用 ARC 和 MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


#pragma mark - 12 判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 5SE
#define iPhone5SE ([[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f)

// 判断是否为iPhone 6/6s
#define iPhone6_6s ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)

//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER ((IOS_SYSTEM_VERSION >=8.0)? (YES):(NO))


#pragma mark - 13 判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

#pragma mark - 14 沙盒目录文件
//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark - 15 GCD 的宏定义
#pragma mark -- GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

#pragma mark -- GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

#pragma mark -- GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);




#endif /* WCMacroDefinitionHeader_h */
