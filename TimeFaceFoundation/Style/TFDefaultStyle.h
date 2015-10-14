//
//  TFDefaultStyle.h
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFStyle.h"

@interface TFDefaultStyle : TFStyle

/////////////////////////////////////////////全局字体格式定义//////////////////////////////////////////

/**
 *  8号字体
 */
@property (nonatomic ,readonly) UIFont  *font8;
/**
 *  10号字体
 */
@property (nonatomic ,readonly) UIFont  *font10;
/**
 *  10号粗体字体
 */
@property (nonatomic ,readonly) UIFont  *font10B;
/**
 *  12号字体
 */
@property (nonatomic ,readonly) UIFont  *font12;
/**
 *  12号粗体字体
 */
@property (nonatomic ,readonly) UIFont  *font12B;
/**
 *  14号字体
 */
@property (nonatomic ,readonly) UIFont  *font14;

@property (nonatomic ,readonly) UIFont  *timeContentFont;
@property (nonatomic ,readonly) UIFont  *timeTitleFont;
/**
 *  14号粗体字体
 */
@property (nonatomic ,readonly) UIFont  *font14B;

/**
*  15号字体
*/
@property (nonatomic ,readonly) UIFont  *font15;
/**
 *  15号加粗字体
 */
@property (nonatomic ,readonly) UIFont  *font15B;

/**
 *  16号字体
 */
@property (nonatomic ,readonly) UIFont  *font16;
/**
 *  16号加粗字体
 */
@property (nonatomic ,readonly) UIFont  *font16B;

/**
 *  18号字体
 */
@property (nonatomic ,readonly) UIFont  *font18;
/**
 *  18号加粗字体
 */
@property (nonatomic ,readonly) UIFont  *font18B;
/**
 *  20号字体
 */
@property (nonatomic ,readonly) UIFont  *font20;
/**
 *  20号加粗字体
 */
@property (nonatomic ,readonly) UIFont  *font20B;
/**
 *  30号字体
 */
@property (nonatomic ,readonly) UIFont  *font30;

/**
 *  默认黑
 */
@property (nonatomic ,readonly) UIColor *defaultBlackColor;
/**
 *  默认蓝
 */
@property (nonatomic ,readonly) UIColor *defaultBlueColor;
@property (nonatomic ,readonly) UIColor *defaultBlueDragColor;
/**
 *  默认灰
 */
@property (nonatomic ,readonly) UIColor *defaultGrayColor;
/**
 *  默认绿
 */
@property (nonatomic ,readonly) UIColor *defaultGreenColor;
@property (nonatomic ,readonly) UIColor *defaultGreenDragColor;
/**
 *  默认红
 */
@property (nonatomic ,readonly) UIColor *defaultRedColor;
/**
 *  默认深红
 */
@property (nonatomic ,readonly) UIColor *defaultRedDragColor;
/**
 *  默认白
 */
@property (nonatomic ,readonly) UIColor *defaultWhiteColor;
/**
 *  默认占位符颜色
 */
@property (nonatomic ,readonly) UIColor *defaultPlaceholderColor;
/**
 *  默认分割线颜色
 */
@property (nonatomic ,readonly) UIColor *defaultSplitLineColor;
/**
 *  默认背景灰色
 */
@property (nonatomic ,readonly) UIColor *defaultBackgroundGrayColor;
/**
 *  默认亮灰色
 */
@property (nonatomic, readonly) UIColor *defaultHighLightGrayColor;
/**
 *  默认橙色
 */
@property (nonatomic, readonly) UIColor *defaultOrangeColor;
/**
 *  默认视图背景颜色
 */
@property (nonatomic, readonly) UIColor *defaultViewBackgroundColor;

@property (nonatomic ,readonly) UIColor *lineColor;
/**
 *  333字体颜色
 */
@property (nonatomic ,readonly) UIColor *textColor;
/**
 *  555字体颜色
 */
@property (nonatomic ,readonly) UIColor *textColor2;
/**
 *  666字体颜色
 */
@property (nonatomic ,readonly) UIColor *textColor3;


@property (nonatomic ,readonly) UIColor *viewBackgroundColor;

@property (nonatomic ,readonly) UIColor *navBarBackgroundColor;

@property (nonatomic ,readonly) UIFont  *navBarTitleFont;

@property (nonatomic ,readonly) UIColor *navBarTitleColor;

@property (nonatomic ,readonly) UIColor *defaultTabBarBgColor;

///////////////////////////////////////////动态关注字体格式定义/////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *nickNameTextColor;
@property (nonatomic ,readonly) UIColor *timeClientTextColor;
@property (nonatomic ,readonly) UIColor *timeTitleTextColor;
@property (nonatomic ,readonly) UIColor *bookTitleTextColor;

///////////////////////////////////////////AlertView样式定义/////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *alertCancelColor;

/**
 *  登录页面
 */
@property (nonatomic ,readonly) UIColor *loginButtonEnableColor;
/**
 *  注册页面
 */
@property (nonatomic ,readonly) UIColor *verifyEnableTextColor;
@property (nonatomic ,readonly) UIColor *verifyEnableBorderColor;

/**
 *  左侧菜单－黄色
 */
@property (nonatomic ,readonly) UIColor *leftMenuYellowColor;
@property (nonatomic ,readonly) UIColor *leftMenuGrayColor;
/**
 *  设置页面
 */
@property (nonatomic ,readonly) UIColor *signOutTextColor;

