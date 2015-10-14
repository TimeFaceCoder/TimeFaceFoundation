//
//  NSString+Additions.m
//  MPBFramework
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

- (CGSize)re_sizeWithFont:(UIFont *)font
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithAttributes:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithAttributes:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        [invocation setArgument:&attributes atIndex:2];
        [invocation invoke];
        [invocation getReturnValue:&size];
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:)];
        [invocation setArgument:&font atIndex:2];
        [invocation invoke];
        [invocation getReturnValue:&size];
    }
    return size;
}

- (CGSize)re_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}

+ (NSString*)stringToSha1:(NSString*)str {
    const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [out description];
    
    NSCharacterSet *doNotWants = [NSCharacterSet characterSetWithCharactersInString:@"<> "];
    hash = [[hash componentsSeparatedByCharactersInSet:doNotWants] componentsJoinedByString:@""];
    
    return hash;
}

- (NSNumber*)stringToNSNumber {
    NSNumberFormatter* tmpFormatter = [[NSNumberFormatter alloc] init];
    [tmpFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* theNumber = [tmpFormatter numberFromString:self];
    return theNumber;
}

- (BOOL)isEmpty {
    if ([self length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

- (BOOL)stringContainsSubString:(NSString *)subString {
    NSRange aRange = [self rangeOfString:subString];
    if (aRange.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (NSString*)stringByReplacingStringsFromDictionary:(NSDictionary*)dict {
    NSMutableString* string = [self mutableCopy];
    for (NSString* target in dict) {
        [string replaceOccurrencesOfString:target withString:[dict objectForKey:target] options:0 range:NSMakeRange(0, [string length])];
    }
    return string;
}

- (NSString *)stringByTrimingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (CGSize) sizeForFont:(UIFont *)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:font};
        return ([self sizeWithAttributes:attribs]);
    }
    return ([self sizeWithAttributes:@{NSFontAttributeName:font}]);
}

- (CGSize) sizeForFont:(UIFont*)font
     constrainedToSize:(CGSize)constraint
         lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size;
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        
        CGSize boundingBox = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    }
    else
    {
//        size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode];
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = lineBreakMode;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        size = [self boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        
    }
    
    return size;
}

- (NSString *)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}


@end
