//
//  WebViewBridge.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "WebViewBridge.h"
#import "TimeFaceFoundationConst.h"


@implementation WebViewBridge

/**
 *  空方法,JS用于判断是否在时光流影客户端
 */
- (void)isReady {
    
}



/**
 *  打开时光详情
 *
 *  @param params 参数列表,以数组形式提交
 */
- (void)showTimeDetail:(NSArray *)params {
    if (params && [params count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTFOpenLocalNotification
                                                            object:nil
                                                          userInfo:@{@"dataId":[params objectAtIndex:0],
                                                                     @"type":@"1"}];
    }
}
/**
 *  打开话题
 *
 *  @param params
 */
- (void)showTalkDetail:(NSArray *)params {
    if (params && [params count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTFOpenLocalNotification
                                                            object:nil
                                                          userInfo:@{@"dataId":[params objectAtIndex:0],
                                                                     @"type":@"2"}];
    }
}

/**
 *  打开用户详情
 *
 *  @param params
 */
- (void)showUserDetail:(NSArray *)params {
    if (params && [params count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTFOpenLocalNotification
                                                            object:nil
                                                          userInfo:@{@"dataId":[params objectAtIndex:0],
                                                                     @"type":@"3"}];
    }
}


- (void)closeWebView {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTFCloseWebViewNotification
                                                        object:nil
                                                      userInfo:nil];
}

@end
