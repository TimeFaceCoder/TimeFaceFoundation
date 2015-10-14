//
//  UserModel.h
//  TimeFaceV2
//
//  Created by Melvin on 10/29/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFModel.h"



@interface UserModel : TFModel
/**
 *  数据Id
 */
@property (nonatomic, copy  ) NSString                 *dataId;
/**
 *  用户ID
 */
@property (nonatomic ,copy  ) NSString                 *userId;
/**
 *  用户UID
 */
@property (nonatomic ,copy  ) NSString                 *uid;

@property (nonatomic ,copy  ) NSString                 *openId;
/**
 *  用户昵称
 */
@property (nonatomic ,copy  ) NSString                 *nickName;

/**
 *  用户区域
 */
@property (nonatomic ,copy  ) NSString                 *location;
/**
 *  用户生日
 */
@property (nonatomic ,assign) NSTimeInterval           birthday;
/**
 *  首字母拼音简写
 */
@property (nonatomic ,copy  ) NSString                 *pinyinName;
/**
 *  用户头像
 */
@property (nonatomic ,copy  ) NSString                 *avatar;
/**
 *  用户中心封面图片
 */
@property (nonatomic ,copy  ) NSString                 *coverImage;
/**
 *  用户简介
 */
@property (nonatomic ,copy  ) NSString                 *summary;
/**
 *  是否认证用户
 */
@property (nonatomic ,assign) BOOL                     verified;
/**
 *  积分
 */
@property (nonatomic ,assign) NSInteger                point;
/**
 *  时光币
 */
@property (nonatomic ,assign) NSInteger                timeCoin;
/**
 *  观众数
 */
@property (nonatomic ,assign) NSInteger                followers;
/**
 *  关注数
 */
@property (nonatomic ,assign) NSInteger                following;
/**
 *  是否屏蔽拉黑
 */
@property (nonatomic ,assign) BOOL                     shielded;
/**
 *  性别 0 保密 1男 2女
 */
@property (nonatomic ,assign) NSInteger                gender;
/**
 *  关注状态 0 相互都没有粉 1我粉他 2他粉我 3相互粉
 */
@property (nonatomic ,assign) NSInteger                relationship;
/**
 *  电子邮件
 */
@property (nonatomic ,copy  ) NSString                 *mail;
/**
 *  手机号码
 */
@property (nonatomic ,copy  ) NSString                 *phone;
/**
 *  登录来源 0 本站 1新浪 2 QQ 3微信 4 微信
 */
@property (nonatomic ,assign) NSInteger                from;
/**
 *  第三方ID
 */
@property (nonatomic ,strong) NSString                 *unionid;
/**
 *  第三方toke
 */
@property (nonatomic ,copy  ) NSString                 *accessToken;
/**
 *  过期时间
 */
@property (nonatomic ,copy  ) NSString                 *expiry_in;
/**
 *  过期时间
 */
@property (nonatomic ,copy  ) NSString                 *openName;
/**
 *  用户类型 0：凡人 1：个人认证 2：企业认证
 */
@property (nonatomic ,assign) NSInteger                type;
/**
 *  login 状态
 */
@property (nonatomic ,assign) BOOL                     logined;
/**
 *  是否选中
 */
@property (nonatomic ,assign) BOOL                     checked;

//@property (nonatomic ,assign) LoginStatus              limitType;
@property (nonatomic ,assign) BOOL                     backup;

@property (nonatomic ,assign) NSTimeInterval           signin;



/**
 *  真实姓名
 */
@property (nonatomic ,copy  ) NSString                 *realName;
/**
 *  公司
 */
@property (nonatomic ,copy  ) NSString                 *company;
/**
 *  职务
 */
@property (nonatomic ,copy  ) NSString                 *position;
/**
 *  固定电话
 */
@property (nonatomic ,copy  ) NSString                 *tel;
/**
 *  QQ号码
 */
@property (nonatomic ,copy  ) NSString                 *qq;
/**
 *  微信号
 */
@property (nonatomic ,copy  ) NSString                 *weChat;
@property (nonatomic ,assign) BOOL                     isSame;

@property (nonatomic, copy) NSString                   *bingId;

@property (nonatomic, copy) NSString                   *link;

@property (nonatomic, copy) NSString                   *number;



@end

RLM_ARRAY_TYPE(UserModel)


