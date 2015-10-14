//
//  TFTapDetectingImageView.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFTapDetectingImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end

@interface TFTapDetectingImageView : UIImageView

@property (nonatomic, weak) id <TFTapDetectingImageViewDelegate> tapDelegate;

@end


