//
//  UIImageView+TFSelect.h
//  TimeFace
//
//  Created by zguanyu on 3/17/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFSTimeImageView: UIView

/**
 *  图片
 */
@property (nonatomic, strong) UIImageView *imageView;
/**
 *  是否选中
 */
@property (nonatomic, assign) BOOL select;
/**
 *  图标
 */
@property (nonatomic, strong) UIImageView *selectedIcon;
/**
 *  浮层
 */
@property (nonatomic, strong) UIView *floatingView;

@property (nonatomic, strong) NSString *imageUrl;

- (void)setImageWithName:(NSString*)url imageCut:(NSString*)imageCut;

- (id)initWithFrame:(CGRect)frame;

- (void)setImageSelected:(BOOL)select;



@end
