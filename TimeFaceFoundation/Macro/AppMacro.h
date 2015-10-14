//
//  AppMacro.h
//  TFProject
//
//  Created boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////
// Color helpers

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f \
blue:(b)/255.0f alpha:1.0f]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)

///////////////////////////////////////////////////////////////////////////////////////////////////
// Style helpers

#define TFSTYLE(_SELECTOR) [[TFStyle globalStyleSheet] styleWithSelector:@#_SELECTOR]

#define TFSTYLESTATE(_SELECTOR, _STATE) [[TFStyle globalStyleSheet] \
styleWithSelector:@#_SELECTOR forState:_STATE]

#define TFSTYLESHEET ((id)[TFStyle globalStyleSheet])

#define TFSTYLEVAR(_VARNAME) [TFSTYLESHEET _VARNAME]

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSLog helpers

//#define TFLog(format, ...) NSLog(format, ## __VA_ARGS__)
#ifdef DEBUG
#define TFLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TFLog(format, ...)
#endif

const static CGFloat kNoticeoffset = 3000.0f;

#if __IPHONE_9_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_9_0
#define IS_RUNNING_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#else
#define IS_RUNNING_IOS9 NO
#endif


#define NAV_BUTTON_SPACE            TTOSVersion()>=7?0:8
#define NSNullObjects               @[@"",@0,@{},@[]]


//Splash 页面默认消失时间
#define DEFAULT_SPLASH_TIME         3

//倒计时－默认的秒数
#define kDefaultSecondsCountdown    60

//字符行间距
#define LINESPACE                   6
//默认左右边距
#define VIEW_LEFT_SPACE             12



#define SSelected           @"SSelected"

#define APP_ERROR_DOMAIN            @"cn.timeface.app.ios"





typedef NS_ENUM (NSInteger, TFErrorCode) {
    /**
     *  未知错误
     */
    TFErrorCodeUnknown      =   0,
    /**
     *  API错误
     */
    TFErrorCodeAPI          =   1,
    /**
     *  HTTP错误
     */
    TFErrorCodeHTTP         =   2,
    /**
     *  网络错误
     */
    TFErrorCodeNetwork      =   3,
    /**
     *  空数据
     */
    TFErrorCodeEmpty        =   4,
    /**
     *  类型错误
     */
    TFErrorCodeClassType    =   5,

  
};
typedef NS_ENUM(NSInteger, LoginStatus) {
    /**
     *  进入Timeface
     */
    LoginStatusDefault = 0,
    /**
     *  补充信息
     */
    LoginStatusChangeInfo = 1,
    /**
     *  选择兴趣
     */
    LoginStatusChooseInterestes = 2,
};
// toast提示类型
typedef NS_ENUM (NSInteger, MessageType) {
    /**
     *  默认提示
     */
    MessageTypeDefault             = 0,
    /**
     *  成功提示
     */
    MessageTypeSuccess                = 1,
    /**
     *  失败提示
     */
    MessageTypeFaild               = 2,
};


// 用户类型
typedef NS_ENUM (NSInteger, MemberType) {
	MemberTypeOthers                    = 1,
	MemberTypeMyself                    = 2,
	
};
// 时光类型
typedef NS_ENUM (NSInteger, TimeType) {
    /**
     *  动态
     */
    TimeTypeDefault    = 2,
    /**
     *  话题
     */
    TimeTypeTopic      = 1,
    /**
     *  时光圈时光
     */
    TimeTypeCircleTime = 3,
};


typedef NS_ENUM(NSInteger, ScrollDirection) {
    /**
     *  默认值
     */
    ScrollDirectionNone,
    /**
     *  向上滑动
     */
    ScrollDirectionUp,
    /**
     *  向下滑动
     */
    ScrollDirectionDown,
    /**
     *  向左滑动
     */
    ScrollDirectionLeft,
    /**
     *  向右滑动
     */
    ScrollDirectionRight,
    /**
     *  垂直滑动
     */
    ScrollDirectionVertical,
    /**
     *  水平滑动
     */
    ScrollDirectionHorizontal
};


typedef NS_ENUM(NSInteger, PushActionType) {
    /**
     *  进入web页面
     */
    PushActionTypeWebView        =  1,
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//本地存储key定义
#define STORE_KEY_SCROLLNOTICE      @"STORE_KEY_SCROLLNOTICE"

//图片质量设置
#define STORE_KEY_PICTUREQUALITYUPLOAD        @"STORE_KEY_PICTUREQUALITYUPLOAD"     //上传图片质量
#define STORE_KEY_PICTUREQUALITYBROWSE        @"STORE_KEY_PICTUREQUALITYBROWSE"     //浏览图片质量

#define TIMEOUT_ORDER_CONFIRM               (60*60*24*7)

#define STORE_KEY_REGION_TIME               (60*60*24*7)
#define STORE_KEY_REGION                    @"STORE_KEY_REGION"//表


#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)




