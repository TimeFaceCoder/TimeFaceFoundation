//
//  TimeFaceFoundationConst.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/30/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
// Style helpers
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f \
blue:(b)/255.0f alpha:1.0f]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)
#define TFSTYLE(_SELECTOR) [[TFStyle globalStyleSheet] styleWithSelector:@#_SELECTOR]

#define TFSTYLESTATE(_SELECTOR, _STATE) [[TFStyle globalStyleSheet] \
styleWithSelector:@#_SELECTOR forState:_STATE]

#define TFSTYLESHEET ((id)[TFStyle globalStyleSheet])

#define TFSTYLEVAR(_VARNAME) [TFSTYLESHEET _VARNAME]

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSLog helpers

//#define TFLog(format, ...) NSLog(format, ## __VA_ARGS__)
#ifdef DEBUG
#define TFLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TFLog(format, ...)
#endif


#define TF_APP_ERROR_DOMAIN         @"cn.timeface.foundation"


/////////////////////////////////////////////Common Error Code//////////////////////////////////////

NSInteger const kTFErrorCodeUnknown         = 0;
NSInteger const kTFErrorCodeAPI             = 1;
NSInteger const kTFErrorCodeHTTP            = 2;
NSInteger const kTFErrorCodeNetwork         = 3;
NSInteger const kTFErrorCodeEmpty           = 4;
NSInteger const kTFErrorCodeClassType       = 5;
NSInteger const kTFErrorCodeLocationError   = 6;
NSInteger const kTFErrorCodePhotosError     = 7;
NSInteger const kTFErrorCodeMicrophoneError = 8;
NSInteger const kTFErrorCodeCameraError     = 9;
NSInteger const kTFErrorCodeContactsError   = 10;


/////////////////////////////////////////////Common View State//////////////////////////////////////
NSInteger const kTFViewStateNone            = 0;
NSInteger const kTFViewStateLoading         = 1;
NSInteger const kTFViewStateNetError        = 2;
NSInteger const kTFViewStateDataError       = 3;
NSInteger const kTFViewStateNoData          = 4;
NSInteger const kTFViewStateTimeOut         = 5;
NSInteger const kTFViewStateLocationError   = 6;
NSInteger const kTFViewStatePhotosError     = 7;
NSInteger const kTFViewStateMicrophoneError = 8;
NSInteger const kTFViewStateCameraError     = 9;
NSInteger const kTFViewStateContactsError   = 10;

///////////////////////////////////////////Common ScrollDirection///////////////////////////////////
NSInteger const kTFScrollDirectionNone       = 0;
NSInteger const kTFScrollDirectionUp         = 1;
NSInteger const kTFScrollDirectionDown       = 2;
NSInteger const kTFScrollDirectionLeft       = 3;
NSInteger const kTFScrollDirectionRight      = 4;
NSInteger const kTFScrollDirectionVertical   = 5;
NSInteger const kTFScrollDirectionHorizontal = 6;



///////////////////////////////////////////Common Notification//////////////////////////////////////
extern NSString * const kTFOpenLocalNotification;
extern NSString * const kTFCloseWebViewNotification;
extern NSString * const kTFAutoLoadNotification;
extern NSString * const kTFReloadCellNotification;





