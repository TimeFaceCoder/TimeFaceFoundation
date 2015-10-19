//
//  NSString+Additions.h
//  MPBFramework
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Additions)

- (CGSize)re_sizeWithFont:(UIFont *)font;
- (CGSize)re_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
+ (NSString *)stringToSha1:(NSString *)str;
- (NSNumber*)stringToNSNumber;
- (BOOL)isEmpty;
- (BOOL)stringContainsSubString:(NSString *)subString;
- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict;
- (NSString *)stringByTrimingWhitespace;
- (CGSize) sizeForFont:(UIFont *)font;
- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (NSString *)trimWhitespace;
- (NSUInteger)numberOfLines;

@end
