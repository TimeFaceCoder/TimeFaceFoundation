//
//  TFLogAgent.h
//  TFLog
//
//  Created by Melvin on 6/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    /**
     *  实时发送
     */
    ReportPolicyRealTime,
    /**
     *  下次启动发送
     */
    ReportPolicyBatch,
} ReportPolicyType;

@interface TFLogAgent : NSObject


+(void)startWithAppKey:(NSString*)appKey serverURL:(NSString *)serverURL;

+(void)startWithAppKey:(NSString*)appKey reportPolicy:(ReportPolicyType)reportPolicy serverURL:(NSString*)serverURL
;
+(void)postEvent:(NSString *)eventId;

+(void)postEvent:(NSString *)eventId label:(NSString *)label;

+(void)postEvent:(NSString *)eventId acc:(NSInteger)acc;

+(void)postEvent:(NSString *)eventId label:(NSString *)label acc:(NSInteger)acc;

+(void)postTag:(NSString *)tag;

+(void)bindUserIdentifier:(NSString *)userid;

+(void)startTracPage:(NSString*)pageName;

+(void)endTracPage:(NSString*)pageName;

// Check if the device jail broken
+ (BOOL)isJailbroken;
+ (NSString*)getDeviceId;
- (void)saveErrorLog:(NSString*)stackTrace;
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
void InstallUncaughtExceptionHandler();
