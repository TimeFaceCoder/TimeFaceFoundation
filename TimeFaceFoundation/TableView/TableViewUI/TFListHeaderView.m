//
//  ListHeaderView.m
//  PDMS
//
//  Created by Melvin on 7/22/14.
//  Copyright (c) 2014 Melvin. All rights reserved.
//

#import "TFListHeaderView.h"



@implementation TFListHeaderView

+ (TFListHeaderView *)headerView
{
    TFListHeaderView *view = [[TFListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), 0)];
    return view;
}



+ (TFListHeaderView *)headerViewWithHeight:(CGFloat)height {
    TFListHeaderView *view = [[TFListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), height)];
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

@end
