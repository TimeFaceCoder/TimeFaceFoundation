//
//  UIViewController+TopMostViewController.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "UIViewController+TopMostViewController.h"

@implementation UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil)
    {
        return self;
    }
    else if ([self.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    return [presentedViewController topMostViewController];
}

@end


@implementation UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController
{
    return [self.keyWindow.rootViewController topMostViewController];
}

@end