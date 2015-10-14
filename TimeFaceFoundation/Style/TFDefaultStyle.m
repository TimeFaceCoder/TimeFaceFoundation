//
//  TFDefaultStyle.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFDefaultStyle.h"

@implementation TFDefaultStyle

- (UIFont *)font8 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:10];
    }
    return [UIFont systemFontOfSize:8];
}
- (UIFont *)font10 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:11];
    }
    return [UIFont systemFontOfSize:10];
}
- (UIFont *)font10B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:11];
    }
    return [UIFont boldSystemFontOfSize:10];
}

- (UIFont *)font12 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:13];
    }
    return [UIFont systemFontOfSize:12];
}
- (UIFont *)font12B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:13];
    }
    return [UIFont boldSystemFontOfSize:12];
}

- (UIFont *)font14 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:15];
    }
    return [UIFont systemFontOfSize:14];
}



- (UIFont *)timeContentFont {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:16];
    }
    return [UIFont systemFontOfSize:14];
}

- (UIFont *)timeTitleFont {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:16];
    }
    return [UIFont boldSystemFontOfSize:15];
}

- (UIFont *)font14B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:15];
    }
    return [UIFont boldSystemFontOfSize:14];
}

- (UIFont *)font15 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:16];
    }
    return [UIFont systemFontOfSize:15];
}
- (UIFont *)font15B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:16];
    }
    return [UIFont boldSystemFontOfSize:15];
}

- (UIFont *)font16 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:17];
    }
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)font16B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:17];
    }
    return [UIFont boldSystemFontOfSize:16];
}

- (UIFont *)font18 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:20];
    }
    return [UIFont systemFontOfSize:18];
}

- (UIFont *)font18B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:20];
    }
    return [UIFont boldSystemFontOfSize:18];
}

- (UIFont *)font20 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:22];
    }
    return [UIFont systemFontOfSize:20];
}

- (UIFont *)font20B {
    if (iPhone6Plus) {
        return [UIFont boldSystemFontOfSize:22];
    }
    return [UIFont boldSystemFontOfSize:20];
}

- (UIFont *)font30 {
    if (iPhone6Plus) {
        return [UIFont systemFontOfSize:36];
    }
    return [UIFont systemFontOfSize:30];
}

- (UIColor *)defaultBlackColor {
    return [self getColorByHex:@"333333"];
}
- (UIColor *)defaultBlueColor {
    return [self getColorByHex:@"039ae3"];
}
- (UIColor *)defaultBlueDragColor {
    return [self getColorByHex:@"058ccd"];
}
- (UIColor *)defaultGrayColor {
    return [self getColorByHex:@"9b9b9b"];
}
- (UIColor *)defaultGreenColor {
    return [self getColorByHex:@"7bb427"];
}
- (UIColor *)defaultGreenDragColor {
    return [self getColorByHex:@"6faa19"];
}
- (UIColor *)defaultRedColor {
    return [self getColorByHex:@"f01204"];
}
- (UIColor *)defaultRedDragColor {
    return RGBCOLOR(180, 0, 27);
}
- (UIColor *)defaultWhiteColor {
    return [self getColorByHex:@"f0f0f0"];
}
- (UIColor *)defaultPlaceholderColor {
    return [self getColorByHex:@"bdbdbd"];
}
- (UIColor *)defaultSplitLineColor {
    return [self getColorByHex:@"bdbdbd"];
}
- (UIColor *)defaultBackgroundGrayColor {
    return [self getColorByHex:@"ededed"];
}
- (UIColor*)defaultHighLightGrayColor {
    return RGBCOLOR(104, 104, 104);
}
- (UIColor *)defaultOrangeColor {
    return RGBCOLOR(247, 153, 61);
}

- (UIColor *)defaultViewBackgroundColor {
    return RGBCOLOR(228, 231, 238);
}

- (UIColor *)defaultTabBarBgColor {
    return [self getColorByHex:@"F5F5F5"];
}

- (UIColor *)lineColor {
    return [self getColorByHex:@"9b9b9b"];
}

- (UIColor *)textColor {
    return [self getColorByHex:@"333333"];
}


- (UIColor *)textColor2 {
    return [self getColorByHex:@"555555"];
}
- (UIColor *)textColor3 {
    return [self getColorByHex:@"666666"];
}


- (UIColor *)viewBackgroundColor {
    return RGBCOLOR(226,230,236);
}

- (UIColor *)navBarBackgroundColor {
    return RGBCOLOR(180, 0, 27);
}

- (UIFont *)navBarTitleFont {
    return [UIFont systemFontOfSize:20];
}

- (UIColor *)navBarTitleColor {
    return [UIColor whiteColor];
}

- (UIColor *)nickNameTextColor {
    return [self getColorByHex:@"3db0e8"];
}

