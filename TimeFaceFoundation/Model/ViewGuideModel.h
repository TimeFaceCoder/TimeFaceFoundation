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
@property  NSInteger tag;
/**
 *  类型 0 无指引，1 有指引
 */
@property  BOOL point;
/**
 *  形状 0 圆形，1矩形，2 自定义圆形、3自定义矩形，4 其他
 */
@property  NSInteger shape;
@property  NSString *shapeImage;

/**
 *  提示信息
 */
@property  NSString *show;
/**
 *  停留时间，0 手动点击
 */
@property  NSInteger time;

@end

RLM_ARRAY_TYPE(GuideModel)


@protocol GuideModel;


@interface ViewGuideModel : TFModel

/**
 *  编号，对应页面的classname
 */
@property  NSString *viewId;
/**
 *  分类，0 手动，1 全自动 2 混合，3 显示所有
 */
@property  NSInteger category;

/**
 *  显示延时
 */
@property  CGFloat delayShow;
/**
 *  版本号
 */
@property  NSString *version;

/**
 *  所有引导配置
 */
@property  RLMArray<GuideModel *><GuideModel> *guides;

/**
 *  当前
 */
@property  NSInteger index;

@end

