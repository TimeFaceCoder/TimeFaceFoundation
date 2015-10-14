//
//  KvStore.m
//  TimeFace
//
//  Created by boxwu on 14/11/19.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import "KvStore.h"
#import "YTKKeyValueStore.h"
#import "ViewGuideModel.h"
#import "UserModel.h"

@implementation KvStore

const YTKKeyValueStore *store;
+ (instancetype) shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = self.new;
        store = [[YTKKeyValueStore alloc] initDBWithName:@"TIMEFACEDB"];
    });
    return instance;
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
    if (!error) {
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

/**
 *  保存更新用户登陆信息
 *
 *  @param login
 */
-(void) saveUser:(UserModel *)user {
    [self signOut];
    [self saveUser:user logined:TRUE];
}
-(void) saveUser:(UserModel *)user logined:(BOOL)logined {
    user.logined = logined;
    [self save:user objId:user.userId];
}

/**
 *  将当前账号转为备份状态
 */
-(void)backupCurrentUser {
    UserModel *user = [self getCurrentUserModel];
    if (!user) {
        return ;
    }
    user.backup = YES;
    
    [self saveUser:user logined:NO];
}

/**
 *  还原备份账号为当前登录状态用户
 */
-(void)restoreUser {
    NSArray *array = [self getAll:[UserModel class]];
    for (YTKKeyValueItem *item in array) {
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
        if (user.backup) {
            user.backup = NO;
            [self saveUser:user];
            break ;
        }
    }
}

-(UserModel *)getCurrentBackupUser {
    NSArray *array = [self getAll:[UserModel class]];
    for (YTKKeyValueItem *item in array) {
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
        if (user.backup) {
            return user;
        }
    }
    return nil;
}

/**
 *  取消备份账号的备份状态
 */
-(void)cancelBackupUser {
    UserModel *user = [self getCurrentBackupUser];
    if (!user) {
        return ;
    }
    user.backup = NO;
    
    [self saveUser:user logined:NO];
}

/**
 *  获取用户登陆信息
 *
 *  @param userId
 *
 *  @return
 */
-(UserModel *) getUserWithId:(NSString *)userId {
    return [self getObject:NSStringFromClass([UserModel class]) objId:userId];
}
/**
 *  获取当前登录用户
 *
 *  @return
 */
-(UserModel *) getCurrentUserModel {
    NSArray *array = [self getAll:[UserModel class]];
    for (YTKKeyValueItem *item in array) {
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
        if (user.logined) {
            return user;
        }
    }
    return nil;
}
/**
 *  获取所有用户
 *
 *  @return
 */
-(NSArray *) getAllUser {
    NSArray *array = [self getAll:[UserModel class]];
    NSMutableArray *users = [NSMutableArray array];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
    
    array = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for (YTKKeyValueItem *item in array) {
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
        if (user) {
            [users addObject:user];
        }
    }
    return users;
}

/**
 *  删除当前用户
 */
-(void) removeCurrentUser {
    UserModel *user = [self getCurrentUserModel];
    [self remove:[UserModel class] objId:user.userId];
}
/**
 *  切换账号到下个账号
 *
 *  @return TRUE切换成功，FALSE切换失败
 */
-(BOOL) changeCurrentWithNextUser {
    NSArray *users = [self getAllUser];
    if (!users.count) {
        return FALSE;
    }
    UserModel *user = [users objectAtIndex:0];
    [self saveUser:user];
    return TRUE;
}


/**
 *  注销账号处理
 */
-(void) signOut {
    NSArray *array = [self getAll:[UserModel class]];
    for (YTKKeyValueItem *item in array) {
        NSError *error = nil;
        UserModel *user = [[UserModel alloc] initWithDictionary:item.itemObject error:&error];
        if (user.logined) {
            [self saveUser:user logined:FALSE];
        }
    }
}

-(void) saveRegion:(NSDictionary *)region {
    [store createTableWithName:STORE_KEY_REGION];  //建表
    [store putObject:region withId:STORE_KEY_REGION intoTable:STORE_KEY_REGION];  //将数据加入到表中
}
/**
 *  保存区域信息的时间
 */
-(NSTimeInterval) currentRegion {
    YTKKeyValueItem *item = [store getYTKKeyValueItemById:STORE_KEY_REGION fromTable:STORE_KEY_REGION];
    return [item.createdTime timeIntervalSinceReferenceDate];
}

-(NSArray *) getRegion {
    NSDictionary *result = [store getObjectById:STORE_KEY_REGION fromTable:STORE_KEY_REGION];
    return [result objectForKey:@"dataList"];
}

/**
 *  存储数据信息
 *
 *  @param data
 *  @param dataId
 */
- (void)saveData:(id)data forKey:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

- (id)getDataForKey:(NSString *)key {
    id object;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    object = [defaults objectForKey:key];
    return object;
}

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

@end
