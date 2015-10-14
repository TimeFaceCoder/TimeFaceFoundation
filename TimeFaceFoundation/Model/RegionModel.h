//
//  RegionModel.h
//  TimeFaceV2
//
//  Created by 吴寿 on 14/12/4.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import "TFModel.h"

@interface RegionModel : TFModel

@property  NSInteger locationId;
@property  NSString *locationName;
@property  NSInteger locationPid;
@property  BOOL hasChild;

@end
