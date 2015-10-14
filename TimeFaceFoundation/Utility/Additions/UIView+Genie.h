//
//  UIView+Genie.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BCRectEdge) {
    BCRectEdgeTop    = 0,
    BCRectEdgeLeft   = 1,
    BCRectEdgeBottom = 2,
    BCRectEdgeRight  = 3
};


@interface UIView (Genie)

- (void)genieInTransitionWithDuration:(NSTimeInterval)duration
                      destinationRect:(CGRect)destRect
                      destinationEdge:(BCRectEdge)destEdge
                                 scal:(CGFloat)scal
                           completion:(void (^)())completion;


- (void)genieOutTransitionWithDuration:(NSTimeInterval)duration
                             startRect:(CGRect)startRect
                             startEdge:(BCRectEdge)startEdge
                            completion:(void (^)())completion;

@end
