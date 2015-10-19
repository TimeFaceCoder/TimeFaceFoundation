//
//  TFStringUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFDataHelper.h"

@interface TFStringUtility : NSObject


+ (instancetype)shared;



/**
 *  获取用户userID
 *
 *  @return
 */
- (NSString *)getUserId;
- (NSString *)showUsername:(NSString *)name;




- (NSString *)getTimeDescriptionStringByTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)getTimeStringByTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)getScreen;

- (NSString *)subString:(NSString *)str length:(NSInteger)length;
- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
/**
 *  将时间转为字符串
 *
 *  @param timeInterval 时间戳（NSTimeInterval）
 *  @param format       格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

- (NSString*)getTimeDescriptionStringByTimeIntervalForTimeDetail:(NSTimeInterval)timeInterval;

- (NSString *)getTimeStringByTimeInterval2:(NSTimeInterval)timeInterval;

- (NSString *)getStringFromUrl:(NSString *)url withKey:(NSString *)key;
- (NSString *)getCircleIdFromUrl:(NSString *)url withKey:(NSString *)key;




/**
 *  图片请求转换
 *
 *  @param url
 *  @param type
 *
 *  @return
 */
- (NSString *)handleImageUrl:(NSString *)url type:(NSString *)type;




-(NSString *)getPinyinName:(NSString *)name;
/**
 *  获取分享内容
 *
 *  @param string
 *  @param maxLength
 *
 *  @return
 */
-(NSString *) shareMessageWithString:(NSString *)string maxLength:(NSUInteger)maxLength;
/**
 *  按字节数截取指定长度字符串
 *
 *  @param index
 *  @param string
 *
 *  @return
 */
-(NSString *) substringToIndex:(NSInteger)index withString:(NSString *)string;

@end
