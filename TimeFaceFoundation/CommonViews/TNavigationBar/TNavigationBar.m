//
//  TNavigationBar.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TNavigationBar.h"
#import "TFDefaultStyle.h"


#define kDevice_Is_iPhoneX (([UIApplication sharedApplication].statusBarFrame.size.height > 20) ? YES: NO)

//#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface TNavigationBar ()

@end

@implementation TNavigationBar

static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (void)setBarBgColor:(UIColor *)color {
    
    Class clazz=NSClassFromString(@"_UINavigationBarBackground");
    if (!clazz) {
        clazz = NSClassFromString(@"_UIBarBackground");
    }
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:clazz]) {
            view.hidden=YES;
            //适配iOS11
            for (UIView *_view in view.subviews)
            {
                _view.hidden = YES;
            }
            break;
        }
    }
    
    [self insertSubview:self.colorOverly atIndex:0];
    
    UIGraphicsBeginImageContext(CGSizeMake(2, 2));
    [color set];
    UIRectFill(CGRectMake(0, 0, 2, 2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.colorOverly.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    self.colorOverly.alpha = 0.9;
}

- (UIImageView *)colorOverly {
    if (!_colorOverly) {
        
        if(kDevice_Is_iPhoneX)
        {
            _colorOverly=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tfWidth, self.tfHeight + 44)];
            _colorOverly.frame = CGRectMake(0, -44, self.tfWidth, 88);
        }
        else
        {
            _colorOverly=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tfWidth, self.tfHeight+kSpaceToCoverStatusBars)];
            _colorOverly.frame = CGRectMake(0, -kSpaceToCoverStatusBars, self.tfWidth, 64);
        }
        _colorOverly.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _colorOverly;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sendSubviewToBack:self.colorOverly];
    Class clazz=NSClassFromString(@"_UINavigationBarBackground");
    if (!clazz) {
        clazz = NSClassFromString(@"_UIBarBackground");
    }

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:clazz]) {
            view.hidden=YES;
            //适配iOS11
            for (UIView *_view in view.subviews)
            {
                _view.hidden = YES;
            }
            break;
        }
    }
//    CALayer *border = [CALayer layer];
//    border.borderColor = TFSTYLEVAR(navBarTitleColor).CGColor;
//    border.borderWidth = .5;
//    border.frame = CGRectMake(0, self.layer.bounds.size.height, self.layer.bounds.size.width, .5);
//    [self.layer addSublayer:border];
}

- (void)setBgImageFrame:(UIColor *)color
{
    if(self.colorOverly)
    {
        [self.colorOverly removeFromSuperview];
        self.colorOverly = nil;
    }
    
    [self insertSubview:self.colorOverly atIndex:0];
    
    UIGraphicsBeginImageContext(CGSizeMake(2, 2));
    [color set];
    UIRectFill(CGRectMake(0, 0, 2, 2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.colorOverly.image = [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    self.colorOverly.alpha = 0.9;
    
    [self sendSubviewToBack:self.colorOverly];
    
}

- (void)resetBgImageFrame
{
    if(kDevice_Is_iPhoneX)
    {
        _colorOverly.frame = CGRectMake(0, -44, self.tfWidth, 88);
    }
    else
    {
        _colorOverly.frame = CGRectMake(0, -kSpaceToCoverStatusBars, self.tfWidth, 64);
    }
}

//我的作品相关测试
- (void)resetUserProductBgImageFrame
{
    if(kDevice_Is_iPhoneX)
    {
        _colorOverly.frame = CGRectMake(0, -44, self.tfWidth, 88);
    }
    else
    {
        _colorOverly.frame = CGRectMake(0, -kSpaceToCoverStatusBars, self.tfWidth, 64);
    }
}

@end

