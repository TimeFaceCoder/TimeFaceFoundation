//
//  LibraryCollectionHeaderView.m
//  TimeFaceV2
//
//  Created by 吴寿 on 15/6/1.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "LibraryCollectionHeaderView.h"
#import "TFDefaultStyle.h"
#import "Utility.h"

const static CGFloat kPadding           = 10.f;

@implementation LibraryCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialization code
        [self addSubview:self.lblTitle];
    }
    return self;
}

-(void) refreshTitle:(NSString *)title {
    _lblTitle.text = title;
    [_lblTitle sizeToFit];
    
    [self layoutIfNeeded];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    _lblTitle.tfLeft = kPadding;
    _lblTitle.tfWidth = self.tfWidth - 2 * kPadding;
    _lblTitle.tfCenterY = self.tfHeight / 2;
}

-(UILabel *) lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tfWidth, 20)];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = TFSTYLEVAR(defaultBlackColor);
        _lblTitle.font = TFSTYLEVAR(font12);
        
        _lblTitle.text = @"";
    }
    return _lblTitle;
}

@end
