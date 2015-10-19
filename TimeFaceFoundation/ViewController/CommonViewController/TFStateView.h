//
//  TFStateView.h
//  TimeFaceV2
//
//  Created by Melvin on 1/13/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "UIAdditions.h"


@protocol ViewStateDataSource <NSObject>

@optional
- (NSAttributedString *)titleForStateView:(UIView *)view;
- (NSAttributedString *)descriptionForStateView:(UIView *)view;
- (UIImage *)imageForStateView:(UIView *)view;
- (FLAnimatedImage *)animationImageForStateView:(UIView *)view;
- (NSArray *)imagesForStateView:(UIView *)view;
- (UIView *)customViewForStateView:(UIView *)view;


- (NSAttributedString *)buttonTitleForStateView:(UIView *)view forState:(UIControlState)state;
- (UIImage *)buttonBackgroundImageForStateView:(UIView *)view forState:(UIControlState)state;
- (UIColor *)backgroundColorForStateView:(UIView *)view;
- (CGPoint)offsetForStateView:(UIView *)view;
- (CGRect)frameForStateView:(UIView *)view;
- (CGFloat)spaceHeightForStateView:(UIView *)view;


@end

@protocol ViewStateDelegate <NSObject>
@optional

- (BOOL)stateViewShouldDisplay:(UIView *)view;
- (BOOL)stateViewShouldAllowTouch:(UIView *)view;
- (BOOL)stateViewShouldAllowScroll:(UIView *)view;
- (void)stateViewDidTapView:(UIView *)view;
- (void)stateViewDidTapButton:(UIView *)view;
- (void)stateViewWillAppear:(UIView *)view;
- (void)stateViewWillDisappear:(UIView *)view;

@end

@interface StateView : UIView {
    
}

/**
 *  主体
 */
@property (nonatomic ,strong ,readonly) UIView              *contentView;
/**
 *  标题
 */
@property (nonatomic ,strong ,readonly) UILabel             *titleLabel;
/**
 *  详细内容
 */
@property (nonatomic ,strong ,readonly) UILabel             *detailLabel;
/**
 *  图片
 */
@property (nonatomic ,strong ,readonly) FLAnimatedImageView *imageView;
/**
 *  按钮
 */
@property (nonatomic ,strong ,readonly) UIButton            *button;
/**
 *  自定义View
 */
@property (nonatomic, strong          ) UIView              *customView;
/**
 *  偏移
 */
@property (nonatomic, assign          ) CGPoint             offset;
/**
 *  竖向间距
 */
@property (nonatomic, assign          ) CGFloat             verticalSpace;

@end


@interface TFStateView : UIView {
    
}
@property (nonatomic, weak) id <ViewStateDataSource> stateDataSource;

@property (nonatomic, weak) id <ViewStateDelegate> stateDelegate;

@property (nonatomic, readonly, getter = isStateVisible) BOOL stateVisible;


/**
 *  显示 StateView
 */
- (void)showStateView;
/**
 *  移除 StateView
 */
- (void)removeStateView;

@end
