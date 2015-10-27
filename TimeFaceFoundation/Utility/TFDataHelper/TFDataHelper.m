//
//  TFDataHelper.m
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/15/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFDataHelper.h"

@implementation TFDataHelper


+ (instancetype) shared {
    static dispatch_once_t once;
    static TFDataHelper *instance = nil;
    dispatch_once(&once, ^{
        NSString *docPath = nil;
        #ifdef DEBUG
        docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        #else
        docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        #endif
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"tfDB.realm"];
        instance = [[self alloc]initWithPath:dbPath];
    });
    return instance;
}


- (id)initWithPath:(NSString*)path{
    self = [super init];
    if (self) {
        _defaultRealm = [RLMRealm realmWithPath:path];
    }
    return self;
}

/**
 *  存储一个对象
 *
 *  @param object
 */
- (void)saveObject:(RLMObject*)object {
    if (_defaultRealm) {
        [_defaultRealm beginWriteTransaction];
        [_defaultRealm addObject:object];
        [_defaultRealm commitWriteTransaction];
    }
    
}

/**
 *  通过一个key-value获取一个指定类型对象
 *
 *  @param key
 *  @param value
 *  @param className
 */
- (RLMResults*)getObjectsWithKey:(NSString*)key strValue:(NSString*)value class:(Class)className {
    if (_defaultRealm) {
        NSString *queryStr = [NSString stringWithFormat:@"%@ = '%@'",key,value];
        RLMResults *result = [className objectsInRealm:_defaultRealm where:queryStr];
        return result;
    }
    return nil;
}

- (RLMResults*)getObjectsWithKey:(NSString *)key numValue:(NSNumber *)value class:(Class)className {
    if (_defaultRealm) {
        NSString *queryStr = [NSString stringWithFormat:@"%@ = %@",key,value];
        RLMResults *result = [className objectsInRealm:_defaultRealm where:queryStr];
        return result;
    }
    return nil;
}
/**
 *  获取一个类型所有的对象
 *
 *  @param className
 */
- (RLMResults*)getAllObject:(Class)className {
    if (_defaultRealm) {
        RLMResults *result = [className allObjectsInRealm:_defaultRealm];
        return result;
    }
    return nil;
}

/**
 *  删除指定数据
 *
 *  @param object
 */
- (void)removeObject:(RLMObject*)object {
    if (_defaultRealm) {
        [_defaultRealm beginWriteTransaction];
        [_defaultRealm deleteObject:object];
        [_defaultRealm commitWriteTransaction];
    }
}



@end
