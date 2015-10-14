//
//  TFTableRefreshView.h
//  TimeFaceV2
//
//  Created by Melvin on 8/11/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTableRefreshView : UIView

- (void)startPullWithProgress:(CGFloat)progress;
- (void)startLoading;
- (void)endPullAnimating;

@end
