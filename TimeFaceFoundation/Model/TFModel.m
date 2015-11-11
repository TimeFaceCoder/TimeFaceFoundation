//
//  TFModel.m
//  TimeFace
//
//  Created by zguanyu on 9/23/15.
//  right © 2015 timeface. All rights reserved.
//

#import "TFModel.h"
//#import <Realm/RLMObjectSchema.h>
//#import <Realm/RLMProperty.h>
//#import <Realm/RLMArray.h>

@implementation TFModel

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

//- (id)initWithRealmModel:(RLMObject *)model {
//    NSDictionary *dic = [model toDictionary];
//    NSError *error = nil;
//    self = [super initWithDictionary:dic error:&error];
//    if (self) {
//        
//    }
//    return self;
//}


//- (id)initWithDictionary:(NSDictionary *)dict error:(NSError**)error{
//    self = [self init];
//    if (!dict) {
//        *error = [NSError errorWithDomain:APP_ERROR_DOMAIN
//                                    code:TFErrorCodeEmpty
//                                userInfo:nil];
//        return nil;
//    }
//    if (![dict isKindOfClass:[NSDictionary class]]) {
//        *error = [NSError errorWithDomain:APP_ERROR_DOMAIN
//                                     code:TFErrorCodeClassType
//                                 userInfo:nil];
//        return nil;
//    }
//    if (self) {
//        if (self.objectSchema) {
//            NSArray *properties = self.objectSchema.properties;
//            NSMutableDictionary *toInitDic = [[NSMutableDictionary alloc]initWithDictionary:dict];
//            for (RLMProperty *prop in properties) {
//                TFLog(@"pror = %@",prop);
//                id obj = [dict objectForKey:prop.name];
//                if (!obj) {
//                    if (prop.type == RLMPropertyTypeInt) {
//                        obj = [NSNumber numberWithInt:0];
//                    }else if (prop.type == RLMPropertyTypeDouble){
//                        obj = [NSNumber numberWithDouble:0];
//                    }else if (prop.type == RLMPropertyTypeBool){
//                        obj = [NSNumber numberWithBool:0];
//                    }else if (prop.type == RLMPropertyTypeFloat){
//                        obj = [NSNumber numberWithFloat:0];
//                    }else if(prop.type == RLMPropertyTypeString){
//                        obj = [NSString string];
//                    }else if (prop.type == RLMPropertyTypeObject){
//                        Class someClass = NSClassFromString(prop.objectClassName);
//                        NSError *error = nil;
//                        obj = [[someClass alloc] initWithDictionary:nil error:&error];
//                    }else if (prop.type == RLMPropertyTypeArray){
//                        obj = [NSArray array];
//                    }else if (prop.type == RLMPropertyTypeDate){
//                        obj = [NSDate date];
//                    }else if (prop.type == RLMPropertyTypeData){
//                        obj = [NSData data];
//                    }else if(prop.type == RLMPropertyTypeAny){
//                        obj = [NSObject new];
//                    }
//                    [toInitDic setObject:obj forKey:prop.name];
//                }else {
//                    if (prop.type == RLMPropertyTypeArray) {
//                        Class someClass = NSClassFromString(prop.objectClassName);
//                        NSError *error = nil;
//                        NSArray *dataDic = [dict objectForKey:prop.name];
//                        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:10];
//                        for (NSDictionary *subDic in dataDic) {
//                            id object = [[someClass alloc] initWithDictionary:subDic error:&error];
//                            [array addObject:object];
//                        }
//                        [toInitDic setObject:array forKey:prop.name];
//                        
//                    }
//                }
//            }
//            self = [self initWithValue:toInitDic];
//        }
//    }else {
//        *error = [NSError errorWithDomain:APP_ERROR_DOMAIN
//                                     code:TFErrorCodeEmpty
//                                 userInfo:nil];
//        return nil;
//    }
//    return self;
//}
//
//- (NSDictionary*)toDictionary {
//    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//    
//    if (self.objectSchema) {
//        NSArray *properties = self.objectSchema.properties;
//        for (RLMProperty *prop in properties) {
//            if (prop.type == RLMPropertyTypeObject) {
//                TFModel *object = [self valueForKey:prop.name];
//                NSDictionary *dic = [object toDictionary];
//                [dictionary setObject:dic forKey:prop.name];
//            }else if (prop.type == RLMPropertyTypeArray) {
//                RLMArray *rlmArray = [self valueForKey:prop.name];
//                NSMutableArray *array = [[NSMutableArray alloc]init];
//                for (TFModel *object in rlmArray) {
//                    NSDictionary *dic = [object toDictionary];
//                    [array addObject:dic];
//                }
//                [dictionary setObject:array forKey:prop.name];
//            }else {
//                NSString *value = [self valueForKey:prop.name];
//                TFLog(@"prop = %@ value = %@",prop,value);
//                if (!value) {
//                    value = [NSString string];
//                }
//                [dictionary setObject:value forKey:prop.name];
//            }
//            
//            
//        }
//    }
//    
//    
//    
//    return dictionary;
//}

@end
