//
//  TimePostButtonView.m
//  TimeFaceV2
//
//  Created by Melvin on 4/1/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TimePostButtonView.h"
#import "TFDefaultStyle.h"
#import <pop/POP.h>

const static CGFloat kMoveLength = 8;

@interface TimePostButtonView() {
}

@property (nonatomic ,strong) UIImageView *penView;
@property (nonatomic ,strong) UIView      *lineView;

@end

@implementation TimePostButtonView {
    CGFloat _viewStartX;
    CGRect  _penFrame;
    CGRect  _lineFrame;
    BOOL    _stop;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _viewStartX = 12.0f;
        [self commonInitialization];
    }
    return self;
}


- (void)commonInitialization {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = (self.tfWidth) / 2;
    self.backgroundColor = TFSTYLEVAR(defaultBlueColor);
    _penView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PostTimePen"]];
    _penView.tfLeft = _viewStartX;
    _penView.tfTop = (self.tfHeight - _penView.tfHeight) / 2;
    [self addSubview:_penView];
    _penFrame = _penView.frame;
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor whiteColor];
    _lineView.tfWidth = 2;
    _lineView.tfHeight = 2;
    _lineView.tfLeft = _viewStartX;
    _lineView.tfTop = _penView.tfBottom + 4;
    [self addSubview:_lineView];
    _lineFrame = _lineView.frame;
    
    [self startAnimation];
    
}


- (void)startAnimation {
    _stop = NO;
    [self viewAnimate];

}
- (void)stopAnimation {
    [_penView pop_removeAllAnimations];
    [_lineView pop_removeAllAnimations];
    
    POPBasicAnimation *lineAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    lineAnimation.toValue = [NSValue valueWithCGRect:_lineFrame];
    
    POPBasicAnimation *penAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    penAnimation.toValue = [NSValue valueWithCGRect:_penFrame];
    
    [_penView pop_addAnimation:penAnimation forKey:@"penAnimation"];
    [_lineView pop_addAnimation:lineAnimation forKey:@"lineAnimation"];
    
    _stop = YES;
}

- (void)viewAnimate {
    if (_stop)
        return;
    CGRect penFrame = _penView.frame;
    if (penFrame.origin.x >= (_viewStartX +kMoveLength)) {
        penFrame.origin.x -= kMoveLength;
    }
    else {
        penFrame.origin.x += kMoveLength;
    }
    CGRect lineFrame = _lineView.frame;
    if (lineFrame.size.width > 2) {
        lineFrame.size.width -= kMoveLength*2;
    }
    else {
        lineFrame.size.width += kMoveLength*2;
    }
    
    
    POPBasicAnimation *lineAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    lineAnimation.toValue = [NSValue valueWithCGRect:lineFrame];
    
    POPBasicAnimation *penAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    penAnimation.toValue = [NSValue valueWithCGRect:penFrame];
    [penAnimation setCompletionBlock:^(POPAnimation *Animation, BOOL finished) {
        if (finished) {
            //动画完成
            [self performSelector:@selector(viewAnimate) withObject:nil afterDelay:.35];
        }
    }];
    
    [_penView pop_addAnimation:penAnimation forKey:@"penAnimation"];
    [_lineView pop_addAnimation:lineAnimation forKey:@"lineAnimation"];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
