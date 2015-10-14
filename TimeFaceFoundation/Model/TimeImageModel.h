//
//  TimeImageModel.h
//  TimeFaceV2
//
//  Created by Melvin on 4/8/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFModel.h"
#import "ImageTagModel.h"

@protocol ImageTagModel;

@interface TimeImageModel : TFModel

@property  NSInteger     imageId;
@property  BOOL          selected;
@property  NSString      *imageUrl;
@property  CGFloat       imgWidth;
@property  CGFloat       imgHeight;
@property  NSString      *primaryColor;
@property  RLMArray<ImageTagModel *><ImageTagModel> *tags;


@end

RLM_ARRAY_TYPE(TimeImageModel)