//
//  TFStyle.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFStyle.h"

static TFStyle* gStyleSheet = nil;

@interface TFStyle()



@end

@implementation TFStyle

- (id)init {
	self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object: nil];
        
    }
    
    return self;
}


#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TFStyle *)globalStyleSheet {
    if (!gStyleSheet) {
        gStyleSheet = [[TFStyle alloc] init];
    }
    return gStyleSheet;
}

+ (void)setGlobalStyleSheet:(TFStyle *)styleSheet {
    gStyleSheet = styleSheet;
}


- (void)didReceiveMemoryWarning:(void*)object {
    [self freeMemory];
}

- (UIColor *)getColorByHex:(NSString *)hexColor {
    return [self getColorByHex:hexColor alpha:1.0f];
}

- (UIColor *)getColorByHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    //剔除#
    hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}

- (void)freeMemory {
    
}

@end
