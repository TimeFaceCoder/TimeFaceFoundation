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


@end
