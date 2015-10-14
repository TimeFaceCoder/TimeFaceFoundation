//
//  TFPhoto.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFPhotoProtocol.h"

@interface TFPhoto : NSObject<TFPhoto>

@property (nonatomic, readonly) UIImage        *image;
@property (nonatomic, readonly) NSURL          *photoURL;

@property (nonatomic, strong) NSURL          *thumbnail;
@property (nonatomic, strong) NSDate          *datetime;
@property (nonatomic, strong) NSString          *date;


+ (TFPhoto *)photoWithImage:(UIImage *)image;
+ (TFPhoto *)photoWithURL:(NSURL *)url;

- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;

@end