/**
 *  分享页面
 */
@property (nonatomic ,readonly) UIColor *shareViewLineColor;
@property (nonatomic ,readonly) UIColor *shareContentBgColor;
@property (nonatomic ,readonly) UIColor *tfBlurIntroductionPageControlNormalColor;

/**
 *  用户中心页面
 */
@property (nonatomic ,readonly) UIColor *avatarBorderColor;
/**
 *  时光列表页面
 */
@property (nonatomic ,readonly) UIColor *timeEdgeBackgroundColor;
@property (nonatomic ,readonly) UIColor *userEdgeBackgroundColor;
@property (nonatomic ,readonly) UIColor *needleColor;

/**
 *  订单详情
 */
@property (nonatomic ,readonly) UIColor *paymentRedColor;
/**
 *  物流列表页面
 */
@property (nonatomic ,readonly) UIColor *logisticGrayColor;
@property (nonatomic ,readonly) UIColor *logisticGrayLineColor;

/**
 *  活动列表页面
 */
@property (nonatomic ,readonly) UIColor *eventBlueColor;
@property (nonatomic ,readonly) UIColor *eventBlackColor;
@property (nonatomic ,readonly) UIColor *eventGrayColor;

/////////////////////////////////////////////HUD提示-START//////////////////////////////////////////
@property (nonatomic ,readonly) UIFont  *loadingTextFont;
@property (nonatomic ,readonly) UIColor *loadingTextColor;
@property (nonatomic ,readonly) UIColor *reloadLineColor;
/////////////////////////////////////////////HUD提示-END////////////////////////////////////////////

/**
 *  用户名称颜色值
 */
@property (nonatomic ,readonly) UIColor *personNameKeyColor;
/**
 *  搜索输入框placeholder颜色值
 */
@property (nonatomic, readonly) UIColor *searchPlaceHolderColor;
/**
 *  追溯字体颜色
 */
@property (nonatomic, readonly) UIColor *traceLabelColor;
/**
 *  赞和评论数字颜色
 */
@property (nonatomic, readonly) UIColor *actionCountNumberColor;
/**
 *  时光详情里地线
 */
@property (nonatomic, readonly) UIColor *timeDetailLineColor;
/**
 *  搜索无结果时的颜色数组
 */
@property (nonatomic, readonly) NSArray *searchNotResultColors;
/**
 *  推荐logo背景色
 */
@property (nonatomic, readonly) UIColor *recommendLogoBgColor;
/**
 *  对话字体颜色
 */
@property (nonatomic, readonly) UIColor *dialogContentColor;


/////////////////////////////////////////////////记录时光////////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *sendButtonColor;
@property (nonatomic ,readonly) UIColor *lightLineColor;
@property (nonatomic ,readonly) UIColor *boldLineColor;
@property (nonatomic ,readonly) UIColor *sectionHeaderTextColor;
@property (nonatomic ,readonly) UIColor *sectionBgColor;
@property (nonatomic ,readonly) UIColor *searchBgColor;
@property (nonatomic ,readonly) UIColor *searchLineColor;
@property (nonatomic ,readonly) UIColor *slectedBgColor;
@property (nonatomic ,readonly) UIColor *postTimeProgressColor;
@property (nonatomic ,readonly) UIColor *circleSendButtonColor;
////////////////////////////////////////////////记录时光/////////////////////////////////////////////

////////////////////////////////////////////////收藏列表/////////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *collectionAuthorColor;
@property (nonatomic ,readonly) UIColor *collectionDateColor;
@property (nonatomic ,readonly) UIColor *podDownloadProgressColor;
@property (nonatomic ,readonly) UIColor *podDownloadBgColor;
////////////////////////////////////////////////收藏列表/////////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *printerTabBgColor;


@property (nonatomic ,readonly) UIColor *searchTabColor;
@property (nonatomic ,readonly) UIColor *searchTabBgColor;

@property (nonatomic ,readonly) NSArray *introColors;
@property (nonatomic ,readonly) NSArray *circleColors;
@property (nonatomic ,readonly) NSArray *viewStateLoading;

@property (nonatomic, readonly) UIColor *numLogoBackgroundColor;

@property (nonatomic, readonly) UIColor *librarySelectedBgColor;

@property (nonatomic, readonly) UIColor *librarySelectedHBgColor;
/**
 *  活动发起人字体颜色
 */
@property (nonatomic, readonly) UIColor *sponsorTextColor;
/**
 *  选择时光页面背景图片
 */
@property (nonatomic, readonly) UIColor *selectTimeBgColor;

/**
 *  微信书
 */
@property (nonatomic, readonly) UIColor *bottomBackgroundColor;
@property (nonatomic, readonly) UIColor *waitCheckColor;
/**
 *  首页时光背景图片数组
 */
@property (nonatomic, readonly) NSArray *timeBgImageArray;
/**
 *  首页内容字体颜色
 */
@property (nonatomic, readonly) UIColor *homeContentTextColor;
/**
 *  自定义浅蓝色
 */
@property (nonatomic, readonly) UIColor *customLightBlue;
/**
 *  新品优惠背景
 */
@property (nonatomic, readonly) UIColor *preferentialFreshColor;
/**
 *  满减优惠背景
 */
@property (nonatomic, readonly) UIColor *preferentialReduceColor;

@property (nonatomic, readonly) UIColor *refreshBgColor;


@property (nonatomic, readonly) NSArray *refreshBallArray;

@end
