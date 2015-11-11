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

/////////////////////////////////////////////全局颜色定义//////////////////////////////////////////

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





@property (nonatomic ,readonly) UIColor *viewBackgroundColor;

@property (nonatomic ,readonly) UIColor *navBarBackgroundColor;

@property (nonatomic ,readonly) UIFont  *navBarTitleFont;

@property (nonatomic ,readonly) UIColor *navBarTitleColor;

@property (nonatomic ,readonly) UIColor *defaultTabBarBgColor;

/////////////////////////////////////////////HUD提示-START//////////////////////////////////////////
@property (nonatomic ,readonly) UIFont  *loadingTextFont;
@property (nonatomic ,readonly) UIColor *loadingTextColor;
@property (nonatomic ,readonly) UIColor *reloadLineColor;
/////////////////////////////////////////////HUD提示-END////////////////////////////////////////////



///////////////////////////////////////////AlertView样式定义/////////////////////////////////////////
@property (nonatomic ,readonly) UIColor *alertCancelColor;


/**
 *  搜索无结果时的颜色数组
 */
@property (nonatomic, readonly) NSArray *searchNotResultColors;




@end
