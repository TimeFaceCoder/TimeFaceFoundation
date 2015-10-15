//
//  TFDataUtility.m
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFDataUtility.h"

@implementation TFDataUtility

+(instancetype)shared {
    static TFDataUtility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}

- (void)saveValueByKey:(NSString *)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeValueByKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
}

- (void)setBoolByKey:(NSString *)key value:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getValueByKey:(NSString *)key {
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (temp) {
        return temp;
    }
    return nil;
}

- (BOOL)getBoolByKey:(NSString *)key {
    BOOL temp = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return temp;
}


@end
