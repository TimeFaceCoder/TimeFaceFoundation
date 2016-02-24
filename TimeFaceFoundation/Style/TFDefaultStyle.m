//
//  TFDefaultStyle.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFDefaultStyle.h"
#import "TimeFaceFoundationConst.h"

@implementation TFDefaultStyle

/////////////////////////////////////////////全局字体格式定义//////////////////////////////////////////

- (UIFont *)font10 {
    return [UIFont systemFontOfSize:10];
}
- (UIFont *)font10B {
    return [UIFont boldSystemFontOfSize:10];
}

- (UIFont *)font12 {
    return [UIFont systemFontOfSize:12];
}
- (UIFont *)font12B {
    return [UIFont boldSystemFontOfSize:12];
}

- (UIFont *)font14 {
    return [UIFont systemFontOfSize:14];
}

- (UIFont *)font14B {
    return [UIFont boldSystemFontOfSize:14];
}

- (UIFont *)font16 {
    return [UIFont systemFontOfSize:16];
}

- (UIFont *)font16B {
    return [UIFont boldSystemFontOfSize:16];
}

- (UIFont *)font18 {
    return [UIFont systemFontOfSize:18];
}

- (UIFont *)font18B {
    return [UIFont boldSystemFontOfSize:18];
}

/////////////////////////////////////////////全局颜色定义//////////////////////////////////////////

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


///////////////////////////////////////////AlertView样式定义/////////////////////////////////////////
- (UIColor *)alertCancelColor {
    return [self getColorByHex:@"b5b5b5"];
}
- (UIColor *)alertCancelHColor {
    return [self getColorByHex:@"a9a9a9"];
}
- (UIColor *)alertOKColor {
    return [self getColorByHex:@"069bf2"];
}
- (UIColor *)alertOKHColor {
    return [self getColorByHex:@"058ccd"];
}
- (UIColor *)alertLineColor {
    return [self getColorByHex:@"9b9b9b"];
}
- (UIColor *)alertTitleColor {
    return [self getColorByHex:@"069bf2"];
}
- (UIColor *)alertContentColor {
    return [self getColorByHex:@"333333"];
}






/////////////////////////////////////////////HUD提示-START//////////////////////////////////////////
- (UIFont *)loadingTextFont {
    return [UIFont systemFontOfSize:16];
}
- (UIColor *)loadingTextColor {
    return [self getColorByHex:@"7c7c7c"];
}
- (UIColor *)loadingLineColor {
    return [self getColorByHex:@"dfdfdf"];
}
/////////////////////////////////////////////HUD提示-END////////////////////////////////////////////




- (UIColor *)downloadProgressColor {
    return [self getColorByHex:@"7cb42b" alpha:.8];
}
- (UIColor *)downloadBgColor {
    return [self getColorByHex:@"7cb42b" alpha:.3];
}


@end
