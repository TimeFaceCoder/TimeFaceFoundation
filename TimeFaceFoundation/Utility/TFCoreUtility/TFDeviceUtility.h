//
//  TFDeviceUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFDeviceUtility : NSObject


+ (instancetype)shared;



/*
 *  获取设备唯一编号
 *
 *  @return
 */
- (NSString *)getDeviceId;

@end
