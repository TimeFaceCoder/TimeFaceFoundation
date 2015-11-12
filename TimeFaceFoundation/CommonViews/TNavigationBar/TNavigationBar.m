//
//  TNavigationBar.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TNavigationBar.h"
#import "TFDefaultStyle.h"

@interface TNavigationBar ()

@property (nonatomic, strong) UIImageView   *colorOverly;

@end

@implementation TNavigationBar

static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (void)setBarBgColor:(UIColor *)color {
    
    Class clazz=NSClassFromString(@"_UINavigationBarBackground");
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:clazz]) {
            view.hidden=YES;
            break;
        }
    }
    
    [self insertSubview:self.colorOverly atIndex:0];
    
    
    UIGraphicsBeginImageContext(CGSizeMake(2, 2));
    [color set];
    UIRectFill(CGRectMake(0, 0, 2, 2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _colorOverly.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    _colorOverly.alpha = .9;
}

- (UIImageView *)colorOverly {
    if (!_colorOverly) {
        if (!_colorOverly) {
            _colorOverly=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tfWidth, self.tfHeight+kSpaceToCoverStatusBars)];
            _colorOverly.frame = CGRectMake(0, -kSpaceToCoverStatusBars, self.tfWidth, 64);
            _colorOverly.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        }
    }
    return _colorOverly;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CALayer *border = [CALayer layer];
//    border.borderColor = TFSTYLEVAR(navBarTitleColor).CGColor;
//    border.borderWidth = .5;
//    border.frame = CGRectMake(0, self.layer.bounds.size.height, self.layer.bounds.size.width, .5);
//    [self.layer addSublayer:border];
}

@end

