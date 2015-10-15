//
//  TFSecurityUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFSecurityUtility : NSObject


+ (instancetype)shared;

/**
 *  对一个string进行md5加密
 *
 *  @param string
 *
 *  @return 
 */
- (NSString *)getMD5StringFromNSString:(NSString *)string;

@end
