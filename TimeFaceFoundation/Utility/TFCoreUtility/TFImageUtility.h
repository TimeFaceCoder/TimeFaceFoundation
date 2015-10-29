//
//  TFImageUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TFImageUtility : NSObject

+ (instancetype)shared;


- (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  使用颜色生成指定尺寸图片
 *
 *  @param color
 *  @param width
 *  @param height
 *
 *  @return
 */
- (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;

/**
 *  使用颜色值、透明度生成图片
 *
 *  @param color 颜色值
 *  @param alpha 透明度
 *
 *  @return 图片对象
 */
- (UIImage *)createImageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
/**
 *  当前屏幕截图
 *
 *  @return
 */
- (UIImage *)currentViewToImage;

/**
 *  截取指定view为图片
 *
 *  @param orgView
 *
 *  @return 
 */
-(UIImage *)getImageFromView:(UIView *)orgView;


@end
