//
//  TFTableRefreshView2.m
//  TimeFaceV2
//
//  Created by Melvin on 8/12/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFTableRefreshView2.h"
#import "TFDefaultStyle.h"

@interface TFTableRefreshView2() {
    
}

@property (nonatomic ,strong) UIColor             *fillColor;
@property (nonatomic ,strong) UIImageView         *imageView;
@property (nonatomic ,strong) CAShapeLayer        *shapeLayer;
@property (nonatomic ,strong) UIDynamicAnimator   *animator;
@property (nonatomic ,strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic ,strong) UISnapBehavior      *snapBehavior;

@end

@implementation TFTableRefreshView2 {
    CGRect  _frame;
    CGFloat _angle;
    BOOL    _isFirstTime;
}

- (id)initWithFrame:(CGRect)frame{
    self.userFrame = frame;
    _frame = frame;
    _frame.size.height += CGRectGetHeight(TTScreenBounds());
    self = [super initWithFrame:_frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.isLoading = NO;
        _isFirstTime   = NO;
        _fillColor     = [UIColor blackColor];
        
        //贝塞尔曲线的控制点
        self.controlPoint = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.userFrame) / 2 - 5, CGRectGetHeight(self.userFrame) - 5, 10, 10)];
        self.controlPoint.backgroundColor = [UIColor clearColor];
        [self addSubview:self.controlPoint];
        
        //
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.userFrame) / 3 - 20, CGRectGetHeight(self.userFrame) - 100, 40, 40)];
        _imageView.layer.cornerRadius = _imageView.tfWidth / 2;
        _imageView.image = [UIImage imageNamed:@"PullToRefreshStart.png"];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        //UIDynamic
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
        UIGravityBehavior *grv = [[UIGravityBehavior alloc]initWithItems:@[_imageView]];
        grv.magnitude = 2;
        [_animator addBehavior:grv];
        _collisionBehavior =  [[UICollisionBehavior alloc]initWithItems:@[_imageView]];
        
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[_imageView]];
        item.elasticity = 0;
        item.density = 1;
        
        _shapeLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:_shapeLayer below:_imageView.layer];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
//    if (self.isLoading == NO) {
//        [_collisionBehavior removeBoundaryWithIdentifier:@"arc"];
//    }else{
//        
//        if (!_isFirstTime) {
//            _isFirstTime = YES;
//            _snapBehavior = [[ UISnapBehavior alloc]initWithItem:_imageView snapToPoint:CGPointMake(self.userFrame.size.width / 2, self.userFrame.size.height - (130+64.5)/2)];
//            [_animator addBehavior:_snapBehavior];
//            [self startLoading];
//        }
//        
//    }
//    
//    self.controlPoint.center = (self.isLoading == NO)?(CGPointMake(self.userFrame.size.width / 2 , self.userFrame.size.height + self.controlPointOffset)) : (CGPointMake(self.userFrame.size.width / 2, self.userFrame.size.height + self.controlPointOffset));
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0,self.userFrame.size.height)];
//    [path addQuadCurveToPoint:CGPointMake(self.userFrame.size.width,self.userFrame.size.height) controlPoint:self.controlPoint.center];
//    [path addLineToPoint:CGPointMake(self.userFrame.size.width, 0)];
//    [path addLineToPoint:CGPointMake(0, 0)];
//    [path closePath];
//    
//    _shapeLayer.path = path.CGPath;
//    _shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
//    
//    
//    if(self.isLoading == NO){
//        [_collisionBehavior addBoundaryWithIdentifier:@"arc" forPath:path];
//        [_animator addBehavior:_collisionBehavior];
//    }
    
}

- (void)startLoading {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.9f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


@end
