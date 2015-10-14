//
//  UITableView+Frames.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UITableView+Frames.h"
#import "RETableViewCell.h"


@implementation UITableView (Frames)

- (NSDictionary *)framesForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RETableViewCell *cell = (RETableViewCell*)[self cellForRowAtIndexPath:indexPath];
    CGRect cellFrameInTableView = [self rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInWindow = [self convertRect:cellFrameInTableView toView:[UIApplication sharedApplication].keyWindow];
    
    NSMutableDictionary *frames = [NSMutableDictionary dictionary];
    
    [frames setObject:[NSValue valueWithCGRect:cellFrameInWindow] forKey:@"cell"];
    
    
    
    [frames setObject:[NSValue valueWithCGRect:CGRectOffset(cell.imageView.frame, cellFrameInWindow.origin.x, cellFrameInWindow.origin.y)] forKey:@"imageView"];
    
    
    [frames setObject:[NSValue valueWithCGRect:CGRectOffset(cell.textLabel.frame, cellFrameInWindow.origin.x, cellFrameInWindow.origin.y)] forKey:@"textLabel"];
    
    
    
    return [NSDictionary dictionaryWithDictionary:frames];
    
}


@end
