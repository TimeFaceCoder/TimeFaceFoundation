//
//  UIScrollView+TFPullRefresh.m
//  TimeFaceV2
//
//  Created by Melvin on 8/13/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "UIScrollView+TFPullRefresh.h"
#import <objc/runtime.h>
#import "TFDefaultStyle.h"
#import "TFCoreUtility.h"
#import "TimeFaceFoundationConst.h"

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

#pragma mark - TFTableRefreshView

static CGFloat const TFRefreshViewHeight = 62;

@interface TFTableRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, readwrite) TFPullRefreshState    state;
@property (nonatomic, readwrite) TFPullRefreshPosition position;
@property (nonatomic, weak     ) UIScrollView          *scrollView;
@property (nonatomic, readwrite) CGFloat               originalTopInset;
@property (nonatomic, readwrite) CGFloat               originalBottomInset;

@property (nonatomic, assign   ) BOOL                  wasTriggeredByUser;
@property (nonatomic, assign   ) BOOL                  showsPullToRefresh;
@property (nonatomic, assign   ) BOOL                  isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

@implementation TFTableRefreshView {
    NSInteger _currentValue;
}
- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
        self.state              = TFPullRefreshStateStopped;
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"下拉刷新...",),
                       NSLocalizedString(@"释放刷新...",),
                       NSLocalizedString(@"正在刷新...",),
                       nil];
        _currentValue = 100;
        self.wasTriggeredByUser = YES;
        [self addSubview:self.titleLabel];
        _titleLabel.text = NSLocalizedString(@"下拉刷新...",);
        [_titleLabel sizeToFit];
        _titleLabel.tfCenterX = CGRectGetWidth(TTScreenBounds())/2;
        _titleLabel.tfTop = 15.f;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

#pragma mark 界面控件布局
- (void)layoutSubviews {
    switch (self.state) {
        case TFPullRefreshStateAll:
        case TFPullRefreshStateStopped:
            switch (self.position) {
                case TFPullRefreshPositionTop:
                    //
                    break;
                case TFPullRefreshPositionBottom:
                    //
                    break;
            }
            break;
            
        case TFPullRefreshStateTriggered:
            switch (self.position) {
                case TFPullRefreshPositionTop:
                    //
                    break;
                case TFPullRefreshPositionBottom:
                    //
                    break;
            }
            break;
            
        case TFPullRefreshStateLoading:
            switch (self.position) {
                case TFPullRefreshPositionTop:
                    [self shakePointer];
                    break;
                case TFPullRefreshPositionBottom:
                    //
                    break;
            }
            break;
    }
    self.titleLabel.text = [self.titles objectAtIndex:self.state];
    //计算控件位置
    
    
    
}

- (void)shakePointer {
    TFAsyncRun(^{
        if (self.state == TFPullRefreshStateLoading) {
            TFMainRun(^{
            });
            if (_currentValue == 100) {
                _currentValue = 220;
            }
            else {
                _currentValue = 100;
            }
            sleep(1);
            [self performSelectorOnMainThread:@selector(shakePointer)
                                   withObject:nil
                                waitUntilDone:NO];
        }
    });
    
}

#pragma mark Views



- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"下拉刷新...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGBCOLOR(51, 51, 51);
    }
    return _titleLabel;
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case TFPullRefreshPositionTop:
            currentInsets.top = self.originalTopInset;
            break;
        case TFPullRefreshPositionBottom:
            currentInsets.bottom = self.originalBottomInset;
            currentInsets.top = self.originalTopInset;
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case TFPullRefreshPositionTop:
            currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
            break;
        case TFPullRefreshPositionBottom:
            currentInsets.bottom = MIN(offset, self.originalBottomInset + self.bounds.size.height);
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        
        CGFloat yOrigin;
        switch (self.position) {
            case TFPullRefreshPositionTop:
                yOrigin = -TFRefreshViewHeight;
                break;
            case TFPullRefreshPositionBottom:
                yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                break;
        }
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, TFRefreshViewHeight);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
    
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != TFPullRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        switch (self.position) {
            case TFPullRefreshPositionTop:
                scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
                break;
            case TFPullRefreshPositionBottom:
                scrollOffsetThreshold = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.bounds.size.height + self.originalBottomInset;
                break;
        }
        if(!self.scrollView.isDragging && self.state == TFPullRefreshStateTriggered)
            self.state = TFPullRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == TFPullRefreshStateStopped && self.position == TFPullRefreshPositionTop)
            self.state = TFPullRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != TFPullRefreshStateStopped && self.position == TFPullRefreshPositionTop)
            self.state = TFPullRefreshStateStopped;
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == TFPullRefreshStateStopped && self.position == TFPullRefreshPositionBottom)
            self.state = TFPullRefreshStateTriggered;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != TFPullRefreshStateStopped && self.position == TFPullRefreshPositionBottom)
            self.state = TFPullRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        switch (self.position) {
            case TFPullRefreshPositionTop:
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                break;
            case TFPullRefreshPositionBottom:
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
                    offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                } else if (self.wasTriggeredByUser) {
                    offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
                break;
        }
    }
}

#pragma mark - Getters

#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerPullToRefresh];
}

- (void)startAnimating {
    switch (self.position) {
        case TFPullRefreshPositionTop:
            if(fequalzero(self.scrollView.contentOffset.y)) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            
            break;
        case TFPullRefreshPositionBottom:
            
            if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
               || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
                [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            break;
    }
    self.state = TFPullRefreshStateLoading;
    [self shakePointer];
}

- (void)stopAnimating {
    self.state = TFPullRefreshStateStopped;
    switch (self.position) {
        case TFPullRefreshPositionTop:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset)
                                         animated:YES];
            break;
        case TFPullRefreshPositionBottom:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset)
                                         animated:YES];
            break;
    }
}

- (void)setState:(TFPullRefreshState)newState {
    
    if(_state == newState)
        return;
    
    TFPullRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState) {
        case TFPullRefreshStateAll:
        case TFPullRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case TFPullRefreshStateTriggered:
            break;
            
        case TFPullRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == TFPullRefreshStateTriggered && _pullToRefreshActionHandler)
                _pullToRefreshActionHandler();
            
            break;
    }
}


@end

#pragma mark - UIScrollView (TFPullRefresh)

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (TFPullRefresh)

@dynamic pullToRefreshView,showsPullToRefresh;

#pragma mark - 
#pragma mark - Actions

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(TFPullRefreshPosition)position {
    
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        switch (position) {
            case TFPullRefreshPositionTop:
                yOrigin = - TFRefreshViewHeight;
                break;
            case TFPullRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            default:
                return;
        }
        CGRect frame = CGRectMake(0, yOrigin, self.bounds.size.width, TFRefreshViewHeight);
        TFTableRefreshView *view = [[TFTableRefreshView alloc] initWithFrame:frame];
        view.scrollView = self;
        view.pullToRefreshActionHandler = actionHandler;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        
        view.originalTopInset    = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position            = position;
        self.pullToRefreshView   = view;
        self.showsPullToRefresh  = YES;
    }
    
}
- (void)removePullToRefreshActionHandler {
    
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler position:TFPullRefreshPositionTop];
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = TFPullRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}

- (void)stopPullToRefresh {
    //中断操作
    [self.pullToRefreshView stopAnimating];
}

- (void)setPullToRefreshView:(TFTableRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"TFTableRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"TFTableRefreshView"];
}

- (TFTableRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView
                   forKeyPath:@"contentOffset"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
            
            [self addObserver:self.pullToRefreshView
                   forKeyPath:@"contentSize"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
            
            [self addObserver:self.pullToRefreshView
                   forKeyPath:@"frame"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
            
            self.pullToRefreshView.isObserving = YES;
            
            CGFloat yOrigin = 0;
            switch (self.pullToRefreshView.position) {
                case TFPullRefreshPositionTop:
                    yOrigin = -TFRefreshViewHeight;
                    break;
                case TFPullRefreshPositionBottom:
                    yOrigin = self.contentSize.height;
                    break;
            }
            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, TFRefreshViewHeight);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}


@end