- (UIColor *)timeClientTextColor {
    return [self getColorByHex:@"999999"];
}
- (UIColor *)timeTitleTextColor {
    return [self getColorByHex:@"373535"];
}
- (UIColor *)bookTitleTextColor {
    return [self getColorByHex:@"7c7c7c"];
}

- (UIColor *)alertCancelColor {
    return [self getColorByHex:@"b5b5b5"];
}

- (UIColor*)dialogContentColor {
    return RGBCOLOR(51, 51, 51);
}

/**
 *  登录页面
 */
- (UIColor *)loginButtonEnableColor {
    return [self getColorByHex:@"002a42"];
}
/**
 *  注册页面
 */
- (UIColor *)verifyEnableTextColor {
    return [self getColorByHex:@"999999"];
}
- (UIColor *)verifyEnableBorderColor {
    return [self getColorByHex:@"c8c8c8"];
}
/**
 *  左侧菜单
 */
- (UIColor *)leftMenuYellowColor {
    return [self getColorByHex:@"fff000"];
}
- (UIColor *)leftMenuGrayColor {
    return [self getColorByHex:@"d8d8d8"];
}

/**
 *  设置页面
 */
- (UIColor *)signOutTextColor {
    return [self getColorByHex:@"ff3232"];
}


/**
 *  分享页面
 */
- (UIColor*)shareViewLineColor {
    return RGBCOLOR(221, 221, 221);
}
- (UIColor*)shareContentBgColor {
    return RGBCOLOR(240, 240, 240);
}

- (UIColor*)tfBlurIntroductionPageControlNormalColor {
    return RGBCOLOR(190, 215, 225);
}

/**
 *  用户中心页面
 */
-(UIColor *)avatarBorderColor {
    return [self getColorByHex:@"a1cce4"];
}

/**
 *  时光列表页面
 */
-(UIColor *)timeEdgeBackgroundColor {
    return [self getColorByHex:@"025f8b"];
}
-(UIColor *)userEdgeBackgroundColor {
    return [self getColorByHex:@"53576c"];
}

-(UIColor *)needleColor {
    return [self getColorByHex:@"f46d00"];
}

/**
 *  订单详情
 */
- (UIColor *)paymentRedColor {
    return [self getColorByHex:@"f45959"];
}

/**
 *  物流列表页面
 */
-(UIColor *)logisticGrayColor {
    return [self getColorByHex:@"c0c0c0"];
}
-(UIColor *)logisticGrayLineColor {
    return [self getColorByHex:@"cccccc"];
}

/**
 *  活动列表页面
 */
- (UIColor *)eventBlueColor {
    return [self getColorByHex:@"029fd7"];
}

- (UIColor *)eventBlackColor {
    return [self getColorByHex:@"666666"];
}
- (UIColor *)eventGrayColor {
    return [self getColorByHex:@"d9d9d9"];
}

/////////////////////////////////////////////HUD提示-START//////////////////////////////////////////
- (UIFont *)loadingTextFont {
    return [UIFont systemFontOfSize:16];
}
- (UIColor *)loadingTextColor {
    return [self getColorByHex:@"7c7c7c"];
}
- (UIColor *)reloadLineColor {
    return [self getColorByHex:@"dfdfdf"];
}
/////////////////////////////////////////////HUD提示-END////////////////////////////////////////////

/**
 *  用户名称颜色值
 */
-(UIColor *)personNameKeyColor {
    return [self getColorByHex:@"c10008"];
}

/**
 *  搜索输入框placeholder颜色值
 */
-(UIColor*)searchPlaceHolderColor {
    return [self getColorByHex:@"8a8a8a"];
}
/**
 *  追溯字体颜色
 */
-(UIColor*)traceLabelColor {
    return [self getColorByHex:@"7bae69"];
}

- (UIColor *)actionCountNumberColor {
    return RGBCOLOR(205, 0, 0);
}

-(UIColor*)timeDetailLineColor {
    return [self getColorByHex:@"e0e0e0"];
}

- (NSArray*)searchNotResultColors {
    NSArray *array = @[[self getColorByHex:@"41b7f0"],
                       [self getColorByHex:@"a282f3"],
                       [self getColorByHex:@"41ceb2"],
                       [self getColorByHex:@"82c4f3"],
                       [self getColorByHex:@"f4ac30"]];
    return array;
}

- (NSArray*)introColors {
    NSArray *array = @[[self getColorByHex:@"BE7935"],
                       [self getColorByHex:@"46C8E8"],
                       [self getColorByHex:@"8F83D6"],
                       [self getColorByHex:@"DE3E1E"]];
    return array;
}

