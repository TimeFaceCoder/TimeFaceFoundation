//
//  RouterHelper.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "RouterHelper.h"



@implementation RouterHelper

+ (instancetype) shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

- (void)routers {
    //注册viewController
}

@end
