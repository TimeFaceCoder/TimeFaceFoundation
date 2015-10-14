//
//  DashboardView.h
//  TimeFaceFire
//
//  Created by Melvin on 10/13/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardView : UIView

/**
 *  最小值,默认0.0
 */
@property (nonatomic) CGFloat minValue;
/**
 *  最大值，默认1.0
 */
@property (nonatomic) CGFloat maxValue;
/**
 *  值，默认 0.0
 */
@property (nonatomic) CGFloat value;

#pragma mark - 主刻度属性
/**
 *  开始角度，默认-225.0°
 */
@property (nonatomic) CGFloat rulingStartAngle;
/**
 *  结束角度，默认45.0°
 */
@property (nonatomic) CGFloat rulingStopAngle;
/**
 *  刻度数量,默认10
 */
@property (nonatomic) NSUInteger rulingCount;
/**
 *  刻度线颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *rulingLineColor;
/**
 *  刻度点颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *rulingPointColor;
/**
 *  刻度文字颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *rulingTextColor;
/**
 *  刻度文字字体
 */
@property (nonatomic, strong) UIFont *rulingTextFont;
/**
 *  文本数组
 */
@property (nonatomic, strong) NSArray *rulingText;
/**
 *  警告阀值
 */
@property (nonatomic) CGFloat warningValue;
/**
 *  警告抖动使能，默认YES
 */
@property (nonatomic, getter=isWarningWiggleEnable) BOOL warningWiggleEnable;

#pragma mark - 指针属性
/**
 *  指针图片
 */
@property (nonatomic, strong) UIImage *needleImage;
/**
 *  背景图片
 */
@property (nonatomic, strong) UIImage *backgroundImage;

#pragma mark - 动画属性
/**
 *  是否启用指针转动动画
 */
@property (nonatomic,getter=isAnimationEnable) BOOL animationEnable;
/**
 *  指针移动动画时间，默认0.5
 */
@property (nonatomic) CGFloat animationTime;

/**
 *  值转化成指针对应的角度
 *
 *  @param value
 *
 *  @return
 */
-(CGFloat)angleWithValue:(CGFloat)value;

/**
 *  指针的角度转换成对应的值
 *
 *  @param angle
 *
 *  @return 
 */
-(CGFloat)valueWithAngle:(CGFloat)angle;


@end
