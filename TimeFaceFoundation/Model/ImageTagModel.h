//
//  ImageTagModel.h
//  TimeFaceV2
//
//  Created by Melvin on 3/24/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFModel.h"
#import "UserModel.h"
#import <UIKit/UIKit.h>

@interface ImageTagModel : TFModel

/**
 *  UID
 */
@property  NSString  *uid;
/**
 *  tag内容
 */
@property  NSString  *content;

@property  CGFloat   width;

@property  CGFloat   height;

@property  CGFloat   pointX;

@property  CGFloat   pointY;

@property  NSString  *tagId;

@property  UserModel *userInfo;

@property  BOOL      selected;



+ (instancetype)tagWithProperties:(NSDictionary*)info;

- (NSString *)debugDescription;
@end

RLM_ARRAY_TYPE(ImageTagModel)
