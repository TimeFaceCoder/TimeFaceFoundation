//
//  WebViewJavascriptBridge.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCustomProtocolScheme @"wvjbscheme"
#define kQueueHasMessage      @"__WVJB_QUEUE_MESSAGE__"


typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@interface WebViewJavascriptBridge : NSObject<UIWebViewDelegate>

+ (instancetype)bridgeForWebView:(UIWebView *)webView handler:(WVJBHandler)handler;

+ (instancetype)bridgeForWebView:(UIWebView *)webView
                 webViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate
                         handler:(WVJBHandler)handler;
+ (instancetype)bridgeForWebView:(UIWebView *)webView
                 webViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate
                         handler:(WVJBHandler)handler
                  resourceBundle:(NSBundle *)bundle;

+ (void)enableLogging;

- (void)send:(id)message;
- (void)send:(id)message responseCallback:(WVJBResponseCallback)responseCallback;
- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)callHandler:(NSString *)handlerName;
- (void)callHandler:(NSString *)handlerName data:(id)data;
- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;

@end
