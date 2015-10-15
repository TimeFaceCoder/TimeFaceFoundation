//
//  TFDataUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFDataUtility : NSObject

+ (instancetype)shared;

/**
 *  保存string到NSUserDefaults
 *
 *  @param key
 *  @param value
 */
- (void)saveValueByKey:(NSString *)key value:(id)value;

/**
 *  删除NSUserDefaults对应值
 *
 *  @param key
 *
 */
- (void)removeValueByKey:(NSString *)key ;
/**
 *  保存BOOL到NSUserDefaults
 *
 *  @param key
 *  @param value
 */
- (void)setBoolByKey:(NSString *)key value:(BOOL)value;

/**
 *  获取NSUserDefaults对应值
 *
 *  @param key
 *
 *  @return
 */
- (id)getValueByKey:(NSString *)key;


#pragma  mark - BOOL
- (BOOL)getBoolByKey:(NSString *)key;

@end
