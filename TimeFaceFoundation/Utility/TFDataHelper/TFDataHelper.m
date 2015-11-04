//
//  TFDataHelper.m
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/15/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFDataHelper.h"
#import "YTKKeyValueStore.h"
#import "ViewGuideModel.h"

@implementation TFDataHelper

const YTKKeyValueStore *store;
+ (instancetype) shared {
    static dispatch_once_t once;
    static TFDataHelper *instance = nil;
    dispatch_once(&once, ^{
//        NSString *docPath = nil;
//        #ifdef DEBUG
//        docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        #else
//        docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        #endif
//        NSString *dbPath = [docPath stringByAppendingPathComponent:@"TIMEFACEDB"];
        instance = [[self alloc]initWithPath:@"TIMEFACEDB"];
    });
    return instance;
}


- (id)initWithPath:(NSString*)path{
    self = [super init];
    if (self) {
        store = [[YTKKeyValueStore alloc] initDBWithName:path];
    }
    return self;
}

/**
 *  保存／更新数据
 *
 *  @param object
 */
-(void) save:(id)object objId:(NSString *)objId {
    NSString *tabelName = NSStringFromClass([object class]);
    
    NSDictionary *dic;
    if (![object isKindOfClass:[NSDictionary class]]) {
        dic = [object toDictionary];
    } else {
        dic = object;
    }
    
    [store createTableWithName:tabelName];  //建表
    [store putObject:dic withId:objId intoTable:tabelName];  //将数据加入到表中
}

/**
 *  获取一个对象数据
 *
 *  @param aClass
 *  @param ident
 *
 *  @return
 */
-(id) getObject:(NSString *)className objId:(NSString *)objId {
    NSDictionary *dic = [store getObjectById:objId fromTable:className];
    NSError *error = nil;
    id object = [[NSClassFromString(className) alloc] initWithDictionary:dic error:&error];
    if (error) {
        TFLog(@"%s:%@",__func__,[error debugDescription]);
    }
    return object;
}



/**
 *  获取所有数据
 *
 *  @param aClass
 *
 *  @return
 */
-(NSArray *) getAll:(Class)aClass {
    return [store getAllItemsFromTable:NSStringFromClass(aClass)];
}

/**
 *  删除对应数据
 *
 *  @param object
 */
-(void) remove:(Class)aClass objId:(NSString *)objId {
    [store deleteObjectById:objId fromTable:NSStringFromClass(aClass)];
}

/**
 *  删除所有数据
 *
 *  @param aClass
 */
-(void) removeAll:(Class)aClass {
    [store clearTable:NSStringFromClass(aClass)];
}

///**
// *  保存更新用户登陆信息
// *
// *  @param login
// */
//-(void) saveUser:(UserModel *)user {
//    [self signOut];
//    [self saveUser:user logined:TRUE];
//}
//-(void) saveUser:(UserModel *)user logined:(BOOL)logined {
//    if (logined) {
//        [TFLogAgent bindUserIdentifier:user.userId];
//    }
//    user.logined = logined;
//    [self save:user objId:user.userId];
//}
//
///**
// *  将当前账号转为备份状态
// */
//-(void)backupCurrentUser {
//    UserModel *user = [self getCurrentUserModel];
//    if (!user) {
//        return ;
//    }
//    user.backup = YES;
//    
//    [self saveUser:user logined:NO];
//}
//
///**
// *  还原备份账号为当前登录状态用户
// */
//-(void)restoreUser {
//    NSArray *array = [self getAll:[UserModel class]];
//    for (YTKKeyValueItem *item in array) {
//        NSError *error = nil;
//        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
//        if (user.backup) {
//            user.backup = NO;
//            [self saveUser:user];
//            break ;
//        }
//    }
//}
//
//-(UserModel *)getCurrentBackupUser {
//    NSArray *array = [self getAll:[UserModel class]];
//    for (YTKKeyValueItem *item in array) {
//        NSError *error = nil;
//        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
//        if (user.backup) {
//            return user;
//        }
//    }
//    return nil;
//}
//
///**
// *  取消备份账号的备份状态
// */
//-(void)cancelBackupUser {
//    UserModel *user = [self getCurrentBackupUser];
//    if (!user) {
//        return ;
//    }
//    user.backup = NO;
//    
//    [self saveUser:user logined:NO];
//}
//
///**
// *  获取用户登陆信息
// *
// *  @param userId
// *
// *  @return
// */
//-(UserModel *) getUserWithId:(NSString *)userId {
//    return [self getObject:NSStringFromClass([UserModel class]) objId:userId];
//}
///**
// *  获取当前登录用户
// *
// *  @return
// */
//-(UserModel *) getCurrentUserModel {
//    NSArray *array = [self getAll:[UserModel class]];
//    for (YTKKeyValueItem *item in array) {
//        NSError *error = nil;
//        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
//        if (user.logined) {
//            return user;
//        }
//    }
//    return nil;
//}
///**
// *  获取所有用户
// *
// *  @return
// */
//-(NSArray *) getAllUser {
//    NSArray *array = [self getAll:[UserModel class]];
//    NSMutableArray *users = [NSMutableArray array];
//    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
//    
//    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
//    
//    for (YTKKeyValueItem *item in array) {
//        NSError *error = nil;
//        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
//        if (user) {
//            [users addObject:user];
//        }
//    }
//    return users;
//}
//
///**
// *  删除当前用户
// */
//-(void) removeCurrentUser {
//    UserModel *user = [self getCurrentUserModel];
//    [self remove:[UserModel class] objId:user.userId];
//}
///**
// *  切换账号到下个账号
// *
// *  @return TRUE切换成功，FALSE切换失败
// */
//-(BOOL) changeCurrentWithNextUser {
//    NSArray *users = [self getAllUser];
//    if (!users.count) {
//        return FALSE;
//    }
//    UserModel *user = [users objectAtIndex:0];
//    [self saveUser:user];
//    return TRUE;
//}
//
//
///**
// *  注销账号处理
// */
//-(void) signOut {
//    NSArray *array = [self getAll:[UserModel class]];
//    for (YTKKeyValueItem *item in array) {
//        NSError *error = nil;
//        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
//        if (user.logined) {
//            [self saveUser:user logined:FALSE];
//        }
//    }
//}

