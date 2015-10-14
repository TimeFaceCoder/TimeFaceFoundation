//
//  ImageTagModel.m
//  TimeFaceV2
//
//  Created by Melvin on 3/24/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "ImageTagModel.h"

@implementation ImageTagModel

+ (instancetype)tagWithProperties:(NSDictionary*)info
{
    return [[ImageTagModel alloc] initWithProperties:info];
}

- (id)initWithProperties:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        [self setContent:info[@"content"]];
        [self setUid:info[@"uid"]];
        [self setWidth:CGSizeFromString(info[@"size"]).width];
        [self setHeight:CGSizeFromString(info[@"size"]).height];
        [self setPointX:CGPointFromString(info[@"pointOnImage"]).x];
        [self setPointY:CGPointFromString(info[@"pointOnImage"]).y];
    }
    return self;
}
- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"x:%@,y:%@,content:%@",@(_pointX),@(_pointY),_content];
}

@end
