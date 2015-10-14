//
//  TimeLineModel.h
//  TFProject
//
//  Created by Melvin on 10/23/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFModel.h"
//#import "AdModel.h"
#import "UserModel.h"
#import "TimeImageModel.h"
#import "TFString.h"



@protocol TimeImageModel;

@interface TimeLineModel : TFModel

/**
 *  标题
 */
@property  NSString                     *title;
/**
 *  内容
 */
@property  NSString                     *content;
/**
 *  日期
 */
@property  NSTimeInterval               date;
/**
 *  图片列表
 */
@property  RLMArray<TFString *><TFString>                  *imageList;
/**
 *  图片列表集合
 */
@property  RLMArray<TimeImageModel *><TimeImageModel>      *imageObjectList;
//
@property  RLMArray<TimeImageModel *><TimeImageModel>      *imageObjList;
/**
 *  时光书ID
 */
@property  NSString                     *bookId;
/**
 *  时光书标题
 */
@property  NSString                     *bookTitle;
/**
 *  是否赞
 */
@property  BOOL                         like;
/**
 *  赞数量
 */
@property  NSInteger                    likeCount;
/**
 *  是否收藏
 */
@property  BOOL                         favorite;
/**
 *  是否评论
 */
@property  BOOL                         comment;
/**
 *  评论数量
 */
@property  NSInteger                    commentCount;
/**
 *  时光uid
 */
@property  NSString                     *uid;
/**
 *  纬度
 */
@property  double                       lat;
/**
 *  经度
 */
@property  double                       lng;
/**
 *  标签
 */
@property  NSString                     *tags;
/**
 *  时光所属活动
 */
@property  NSString                     *eventsLabel;
/**
 *  发布终端
 */
@property  NSString                     *client;
/**
 *  所属类型 1 时光 2 广告
 */
@property  NSInteger                    type;

//////////////////////////////////兼容属性处理////////////////////////////
@property  NSString                     *timeId;

@property  NSString                     *topicId;

@property  NSString                     *timeTitle;

@property  UserModel                    *author;

//@property (nonatomic ,copy  ) AdModel                      *adInfo;

@property  NSString                     *activityId;

@property  NSString                     *activityName;


/**
 *  是否喜欢
 */
@property  BOOL                         love;
/**
 *  喜欢数量
 */
@property  NSInteger                    loveCount;
/**
 *  追溯时间
 */
@property  NSTimeInterval               correctTime;
/**
 *  at用户列表
 */
@property  RLMArray<UserModel *><UserModel>  *atUser;
/**
 *  前20个赞用户
 */
@property  RLMArray<TFString *><TFString>            *topOkList;
/**
 *  前10条评论
 */
@property  RLMArray<TFString *><TFString>              *topCommentList;

/**
 *  话题图片URL
 */
@property  NSString                     *imageUrl;

@property  NSString                     *imgUrl;
/**
 *  是否删除
 */
@property  BOOL                         delete;
/**
 *  时光圈里使用时，圈Id
 */
@property  NSString                     *circleId;
/**
 *  时光权利使用时，圈名字
 */
@property  NSString                     *circleName;
/**
 *  是否被编辑
 */
@property  BOOL                         isEdit;
/**
 *  图片数组的Json字符串
 */
@property  NSString                     *imageListStr;
/**
 *  作者信息Json字符串
 */
@property  NSString                     *authorStr;
/**
 *  圈主Id
 */
@property  NSString                     *circleAuthorId;
/**
 *  是否圈成员
 */
@property  BOOL                         isMember;

@end
