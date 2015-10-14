//
//  UIViewController+ScrollFullScreen.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScrollFullScreen)

- (void)showNavigationBar:(BOOL)animated;
- (void)hideNavigationBar:(BOOL)animated;
- (void)moveNavigationBar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated;

- (void)showToolbar:(BOOL)animated;
- (void)hideToolbar:(BOOL)animated;
- (void)moveToolbar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setToolbarOriginY:(CGFloat)y animated:(BOOL)animated;

- (void)showTabBar:(BOOL)animated;
- (void)hideTabBar:(BOOL)animated;
- (void)moveTabBar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setTabBarOriginY:(CGFloat)y animated:(BOOL)animated;


@end
