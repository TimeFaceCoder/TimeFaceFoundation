//
//  ViewTransitionAnimator.m
//  TimeFaceV2
//
//  Created by Melvin on 11/14/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "ViewTransitionAnimator.h"

@implementation ViewTransitionAnimator


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    
    CGRect toFrame = toView.frame;
    CGRect fromFrame = fromView.frame;
//    BOOL toNavigationBarHidden = [toViewController hasNavigationBar];
//    BOOL fromNavigationBarHidden = [fromViewController hasNavigationBar];
    
    BOOL toNavigationBarHidden = NO;
    BOOL fromNavigationBarHidden = NO;
    
    if (toNavigationBarHidden != fromNavigationBarHidden) {
        if (toNavigationBarHidden) {
            toFrame.origin.y += 64;
            toFrame.size.height -= 64;
            toView.frame = toFrame;
        } else {
            toFrame.origin.y -= 64;
            toFrame.size.height += 64;
            toView.frame = toFrame;
        }
    }
    toFrame.origin.x = -CGRectGetWidth(TTScreenBounds())*1/3;
    toView.frame = toFrame;
    
    [[transitionContext containerView] addSubview:toView];
    [[transitionContext containerView] addSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, toFrame.origin.y, toFrame.size.width, toFrame.size.height);
        fromView.frame = CGRectMake(CGRectGetWidth(TTScreenBounds()), fromFrame.origin.y, fromFrame.size.width, fromFrame.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}



@end
