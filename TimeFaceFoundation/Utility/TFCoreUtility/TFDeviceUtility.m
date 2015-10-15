//
//  TFDeviceUtility.m
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFDeviceUtility.h"
#import "SSKeychain.h"

@implementation TFDeviceUtility

+(instancetype)shared {
    static TFDeviceUtility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}


- (NSString *)getDeviceId {
    NSString *idfv = [SSKeychain passwordForService:@"tf__ios" account:@"app_user"];
    if (!idfv) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:idfv forService:@"tf__ios" account:@"app_user"];
    }
    return idfv;
}

@end
