//
//  URLHelper.m
//  TFProject
//
//  Created by Melvin on 10/21/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "URLHelper.h"


static NSDictionary     *urlDictionary = nil;

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
       return urlDictionary;
}

- (void)setUrlDictionary:(NSDictionary*)dict {
    urlDictionary = dict;
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
