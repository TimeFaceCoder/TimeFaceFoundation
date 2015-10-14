//
//  UIImageView+TFAdditions.m
//  TimeFace
//
//  Created by boxwu on 14/11/18.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import "UIImageView+TFAdditions.h"
#import "TFDefaultStyle.h"

#define kPadding            12.f

@implementation UIImageView (TFAdditions)

-(void) addSummaryWithLabel:(UILabel *)label point:(CGPoint)point {
    [self addSubview:label];
    CGRect frame = label.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    label.frame = frame;
}

-(void) addSummary:(NSString *)summary pic:(UIImage *)pic {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGBACOLOR(0, 0, 0, .4f);
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = TFSTYLEVAR(font12);
    
    [button setTitle:summary forState:UIControlStateNormal];
    if (pic) {
        [button setImage:pic forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 8.0, 0.0, 0.0)];
    }
    
    [button sizeToFit];
    button.tfHeight = 26.f;
    button.tfWidth += 12;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.tfHeight / 2;
    if (pic) {
        button.layer.cornerRadius = button.tfHeight / 3;
        button.tfWidth += 12;
    }
    button.tfRight =  self.tfWidth - kPadding;
    button.tfBottom = self.tfHeight - kPadding;
    
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    button.userInteractionEnabled = NO;
    
    [self addSubview:button];
}

@end
