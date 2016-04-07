//
//  GradientProgressView.h
//  JDStatusBarNotificationExample
//
//  Created by Melvin on 2/5/16.
//  Copyright © 2016 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientProgressView : UIView

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
@property (nonatomic, readwrite, assign) CGFloat progress;

- (void)startAnimating;
- (void)stopAnimating;

@end
