//
//  TFTapDetectingView.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFTapDetectingViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;

@end

@interface TFTapDetectingView : UIView

@property (nonatomic, weak) id <TFTapDetectingViewDelegate> tapDelegate;


@end
