//
//  TimeFaceFoundationConst.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/30/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>



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
