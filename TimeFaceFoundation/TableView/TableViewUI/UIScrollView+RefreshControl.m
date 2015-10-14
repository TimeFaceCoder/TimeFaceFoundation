//
//  UIScrollView+RefreshControl.m
//  TimeFaceV2
//
//  Created by Melvin on 11/10/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIScrollView+RefreshControl.h"
#import "TFDefaultStyle.h"
#import <objc/runtime.h>
#import "TFTableRefreshView.h"
//#define RefreshControlHeight 60
#define RefreshControlHeight 30


typedef NS_ENUM (NSInteger, RefreshControlState) {
    RefreshControlStatePulling      = 1,
    RefreshControlStateLoading      = 2,
};

@interface RefreshControl () {
    
}

@property (nonatomic ,assign) RefreshControlState   refreshControlState;
@property (nonatomic ,strong) UIImageView           *refreshImageView;
@property (nonatomic ,strong) UILabel               *textLabel;
@property (nonatomic ,strong) TFTableRefreshView    *tableRefreshView;

- (void)removeObservers;
@end

@implementation RefreshControl {
    BOOL _trigged;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _refreshImageView = [[UIImageView alloc] init];
        _refreshImageView.tfSize = CGSizeMake(70, 50);
        _refreshImageView.tfCenterX = self.tfCenterX;
        _refreshImageView.tfTop = 5;
        _refreshImageView.contentMode = UIViewContentModeCenter;
        _refreshImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _refreshImageView.hidden = YES;
//        _refreshImageView.layer.borderWidth = 1;
        [self addSubview:_refreshImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = TFSTYLEVAR(loadingTextColor);
        _textLabel.font = TFSTYLEVAR(font10);
        _textLabel.text = NSLocalizedString(@"下拉刷新", nil);
        _textLabel.hidden = YES;
        [_textLabel sizeToFit];
        _textLabel.tfTop  = _refreshImageView.tfBottom + 5;
        _textLabel.tfCenterX = self.tfCenterX;

        //CGFloat width = 100;
//        _tableRefreshView = [[TFTableRefreshView alloc] initWithFrame:CGRectMake((self.width - width)/2, 0, width, self.height)];
//        [self addSubview:_tableRefreshView];
        TFLog(@"label frame:%@",NSStringFromCGRect(_textLabel.frame));
//        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat left = (self.width - 50 - _textLabel.width) / 2;
//    _refreshImageView.left = left;
//    _refreshImageView.top = 5;
//    _textLabel.left = _refreshImageView.right;
//    _textLabel.centerY = _refreshImageView.centerY + 6;
    
}



- (void)dealloc {
    [self removeObservers];
}

- (void)removeObservers
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"pan.state"];
    _scrollView = nil;
}


- (void)setScrollView:(UIScrollView *)scrollView
{
    
    [self removeObservers];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //TFLog(@"%@ %@", @(self.scrollView.contentOffset.y), @(self.originalContentInsectY));
    
    if (self.scrollView.contentOffset.y + self.originalContentInsectY <= 0) {
        if ([keyPath isEqualToString:@"pan.state"]) {
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded && _trigged) {
                [self setRefreshControlState:RefreshControlStateLoading];
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     self.scrollView.contentOffset = CGPointMake(0, -RefreshControlHeight - self.originalContentInsectY);
                                     self.scrollView.contentInset = UIEdgeInsetsMake(RefreshControlHeight + self.originalContentInsectY, 0.0f, 0.0f, 0.0f);
                                 }
                                 completion:^(BOOL finished) {
                                     if (self.RefreshActionBlock) {
                                         self.RefreshActionBlock();
                                     }
                                 }];
            }
        }
        else if([keyPath isEqualToString:@"contentOffset"]){
            [self scrollViewContentOffsetChanged];
        }
    }
}

- (void)scrollViewContentOffsetChanged
{
    if (_refreshControlState != RefreshControlStateLoading) {
        _textLabel.hidden = YES;
        _refreshImageView.hidden = YES;
        if (self.scrollView.isDragging && self.scrollView.contentOffset.y + self.originalContentInsectY < -RefreshControlHeight && !_trigged) {
            _trigged = YES;
        }
        else {
            if (self.scrollView.isDragging && self.scrollView.contentOffset.y + self.originalContentInsectY > -RefreshControlHeight) {
                _trigged = NO;
            }
            [self setRefreshControlState:RefreshControlStatePulling];
        }
    }
}

- (void)setRefreshControlState:(RefreshControlState)refreshControlState {
    CGFloat offset = -(self.scrollView.contentOffset.y + self.originalContentInsectY);
    CGFloat percent = 0;
    if (offset < 0) {
        offset = 0;
    }
    if (offset > RefreshControlHeight) {
        offset = RefreshControlHeight;
    }
    percent = offset / RefreshControlHeight;
    NSUInteger drawingIndex = percent * (self.drawingImgs.count - 1);
    
    
    if (drawingIndex > 1 && offset > 15) {
        _refreshImageView.hidden = NO;
        _textLabel.hidden = NO;
    }
        
    if (drawingIndex + 1 == self.drawingImgs.count) {
        _textLabel.text = NSLocalizedString(@"放开刷新", nil);
    }
    switch (refreshControlState) {
            
        case RefreshControlStatePulling:
            [_refreshImageView stopAnimating];
            _refreshImageView.image = self.drawingImgs[drawingIndex];
            
            break;
            
        case RefreshControlStateLoading:
            _refreshImageView.animationImages = self.loadingImgs;
            _refreshImageView.animationDuration = (CGFloat)self.loadingImgs.count/20.0;
            [_refreshImageView startAnimating];
            _textLabel.text = NSLocalizedString(@"正在加载", nil);

            break;
        default:
            break;
    }
    _refreshControlState = refreshControlState;
}


- (void)endLoading
{
    if (_refreshControlState == RefreshControlStateLoading) {
        _trigged = NO;
        [self setRefreshControlState:RefreshControlStatePulling];
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _refreshImageView.hidden = YES;
                             _textLabel.hidden = YES;
                             _textLabel.text = NSLocalizedString(@"下拉刷新", nil);
                             self.scrollView.contentInset = UIEdgeInsetsMake(_originalContentInsectY, 0.0f, 0.0f, 0.0f);
                         }
                         completion:nil];
    }
}

@end



static char UIScrollViewPullToRefresh;
@implementation UIScrollView (RefreshControl)

- (void)setRefreshControl:(RefreshControl *)pullToRefreshView {
    [self willChangeValueForKey:@"UIScrollViewGifPullToRefresh"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefresh,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewGifPullToRefresh"];
}

- (RefreshControl *)refreshControl {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefresh);
}


- (void)addPullToRefreshWithDrawingImgs:(NSArray*)drawingImgs
                            loadingImgs:(NSArray*)loadingImgs
                       actionHandler:(void (^)(void))actionHandler
{
    
    RefreshControl *view = [[RefreshControl alloc] initWithFrame:CGRectMake(0, -RefreshControlHeight, self.bounds.size.width, RefreshControlHeight)];
    if (TTOSVersion() >= 7.0) {
        //view.originalContentInsectY = 64;
        view.originalContentInsectY = 30;
    }
    
    view.scrollView = self;
    view.RefreshActionBlock = actionHandler;
    view.drawingImgs = drawingImgs;
    view.loadingImgs = loadingImgs;
    [self addSubview:view];
    self.refreshControl = view;
}

- (void)removePullToRefresh {
    TFLog(@"%s",__func__);
    [self.refreshControl removeObservers];
}

- (void)didFinishPullToRefresh
{
    [self.refreshControl endLoading];
}

@end
