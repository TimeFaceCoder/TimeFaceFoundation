//
//  TFDirectionalPanGestureRecognizer.m
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFDirectionalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TFDirectionalPanGestureRecognizer()
@property (nonatomic) BOOL dragging;
@end

@implementation TFDirectionalPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    CGPoint velocity = [self velocityInView:self.view];
    
    // check direction only on the first move
    if (!self.dragging) {
        NSDictionary *velocities = @{
                                     @(TFPanDirectionRight) : @(velocity.x),
                                     @(TFPanDirectionDown) : @(velocity.y),
                                     @(TFPanDirectionLeft) : @(-velocity.x),
                                     @(TFPanDirectionUp) : @(-velocity.y)
                                     };
        NSArray *keysSorted = [velocities keysSortedByValueUsingSelector:@selector(compare:)];
        
        // Fails the gesture if the highest velocity isn't in the same direction as `direction` property.
        if ([[keysSorted lastObject] integerValue] != self.direction) {
            self.state = UIGestureRecognizerStateFailed;
        }
        
        self.dragging = YES;
    }
}

- (void)reset
{
    [super reset];
    
    self.dragging = NO;
}

@end
