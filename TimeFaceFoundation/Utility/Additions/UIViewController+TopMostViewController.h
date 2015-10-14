//
//  UIViewController+TopMostViewController.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController;

@end

@interface UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController;

@end
