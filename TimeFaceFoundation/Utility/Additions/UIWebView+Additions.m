//
//  UIWebView+Additions.m
//  MPBFramework
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIWebView+Additions.h"
#import "UIView+Additions.h"

@implementation UIWebView (Additions)
- (CGRect)frameOfElement:(NSString*)query {
    NSString* result = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"\
                                                                     var target = %@; \
                                                                     var x = 0, y = 0; \
                                                                     for (var n = target; n && n.nodeType == 1; n = n.offsetParent) {  \
                                                                     x += n.offsetLeft; \
                                                                     y += n.offsetTop; \
                                                                     } \
                                                                     x + ',' + y + ',' + target.offsetWidth + ',' + target.offsetHeight; \
                                                                     ", query]];
    
    NSArray* points = [result componentsSeparatedByString:@","];
    CGFloat x = [[points objectAtIndex:0] floatValue];
    CGFloat y = [[points objectAtIndex:1] floatValue];
    CGFloat width = [[points objectAtIndex:2] floatValue];
    CGFloat height = [[points objectAtIndex:3] floatValue];
    
    return CGRectMake(x, y, width, height);
}
@end
