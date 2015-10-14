//
//  ContactsSectionView.m
//  TimeFaceV2
//
//  Created by Melvin on 12/8/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "ContactsSectionView.h"
#import "Utility.h"
#import "TFDefaultStyle.h"

@implementation ContactsSectionView

+ (ContactsSectionView *)headerView:(NSString *)title
{
    ContactsSectionView *view = [[ContactsSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), 20) title:title];
    return view;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tfWidth, .5)];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lineView.backgroundColor = TFSTYLEVAR(searchLineColor);
        [self addSubview:lineView];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = TFSTYLEVAR(sectionBgColor);
        
//        self.backgroundColor = [UIColor blueColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = TFSTYLEVAR(font12);
        label.textColor = TFSTYLEVAR(sectionHeaderTextColor);
        [label sizeToFit];
        label.tfLeft = VIEW_LEFT_SPACE;
        label.tfTop = (self.tfHeight - label.tfHeight) / 2;
        
        [self addSubview:label];
    }
    return self;
}

@end
