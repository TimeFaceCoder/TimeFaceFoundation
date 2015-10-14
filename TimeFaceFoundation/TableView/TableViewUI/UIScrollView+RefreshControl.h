//
//  UIScrollView+RefreshControl.h
//  TimeFaceV2
//
//  Created by Melvin on 11/10/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RefreshControl : UIView {
    
}

@property (nonatomic ,weak)     UIScrollView        *scrollView;
@property (nonatomic, copy) void (^RefreshActionBlock)(void);

@property (nonatomic ,strong)   NSArray             *drawingImgs;
@property (nonatomic ,strong)   NSArray             *loadingImgs;
@property (nonatomic, assign)   CGFloat             originalContentInsectY;

- (void)endLoading;

@end

@interface UIScrollView (RefreshControl)

@property (nonatomic ,strong)   RefreshControl      *refreshControl;

- (void)addPullToRefreshWithDrawingImgs:(NSArray*)drawingImgs
                            loadingImgs:(NSArray*)loadingImgs
                          actionHandler:(void (^)(void))actionHandler;
- (void)removePullToRefresh;
- (void)didFinishPullToRefresh;

@end
