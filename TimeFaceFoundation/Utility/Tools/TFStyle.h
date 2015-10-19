//
//  TFStyle.h
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFStyle : NSObject


+ (TFStyle*)globalStyleSheet;

+ (void)setGlobalStyleSheet:(TFStyle*)styleSheet;

- (UIColor *)getColorByHex:(NSString *)hexColor;
- (UIColor *)getColorByHex:(NSString *)hexColor alpha:(CGFloat)alpha;

@end
