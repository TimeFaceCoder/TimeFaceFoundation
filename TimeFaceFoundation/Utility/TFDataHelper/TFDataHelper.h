//
//  TFDataHelper.h
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/15/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UserModel;
@class ViewGuideModel;


@interface TFDataHelper : NSObject



+(instancetype) shared;


/**
 *  保存／更新数据
 *
 *  @param object
 */
-(void) save:(id)object objId:(NSString *)objId;

/**
 *  获取一个对象数据
 *
 *  @param aClass
 *  @param ident
 *
 *  @return
 */
-(id) getObject:(NSString *)className objId:(NSString *)objId;
//-(id) getObjectByClass:(Class *)aClass objId:(NSString *)objId;

/**
 *  获取所有数据
 *
 *  @param aClass
 *
 *  @return
 */
-(NSArray *) getAll:(Class)aClass;

/**
 *  删除对应数据
 *
 *  @param object
 */
-(void) remove:(Class)aClass objId:(NSString *)objId;

/**
 *  删除所有数据
 *
 *  @param aClass
 */
-(void) removeAll:(Class)aClass;

/**
 *  保存引导信息
 */
-(void)saveViewGuideData;
/**
 *  获取引导信息
 *
 *  @param viewId
 *
 *  @return 
 */
-(ViewGuideModel *) loadViewGuideWithViewId:(NSString *)viewId;

///**
// *  存储一个对象
// *
// *  @param object
// */
//- (void)saveObject:(RLMObject*)object;
//
///**
// *  通过一个key-value获取一个指定类型对象(value为字符类型)
// *
// *  @param key
// *  @param value
// *  @param className
// *
// *  @return
// */
//- (RLMResults*)getObjectsWithKey:(NSString*)key strValue:(NSString*)value class:(Class)className;
///**
// *  通过一个key-value获取一个指定类型对象(value为数字类型)
// *
// *  @param key
// *  @param value
// *  @param className
// *
// *  @return
// */
//- (RLMResults*)getObjectsWithKey:(NSString *)key numValue:(NSNumber *)value class:(Class)className;
///**
// *  获取一个类型所有的对象
// *
// *  @param className
// *
// *  @return
// */
//- (RLMResults*)getAllObject:(Class)className;
///**
// *  删除指定数据
// *
// *  @param object
// */
//- (void)removeObject:(RLMObject*)object;



@end
