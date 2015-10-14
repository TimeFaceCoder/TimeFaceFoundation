//
//  URLHelper.m
//  TFProject
//
//  Created by Melvin on 10/21/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "URLHelper.h"

const static NSString   *kInterfaceKey = @"interface";
const static NSString   *kClassKey = @"class";

@implementation URLHelper {
    
}

+ (instancetype)sharedHelper {
    static URLHelper* helper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[self alloc] init];
        }
    });
    return helper;
}

/**
 *  列表类型,接口,处理类对应表
 *  字典结构 key:lisTtype value: {interface,class}
 *  @return
 */
+ (NSDictionary *)defaultMappingInfo {
    NSDictionary *defaultMappingInfo = nil;
    if (!defaultMappingInfo) {
        defaultMappingInfo = @{
//                               [NSNumber numberWithInteger:ListTypeFollowTime]:@{
//                                       kInterfaceKey:INTERFACE_TIMELIST,
//                                       kClassKey:@"TweetsTableDataManager"},
//                               [NSNumber numberWithInteger:ListTypeTimes]:@{
//                                       kInterfaceKey:INTERFACE_TIMELIST,
//                                       kClassKey:@"TweetsTableDataManager"},
//                               [NSNumber numberWithInteger:ListTypeEvents]:@{
//                                       kInterfaceKey:INTERFACE_EVENTLIST,
//                                       kClassKey:@"EventTableDataManager"},
//                               [NSNumber numberWithInteger:ListTypeTopics]:@{
//                                       kInterfaceKey:INTERFACE_TOPICLIST,
//                                       kClassKey:@"TopicsTableDataManager"},
//                               [NSNumber numberWithInteger:ListTypeEventList]:@{
//                                       kInterfaceKey:INTERFACE_TIMELIST,
//                                       kClassKey:@"EventListTableDataManager"},
//                               [NSNumber numberWithInteger:ListTypeUserTimeList]:@{
//                                       kInterfaceKey:INTERFACE_USERTIMELINE,
//                                       kClassKey:@"UserTableDataManager"}
                               };
    }
    return defaultMappingInfo;
}

- (id) init
{
    self = [super init];
    if (self) {
        //add interface at here
    }
    return self;
}

- (NSString *)interfaceByListType:(NSInteger)listType {
    NSDictionary *entry = [[URLHelper defaultMappingInfo] objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        return nil;
    }
    return [entry objectForKey:kInterfaceKey];
}

- (NSString *)urlByListType:(NSInteger)listType {
    NSString *interface = [self interfaceByListType:listType];
    NSString *url = interface;
    return url;
}

- (NSString *)classNameByListType:(NSInteger)listType {
    NSDictionary *entry = [[URLHelper defaultMappingInfo] objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        return nil;
    }
    return [entry objectForKey:kClassKey];
}

@end
