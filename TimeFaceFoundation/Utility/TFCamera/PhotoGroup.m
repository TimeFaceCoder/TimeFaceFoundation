//
//  PhotoGroup.m
//  TimeFaceV2
//
//  Created by 吴寿 on 15/5/20.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "PhotoGroup.h"

@implementation PhotoGroup

- (id)init {
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
