//
//  UIImageView+TFAdditions.h
//  TimeFace
//
//  Created by boxwu on 14/11/18.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TFAdditions)

-(void) addSummaryWithLabel:(UILabel *)label point:(CGPoint)point;
-(void) addSummary:(NSString *)summary pic:(UIImage *)pic;

@end
