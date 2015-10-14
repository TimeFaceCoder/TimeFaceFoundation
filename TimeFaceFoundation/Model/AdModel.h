//
//  AdModel.h
//  TimeFace
//
//  Created by Melvin on 8/28/14.
//  Copyright (c) 2014 TNMP. All rights reserved.
//

#import "TFModel.h"

@interface AdModel : TFModel
/**
 *  广告ID
 */
@property (copy ,nonatomic  ) NSString           *id;
/**
 *  广告类型
 */
@property (assign ,nonatomic) NSInteger          type;
/**
 *  广告数据ID
 */
@property (copy ,nonatomic  ) NSString           *dataId;

/**
 *  广告id
 */
@property (copy ,nonatomic  ) NSString           *adId;
/**
 *  广告图片宽度（原图）
 */
@property (assign ,nonatomic) NSInteger          adImgWidth;
/**
 *  广告图片高度（原图）
 */
@property (assign ,nonatomic) NSInteger          adImgHeight;
/**
 *  图片地址
 */
@property (copy ,nonatomic  ) NSString           *adImgUrl;
/**
 *  广告执行的uri
 *  调用网页   web:http://xxxxxxxx
 *  调用时光  time:timeId
 *  调用话题  topic:topicId
 *  调用时光书  book:bookId
 *  调用POD预览  pod:podId
 *  调用个人中心  user:userId
 *  调用扫一扫  scan:
 */
@property (copy ,nonatomic  ) NSString           *adUri;
/**
 *  停留时间(秒)
 */
@property (assign ,nonatomic) NSInteger          showTime;

/**
 *  积分
 */
@property (assign ,nonatomic) NSInteger          point;


/////////////////////////////兼容POD///////////////////////////////////////
/**
 *  广告ID
 */
@property (nonatomic ,copy  ) NSString           *adID;
/**
 *  广告左边距
 */
@property (nonatomic ,assign) CGFloat            left;
/**
 *  广告顶端边距
 */
@property (nonatomic ,assign) CGFloat            top;
/**
 *  宽度
 */
@property (nonatomic ,assign) CGFloat            width;
/**
 *  高度
 */
@property (nonatomic ,assign) CGFloat            height;


@end

