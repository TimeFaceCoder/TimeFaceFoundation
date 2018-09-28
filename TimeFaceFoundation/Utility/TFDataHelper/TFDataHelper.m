//
//  TFDataHelper.m
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/15/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFDataHelper.h"
#import "ViewGuideModel.h"


@implementation TFDataHelper


+ (instancetype) shared {
    static dispatch_once_t once;
    static TFDataHelper *instance = nil;
    dispatch_once(&once, ^{
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
        NSLog(@"%s:%@",__func__,[error debugDescription]);
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
