//
//  TFDataHelper.h
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/15/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMRealm.h"
#import "RLMResults.h"
#import "RLMObject.h"

@interface TFDataHelper : NSObject


@property (nonatomic, strong)RLMRealm  *defaultRealm;

+(instancetype) shared;

/**
 *  存储一个对象
 *
 *  @param object
 */
- (void)saveObject:(RLMObject*)object;

/**
 *  通过一个key-value获取一个指定类型对象(value为字符类型)
 *
 *  @param key
 *  @param value
 *  @param className
 *
 *  @return
 */
- (RLMResults*)getObjectsWithKey:(NSString*)key strValue:(NSString*)value class:(Class)className;
/**
 *  通过一个key-value获取一个指定类型对象(value为数字类型)
 *
 *  @param key
 *  @param value
 *  @param className
 *
 *  @return
 */
- (RLMResults*)getObjectsWithKey:(NSString *)key numValue:(NSNumber *)value class:(Class)className;
/**
 *  获取一个类型所有的对象
 *
 *  @param className
 *
 *  @return
 */
- (RLMResults*)getAllObject:(Class)className;
/**
 *  删除指定数据
 *
 *  @param object
 */
- (void)removeObject:(RLMObject*)object;



@end
