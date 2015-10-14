//
//  UIScrollView+TFPullRefresh.h
//  TimeFaceV2
//
//  Created by Melvin on 8/13/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFTableRefreshView2;
typedef NS_ENUM(NSInteger ,TFPullRefreshState) {
    TFPullRefreshStateNone      = 0,
    TFPullRefreshStateTriggered = 1,
    TFPullRefreshStateLoading   = 2,
};
@interface UIScrollView (TFPullRefresh)

@property (nonatomic, assign) BOOL showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerPullToRefresh;
- (void)endPullToRefresh;

@end