- (NSArray*)circleColors {
    NSArray *array = @[[self getColorByHex:@"2d71b0"],
                       [self getColorByHex:@"715fb2"],
                       [self getColorByHex:@"2d9485"],
                       [self getColorByHex:@"49a5e6"],
                       [self getColorByHex:@"f4ac30"]];
    return array;
}


- (NSArray*)viewStateLoading {
    NSArray *array = @[@"HUDLoading1.png",
                       @"HUDLoading2.png",
                       @"HUDLoading3.png",
                       @"HUDLoading4.png",
                       @"HUDLoading5.png",
                       @"HUDLoading6.png",
                       @"HUDLoading7.png"];
    return array;
}

- (UIColor*)recommendLogoBgColor {
    return [self getColorByHex:@"f79829"];
}

- (UIColor *)searchTabColor {
    return [self getColorByHex:@"999999"];
}
- (UIColor *)searchTabBgColor {
    return RGBCOLOR(232, 233, 232);
}
/////////////////////////////////////////////////记录时光////////////////////////////////////////////
- (UIColor *)sendButtonColor {
    return [self getColorByHex:@"7c7c7c"];
}
- (UIColor*)circleSendButtonColor {
    return RGBCOLOR(255, 255, 255);
}
- (UIColor *)lightLineColor {
    return [self getColorByHex:@"e1e1e1"];
}
- (UIColor *)boldLineColor {
    return [self getColorByHex:@"c8c8c8"];
}
- (UIColor *)sectionHeaderTextColor {
    return [self getColorByHex:@"a8a8a8"];
}
- (UIColor *)sectionBgColor {
    return [self getColorByHex:@"f8f8f8"];
}
- (UIColor *)searchBgColor {
    return [self getColorByHex:@"EBECEE"];
}
- (UIColor *)searchLineColor {
    return [self getColorByHex:@"d7d7d7"];
}
- (UIColor *)slectedBgColor {
    return [self getColorByHex:@"dcdcdc"];
}
- (UIColor *)postTimeProgressColor {
    return [self getColorByHex:@"ff761b"];
}
////////////////////////////////////////////////记录时光/////////////////////////////////////////////

////////////////////////////////////////////////收藏列表/////////////////////////////////////////////
- (UIColor *)collectionAuthorColor {
    return [self getColorByHex:@"666666"];
}
- (UIColor *)collectionDateColor {
    return [self getColorByHex:@"999999"];
}
- (UIColor *)podDownloadProgressColor {
    return [self getColorByHex:@"7cb42b" alpha:.8];
}
- (UIColor *)podDownloadBgColor {
    return [self getColorByHex:@"7cb42b" alpha:.3];
}
////////////////////////////////////////////////收藏列表/////////////////////////////////////////////



- (UIColor *)printerTabBgColor {
    return RGBACOLOR(204, 204, 240, .9);
}

- (UIColor*)numLogoBackgroundColor {
    return [self getColorByHex:@"ff382d"];
}


- (UIColor *)librarySelectedBgColor {
    return [self getColorByHex:@"b1b1b1"];
}

- (UIColor *)librarySelectedHBgColor {
    return [self getColorByHex:@"9a9a9a"];
}

- (UIColor*)sponsorTextColor {
    return [self getColorByHex:@"e0e0e0"];
}

/**
 *  选择时光页面背景图片
 */
- (UIColor*)selectTimeBgColor {
    return [self getColorByHex:@"025f88"];
}

/**
 *  微信书
 */
- (UIColor*)bottomBackgroundColor {
    return [self getColorByHex:@"502218"];
}

- (UIColor*)waitCheckColor {
    return [self getColorByHex:@"6E5642"];
}

- (NSArray*)timeBgImageArray {
    NSArray *array = @[
                       [UIImage imageNamed:@"HomeTimeBgImage1.png"],
                       [UIImage imageNamed:@"HomeTimeBgImage2.png"],
                       [UIImage imageNamed:@"HomeTimeBgImage3.png"]
                       ];
    return array;
}

/**
 *  首页内容字体颜色
 */
-(UIColor *)homeContentTextColor {
    return [self getColorByHex:@"F1F1F1" alpha:.9f];
}

- (UIColor*)customLightBlue {
    return RGBCOLOR(46, 128, 171);
}

- (UIColor*)preferentialFreshColor {
    return RGBCOLOR(252, 152, 11);
}

- (UIColor*)preferentialReduceColor {
    return RGBCOLOR(246, 83, 9);
}

- (UIColor*)refreshBgColor {
    return [self getColorByHex:@"#393a4c"];
}


- (NSArray*)refreshBallArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i <= 4; i++) {
        NSString *string = [NSString stringWithFormat:@"RefreshBall%@.png",@(i)];
        [array addObject:string];
    }
    return array;
}


@end
