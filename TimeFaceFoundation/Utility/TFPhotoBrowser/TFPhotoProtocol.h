//
//  TFPhotoProtocol.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

@protocol TFPhoto <NSObject>

@property (nonatomic, strong) UIImage   *underlyingImage;
@property (nonatomic, strong) NSURL     *currentPhotoUrl;
@property (nonatomic, strong) NSDate     *datetime;

@required
- (void)loadUnderlyingImageAndNotify;
- (void)performLoadUnderlyingImageAndNotify;
- (void)unloadUnderlyingImage;

@optional

- (void)cancelAnyLoading;
- (void)faceFeature;
@end
