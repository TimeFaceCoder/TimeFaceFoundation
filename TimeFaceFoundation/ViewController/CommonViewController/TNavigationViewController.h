//
//  TNavigationViewController.h
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFDirectionalPanGestureRecognizer.h"

typedef NS_ENUM(NSUInteger, TFNavigationViewControllerNavigationBarVisibility) {
    TFNavigationViewControllerNavigationBarVisibilityUndefined = 0, // Initial value, don't set this
    TFNavigationViewControllerNavigationBarVisibilitySystem = 1, // Use System navigation bar
    TFNavigationViewControllerNavigationBarVisibilityHidden = 2, // Use custom navigation bar and hide it
    TFNavigationViewControllerNavigationBarVisibilityVisible = 3 // Use custom navigation bar and show it
};

@protocol TFNavigationViewControllerDelegate <NSObject>

/**
 You should give back the correct enum value if the controller asks you
 */
- (TFNavigationViewControllerNavigationBarVisibility)preferredNavigationBarVisibility;

@end

@interface TNavigationViewController : UINavigationController

@property (nonatomic ,assign) BOOL canDragBack;

- (void)setNeedsNavigationBarVisibilityUpdateAnimated:(BOOL)animated;

@end
