//
//  TFStringUtility.m
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFStringUtility.h"
#import "TFCoreUtility.h"
#import "../System Services/SystemServices.h"
#import "Pinyin.h"


@implementation TFStringUtility

+(instancetype)shared {
    static TFStringUtility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}


-(NSString *)showUsername:(NSString *)name {
    NSString *username = @"";
    if ([[TFCoreUtility sharedUtility] validateUserPhone:name]) {
        username = [NSString stringWithFormat:@"%@****%@",[name substringToIndex:3],[name substringFromIndex:(name.length - 4)]];
    } else {
        username = name;
    }
    return username;
}




- (NSString *)getTimeDescriptionStringByTimeInterval:(NSTimeInterval)timeInterval {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:date1 toDate:[NSDate date] options:0];
    if (components.year > 0) {
        //        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription years", nil),components.year];
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if(components.month >0){
        //        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription month", nil),components.month];
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if (components.day > 0) {
        if (components.day > 3) {
            return [self getTimeStringByTimeInterval2:timeInterval];
        }
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription day", nil),components.day];
    } else if(components.hour > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription hour", nil),components.hour];
    } else if(components.minute > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription minute", nil),components.minute];
    } else {
        return NSLocalizedString(@"TimeDescription moment", nil);
    }
}
- (NSString *)getTimeStringByTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [[TFCoreUtility sharedUtility] getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}
- (NSString *)getScreen {
    NSInteger width = 2 * [[SystemServices sharedServices] screenWidth];
    NSInteger height = 2 * [[SystemServices sharedServices] screenHeight];
    NSString *screen = [NSString stringWithFormat:@"%ldX%ld",(long)width,(long)height];
    return screen;
}
- (NSString *)subString:(NSString *)str length:(NSInteger)length {
    
    if ([[TFCoreUtility sharedUtility] charNumber:str] > length) {
        NSString* tmp;
        for (NSInteger i = str.length; i > 0; i--) {
            tmp = [str substringToIndex:i];
            if ([[TFCoreUtility sharedUtility] charNumber:tmp] <= length) {
                return tmp;
                break;
            }
        }
    }
    return str;
}

/**
 *  将时间转为字符串
 *
 *  @param date   时间（NSDate）
 *  @param format 格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
/**
 *  将时间转为字符串
 *
 *  @param timeInterval 时间戳（NSTimeInterval）
 *  @param format       格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSDate *fromdate= [[TFCoreUtility sharedUtility] getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *string = [dateFormat stringFromDate:fromdate];
    return string;
}

- (NSString*)getTimeDescriptionStringByTimeIntervalForTimeDetail:(NSTimeInterval)timeInterval {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:date1 toDate:[NSDate date] options:0];
    if (components.year > 0) {
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if(components.month >0){
        NSString *timeDescription = [self getTimeStringByTimeInterval2:timeInterval];
        return [timeDescription substringFromIndex:5];
    } else if (components.day > 0) {
        if (components.day > 3) {
            NSString *timeDescription = [self getTimeStringByTimeInterval2:timeInterval];
            return [timeDescription substringFromIndex:5];
        }
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription day", nil),components.day];
    } else if(components.hour > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription hour", nil),components.hour];
    } else if(components.minute > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription minute", nil),components.minute];
    } else {
        return NSLocalizedString(@"TimeDescription moment", nil);
    }
}
- (NSString *)getTimeStringByTimeInterval2:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [[TFCoreUtility sharedUtility] getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}
- (NSString *)getStringFromUrl:(NSString *)url withKey:(NSString *)key{
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(^|&|\\?)%@=([^&]*)(&|$)",key] options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:url
                                                           options:0
                                                             range:NSMakeRange(0, [url length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[url substringWithRange:resultRange];
            NSRange rangeOne;
            rangeOne=[result rangeOfString:[key stringByAppendingString:@"="]];
            NSRange range = NSMakeRange(rangeOne.length+rangeOne.location, result.length-(rangeOne.length+rangeOne.location));
            //获取code值
            NSString *targetStr = [[result substringWithRange:range] stringByReplacingOccurrencesOfString:@"&" withString:@""];
            return targetStr;
        }
    }
    return nil;
}
- (NSString *)getCircleIdFromUrl:(NSString *)url withKey:(NSString *)key {
    NSArray *array = [url componentsSeparatedByString:@"/"];
    if (array.count < 2) {
        return nil;
    }
    
    NSString *circle = array[array.count - 2];
    if ([circle isEqualToString:key]) {
        return array[array.count - 1];
    }
    return nil;
}





/**
 *  图片请求转换
 *
 *  @param url
 *  @param type
 *
 *  @return
 */
- (NSString *)handleImageUrl:(NSString *)url type:(NSString *)type {
    //    NSInteger markUpload = [[self getValueByKey:STORE_KEY_PICTUREQUALITYBROWSE] integerValue];
    //    //0自动 1高 2低
    //    if (markUpload == 0) {
    //        if ([[SystemServices sharedServices] connectedToWiFi]) {
    //            //使用高清图
    //            NSRange thumbnail = [url rangeOfString:@"thumbnail"];
    //            if (thumbnail.length > 0) {
    //                url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:type];
    //            }
    //        }
    //    }
    //    if (markUpload == 1) {
    //        //使用高清图
    //        NSRange thumbnail = [url rangeOfString:@"thumbnail"];
    //        if (thumbnail.length > 0) {
    //            url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:type];
    //        }
    //    }
    return url;
}


-(NSString *)getPinyinName:(NSString *)name {
    NSString *pinYinResult=[NSString string];
    for(int j=0;j < name.length;j++){
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([name characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}
/**
 *  获取分享内容
 *
 *  @param string
 *  @param maxLength
 *
 *  @return
 */
-(NSString *) shareMessageWithString:(NSString *)string maxLength:(NSUInteger)maxLength {
    NSUInteger len = [[TFCoreUtility sharedUtility] unicodeLengthOfString:string];
    if (len > maxLength) {
        string = [NSString stringWithFormat:@"%@...",[self substringToIndex:maxLength withString:string]];
    }
    return string;
}
/**
 *  按字节数截取指定长度字符串
 *
 *  @param index
 *  @param string
 *
 *  @return
 */
-(NSString *) substringToIndex:(NSInteger)index withString:(NSString *)string {
    NSString *newstr = @"";
    NSUInteger length = 0;
    NSInteger charlen = 0;
    NSUInteger iloop = 0;
    
    while (iloop < string.length) {
        unichar uc = [string characterAtIndex:iloop];
        charlen = isascii(uc) ? 1 : 2;
        length += charlen;
        
        if (length > index) {
            break;
        }
        newstr = [NSString stringWithFormat:@"%@%@",newstr,[[string substringFromIndex:iloop] substringToIndex:1]];
        iloop++;
    }
    return newstr;
}


- (NSString *)getTimeStringByTimeInterval3:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [[TFCoreUtility sharedUtility] getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

@end
