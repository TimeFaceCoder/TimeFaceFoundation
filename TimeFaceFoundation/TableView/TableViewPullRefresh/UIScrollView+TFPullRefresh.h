//
//  UIScrollView+TFPullRefresh.h
//  TimeFaceV2
//
//  Created by Melvin on 8/13/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

@class TFTableRefreshView;
@interface UIScrollView (TFPullRefresh)

typedef NS_ENUM(NSUInteger, TFPullRefreshPosition) {
    TFPullRefreshPositionTop = 0,
    TFPullRefreshPositionBottom,
};
/**
 *  添加刷新组件
 *
 *  @param actionHandler 回调
 */
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
/**
 *  添加刷新组建
 *
 *  @param actionHandler 回调
 *  @param position      刷新组件位置
 */
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(TFPullRefreshPosition)position;
/**
 *  移除事件
 */
- (void)removePullToRefreshActionHandler;
/**
 *  触发
 */
- (void)triggerPullToRefresh;
/**
 *  中断下拉刷新
 */
- (void)stopPullToRefresh;

@property (nonatomic, strong, readonly) TFTableRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end

/**
 *  下拉刷新状态
 */
typedef NS_ENUM(NSInteger ,TFPullRefreshState){
    /**
     *  默认状态
     */
    TFPullRefreshStateStopped   = 0,
    /**
     *  触发
     */
    TFPullRefreshStateTriggered = 1,
    /**
     *  正在加载
     */
    TFPullRefreshStateLoading   = 2,
    /**
     *
     */
    TFPullRefreshStateAll       = 10
};


@interface TFTableRefreshView : UIView

@property (nonatomic, readonly) TFPullRefreshState    state;
@property (nonatomic, readonly) TFPullRefreshPosition position;

- (void)startAnimating;
- (void)stopAnimating;

@end
