//
//  MotionOrientation.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TNMP. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

extern NSString* const MotionOrientationChangedNotification;
extern NSString* const MotionOrientationInterfaceOrientationChangedNotification;

extern NSString* const kMotionOrientationKey;

@interface MotionOrientation : NSObject

@property (readonly) UIInterfaceOrientation interfaceOrientation;
@property (readonly) UIDeviceOrientation deviceOrientation;
@property (readonly) CGAffineTransform affineTransform;

@property (assign) BOOL showDebugLog;

- (void)startUpdates;
- (void)stopUpdates;

+ (void)initialize;
+ (MotionOrientation *)sharedInstance;

@end
