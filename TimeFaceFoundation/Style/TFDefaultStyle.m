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



- (UIColor *)alertCancelColor {
    return [self getColorByHex:@"b5b5b5"];
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


- (NSArray*)searchNotResultColors {
    NSArray *array = @[[self getColorByHex:@"41b7f0"],
                       [self getColorByHex:@"a282f3"],
                       [self getColorByHex:@"41ceb2"],
                       [self getColorByHex:@"82c4f3"],
                       [self getColorByHex:@"f4ac30"]];
    return array;
}




@end