-(void)saveViewGuideData {
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"ViewGuideHelp" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSInteger iloop = 0;
    while (iloop < array.count) {
        @autoreleasepool {
            NSDictionary *entry = [array objectAtIndex:iloop];
            ViewGuideModel *model = [[ViewGuideModel alloc] initWithDictionary:entry error:&error];
            
            if (!error) {
                ViewGuideModel *oldGuide = [self loadViewGuideWithViewId:model.viewId];
                if (!oldGuide || ![oldGuide.version isEqualToString:model.version]) {
                    [self save:model objId:model.viewId];
                }
            }
            
            iloop++;
        }
    }
}

-(ViewGuideModel *) loadViewGuideWithViewId:(NSString *)viewId {
    return [self getObject:NSStringFromClass([ViewGuideModel class]) objId:viewId];
}








///**
// *  存储一个对象
// *
// *  @param object
// */
//- (void)saveObject:(RLMObject*)object {
//    if (_defaultRealm) {
//        [_defaultRealm beginWriteTransaction];
//        [_defaultRealm addObject:object];
//        [_defaultRealm commitWriteTransaction];
//    }
//    
//}
//
///**
// *  通过一个key-value获取一个指定类型对象
// *
// *  @param key
// *  @param value
// *  @param className
// */
//- (RLMResults*)getObjectsWithKey:(NSString*)key strValue:(NSString*)value class:(Class)className {
//    if (_defaultRealm) {
//        NSString *queryStr = [NSString stringWithFormat:@"%@ = '%@'",key,value];
//        RLMResults *result = [className objectsInRealm:_defaultRealm where:queryStr];
//        return result;
//    }
//    return nil;
//}
//
//- (RLMResults*)getObjectsWithKey:(NSString *)key numValue:(NSNumber *)value class:(Class)className {
//    if (_defaultRealm) {
//        NSString *queryStr = [NSString stringWithFormat:@"%@ = %@",key,value];
//        RLMResults *result = [className objectsInRealm:_defaultRealm where:queryStr];
//        return result;
//    }
//    return nil;
//}
///**
// *  获取一个类型所有的对象
// *
// *  @param className
// */
//- (RLMResults*)getAllObject:(Class)className {
//    if (_defaultRealm) {
//        RLMResults *result = [className allObjectsInRealm:_defaultRealm];
//        return result;
//    }
//    return nil;
//}
//
///**
// *  删除指定数据
// *
// *  @param object
// */
//- (void)removeObject:(RLMObject*)object {
//    if (_defaultRealm) {
//        [_defaultRealm beginWriteTransaction];
//        [_defaultRealm deleteObject:object];
//        [_defaultRealm commitWriteTransaction];
//    }
//}



@end
