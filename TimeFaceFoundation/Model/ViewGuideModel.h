//
//  ViewGuideModel.h
//  TimeFaceV2
//
//  Created by 吴寿 on 15/4/16.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "TFModel.h"
#import <UIKit/UIKit.h>

@interface GuideModel : TFModel
/**
 *  引导视图的tag
 */
@property (nonatomic, assign) NSInteger tag;
/**
 *  类型 0 无指引，1 有指引
 */
@property (nonatomic, assign) BOOL point;
/**
 *  形状 0 圆形，1矩形，2 自定义圆形、3自定义矩形，4 其他
 */
@property (nonatomic, assign) NSInteger shape;
@property (nonatomic, strong) NSString *shapeImage;

/**
 *  提示信息
 */
@property (nonatomic, strong) NSString *show;
/**
 *  停留时间，0 手动点击
 */
@property (nonatomic, assign) NSInteger time;
/**
 *  附加图片
 */
@property (nonatomic, strong) NSString  *remarkImage;
/**
 *  附加图片中心点X
 */
@property (nonatomic, assign) CGFloat   remarkPointX;
/**
 *  附加图中心点Y
 */
@property (nonatomic, assign) CGFloat   remarkPointY;
/**
 *  是否单个全屏
 */
@property (nonatomic, assign) BOOL      isSingle;

@end



@protocol GuideModel;


@interface ViewGuideModel : TFModel

/**
 *  编号，对应页面的classname
 */
@property  NSString *viewId;
/**
 *  分类，0 手动，1 全自动 2 混合，3 单个全屏显示 4 显示所有
 */
@property (nonatomic, assign) NSInteger category;

/**
 *  显示延时
 */
@property (nonatomic, assign) CGFloat delayShow;
/**
 *  版本号
 */
@property (nonatomic, strong) NSString *version;

/**
 *  所有引导配置
 */
@property (nonatomic, strong) NSArray <GuideModel> *guides;

/**
 *  当前
 */
@property (nonatomic, assign) NSInteger index;

@end

