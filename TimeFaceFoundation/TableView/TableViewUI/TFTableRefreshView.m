//
//  TFTableRefreshView.m
//  TimeFaceV2
//
//  Created by Melvin on 8/11/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFTableRefreshView.h"
#import <pop/POP.h>

@interface TFTableRefreshView()<UICollisionBehaviorDelegate> {
    
}

@property (nonatomic ,strong) UIImageView       *leftImageView;
@property (nonatomic ,strong) UIImageView       *rightImageView;
@property (nonatomic ,strong) UIDynamicAnimator *animator;

@end


@implementation TFTableRefreshView {
    CGFloat _middlePoint;
    CGFloat _distance;
    CGFloat _originalRightCenterX;
    BOOL _bump;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        
        _leftImageView.tfLeft = 0;
        _leftImageView.tfTop = (self.tfHeight - _leftImageView.tfHeight) / 2;
        
        _rightImageView.tfLeft = self.tfWidth - _rightImageView.tfWidth;
        _rightImageView.tfCenterY = _leftImageView.tfCenterY;
        
//        self.layer.borderWidth = 1;
        
        _middlePoint = self.tfWidth / 2;
        _distance = _middlePoint - _leftImageView.tfWidth;
        _originalRightCenterX = _rightImageView.tfCenterX + _rightImageView.tfWidth/2;
        
        //UIDynamic
//        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
//        UIGravityBehavior *grv = [[UIGravityBehavior alloc]initWithItems:@[_leftImageView,_rightImageView]];
//        grv.magnitude = 2;
//        [_animator addBehavior:grv];
//        _collisionBehavior =  [[UICollisionBehavior alloc]initWithItems:@[_leftImageView,_rightImageView]];
//        
//        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc]initWithItems:@[_leftImageView,_rightImageView]];
//        item.elasticity = 0;
//        item.density = 1;

        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[_leftImageView,_rightImageView]];
        [_animator addBehavior:gravityBehavior];
        
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_leftImageView,_rightImageView]];
        [collisionBehavior setTranslatesReferenceBoundsIntoBoundary:YES];
//        collisionBehavior.collisionMode = UICollisionBehaviorModeItems;
        collisionBehavior.collisionDelegate = self;
        [_animator addBehavior:collisionBehavior];
        
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_leftImageView,_rightImageView]];
        itemBehavior.elasticity = 0.6;
        itemBehavior.density = 1;
        [_animator addBehavior:itemBehavior];
        [collisionBehavior setCollisionDelegate:self];
    }
    return self;
}


#pragma mark - 
#pragma mark Views
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PullToRefreshStart.png"]];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PullToRefreshStart.png"]];
    }
    return _rightImageView;
}
#pragma mark - 
#pragma mark Actions


#pragma mark - 
#pragma mark Public
- (void)startPullWithProgress:(CGFloat)progress {
    if (_bump) {
        return;
    }
    CGFloat moveDistance = progress * _distance + _leftImageView.tfWidth / 2;
    [UIView animateWithDuration:.1 animations:^{
        _leftImageView.tfCenterX = moveDistance;
        _rightImageView.tfCenterX = _originalRightCenterX - moveDistance;
    } completion:^(BOOL finished) {
        
    }];
    if (progress == 1) {
        [UIView animateWithDuration:.1
                         animations:^
         {
             _leftImageView.image = [UIImage imageNamed:@"PullToRefreshLoading.png"];
             _rightImageView.image = [UIImage imageNamed:@"PullToRefreshLoading.png"];
             //倾斜
//             _leftImageView.transform = CGAffineTransformMakeRotation(-M_PI/4);
//             _rightImageView.transform = CGAffineTransformMakeRotation(M_PI/4);
         }
                         completion:^(BOOL finished)
         {
             _bump = YES;
             POPSpringAnimation *animationLeft = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
             animationLeft.toValue = @(_leftImageView.tfCenterX - _leftImageView.tfWidth);
             animationLeft.springSpeed = 4;
             animationLeft.springBounciness = 10;
             
             POPSpringAnimation *animationRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
             animationRight.toValue = @(_rightImageView.tfCenterX + _rightImageView.tfWidth);
             animationRight.springSpeed = 4;
             animationRight.springBounciness = 10;

             
             [_leftImageView.layer pop_addAnimation:animationLeft forKey:@"animationLeft"];
             [_rightImageView.layer pop_addAnimation:animationRight forKey:@"animationRight"];
             
         }];
    }
    else {
//        _bump = NO;
        [UIView animateWithDuration:.1 animations:^{
            _leftImageView.image      = [UIImage imageNamed:@"PullToRefreshStart.png"];
            _leftImageView.transform  = CGAffineTransformIdentity;
            [_leftImageView.layer removeAllAnimations];
            [_leftImageView.layer pop_removeAllAnimations];
            
            _rightImageView.image     = [UIImage imageNamed:@"PullToRefreshStart.png"];
            _rightImageView.transform = CGAffineTransformIdentity;
            [_rightImageView.layer removeAllAnimations];
            [_rightImageView.layer pop_removeAllAnimations];
        }];
    }
    
}

- (void)startLoading {
    TFLog(@"%s",__func__);
    [UIView animateWithDuration:.1
                     animations:^{
                         _leftImageView.image = [UIImage imageNamed:@"PullToRefreshLoading.png"];
                         _rightImageView.image = [UIImage imageNamed:@"PullToRefreshLoading.png"];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    //自旋动画
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation             = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue     = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration    = .5;
    rotationAnimation.cumulative  = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    CABasicAnimation* rotationAnimation2;
    rotationAnimation2             = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.toValue     = [NSNumber numberWithFloat: -M_PI * 2.0 ];
    rotationAnimation2.duration    = .5;
    rotationAnimation2.cumulative  = YES;
    rotationAnimation2.repeatCount = INT_MAX;
    
    
    [_leftImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [_rightImageView.layer addAnimation:rotationAnimation2 forKey:@"rotationAnimation2"];
}

- (void)endPullAnimating {
    TFLog(@"%s",__func__);
    [UIView animateWithDuration:.35 animations:^{
        _leftImageView.tfLeft       = 0;
        _leftImageView.image      = [UIImage imageNamed:@"PullToRefreshStart.png"];
        _leftImageView.transform  = CGAffineTransformIdentity;
        [_leftImageView.layer removeAllAnimations];
        [_leftImageView.layer pop_removeAllAnimations];
        
        _rightImageView.tfLeft      = self.tfWidth - _rightImageView.tfWidth;
        _rightImageView.image     = [UIImage imageNamed:@"PullToRefreshStart.png"];
        _rightImageView.transform = CGAffineTransformIdentity;
        [_rightImageView.layer removeAllAnimations];
        [_rightImageView.layer pop_removeAllAnimations];
    } completion:^(BOOL finished) {
        _bump = NO;
    }];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier {
    TFLog(@"%s",__func__);
}


@end
