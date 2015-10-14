//
//  TFDirectionalPanGestureRecognizer.h
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TFPanDirection) {
    TFPanDirectionRight,
    TFPanDirectionDown,
    TFPanDirectionLeft,
    TFPanDirectionUp
};

@interface TFDirectionalPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic) TFPanDirection direction;

@end
