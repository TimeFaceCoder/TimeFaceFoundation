//
//  KvStore.h
//  TimeFace
//
//  Created by boxwu on 14/11/19.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"

@class UserModel;
@class ViewGuideModel;

@interface KvStore : NSObject

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

/////////////////////////////////////用户信息存储//////////////////////////////////
/**
 *  保存更新用户登陆信息
 *
 *  @param login
 */
-(void) saveUser:(UserModel *)user;
-(void) saveUser:(UserModel *)user logined:(BOOL)logined;
/**
 *  将当前账号转为备份状态
 */
-(void)backupCurrentUser;
/**
 *  还原备份账号为当前登录状态用户
 */
-(void)restoreUser;
/**
 *  取消备份账号的备份状态
 */
-(void)cancelBackupUser;

/**
 *  获取用户登陆信息
 *
 *  @param userId
 *
 *  @return
 */
-(UserModel *) getUserWithId:(NSString *)userId;
/**
 *  获取当前登录用户
 *
 *  @return
 */
-(UserModel *) getCurrentUserModel;
/**
 *  获取所有用户
 *
 *  @return
 */
-(NSArray *) getAllUser;
/**
 *  删除当前用户
 */
-(void) removeCurrentUser;
/**
 *  切换账号到下个账号
 *
 *  @return TRUE切换成功，FALSE切换失败
 */
-(BOOL) changeCurrentWithNextUser;

/**
 *  注销账号处理
 */
-(void) signOut;

/**
 *  保存区域信息
 */
-(void) saveRegion:(NSDictionary *)region;
/**
 *  保存区域信息的时间
 */
-(NSTimeInterval) currentRegion;

/**
 *  获取区域信息
 */
-(NSArray *) getRegion;
/**
 *  存储数据信息
 *
 *  @param data
 *  @param dataId
 */
- (void)saveData:(id)data forKey:(NSString*)key;
/**
 *  获取数据信息
 *
 *  @param key
 *
 *  @return 
 */
- (id)getDataForKey:(NSString*)key;

-(void)saveViewGuideData;
-(ViewGuideModel *) loadViewGuideWithViewId:(NSString *)viewId;

@end
