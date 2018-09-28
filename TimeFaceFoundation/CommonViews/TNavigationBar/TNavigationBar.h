//
//  TNavigationBar.h
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAdditions.h"

@interface TNavigationBar : UINavigationBar

- (void)setBarBgColor:(UIColor *)color;

//适配IOS11
- (void)setBgImageFrame:(UIColor *)color;

- (void)resetBgImageFrame;

- (void)resetUserProductBgImageFrame;

@property (nonatomic, strong) UIImageView   *colorOverly;

@end
