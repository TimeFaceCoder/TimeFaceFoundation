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


extern NSString*  TF_APP_ERROR_DOMAIN    ;

/////////////////////////////////////////////Common Error Code//////////////////////////////////////

extern NSInteger const kTFErrorCodeUnknown         ;
extern NSInteger const kTFErrorCodeAPI             ;
extern NSInteger const kTFErrorCodeHTTP            ;
extern NSInteger const kTFErrorCodeNetwork         ;
extern NSInteger const kTFErrorCodeEmpty           ;
extern NSInteger const kTFErrorCodeClassType       ;
extern NSInteger const kTFErrorCodeLocationError   ;
extern NSInteger const kTFErrorCodePhotosError     ;
extern NSInteger const kTFErrorCodeMicrophoneError ;
extern NSInteger const kTFErrorCodeCameraError     ;
extern NSInteger const kTFErrorCodeContactsError   ;


/////////////////////////////////////////////Common View State//////////////////////////////////////
extern NSInteger const kTFViewStateNone            ;
extern NSInteger const kTFViewStateLoading         ;
extern NSInteger const kTFViewStateNetError        ;
extern NSInteger const kTFViewStateDataError       ;
extern NSInteger const kTFViewStateNoData          ;
extern NSInteger const kTFViewStateTimeOut         ;
extern NSInteger const kTFViewStateLocationError   ;
extern NSInteger const kTFViewStatePhotosError     ;
extern NSInteger const kTFViewStateMicrophoneError ;
extern NSInteger const kTFViewStateCameraError     ;
extern NSInteger const kTFViewStateContactsError   ;

///////////////////////////////////////////Common ScrollDirection///////////////////////////////////
extern NSInteger const kTFScrollDirectionNone      ;
extern NSInteger const kTFScrollDirectionUp        ;
extern NSInteger const kTFScrollDirectionDown      ;
extern NSInteger const kTFScrollDirectionLeft      ;
extern NSInteger const kTFScrollDirectionRight     ;
extern NSInteger const kTFScrollDirectionVertical  ;
extern NSInteger const kTFScrollDirectionHorizontal;



///////////////////////////////////////////Common Notification//////////////////////////////////////
extern NSString * const kTFOpenLocalNotification;
extern NSString * const kTFCloseWebViewNotification;
extern NSString * const kTFAutoLoadNotification;
extern NSString * const kTFReloadCellNotification;





