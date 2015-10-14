//
//  ListHeaderView.m
//  PDMS
//
//  Created by Melvin on 7/22/14.
//  Copyright (c) 2014 Melvin. All rights reserved.
//

#import "ListHeaderView.h"


@implementation ListHeaderView

+ (ListHeaderView *)headerView
{
    ListHeaderView *view = [[ListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), 0)];
    return view;
}



+ (ListHeaderView *)headerViewWithHeight:(CGFloat)height {
    ListHeaderView *view = [[ListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), height)];
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
