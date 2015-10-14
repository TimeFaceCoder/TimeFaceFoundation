//
//  TFPhoto.m
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFPhoto.h"
#import "SDWebImageDecoder.h"
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DBLibraryManager.h"

@interface TFPhoto() {
    BOOL _loadingInProgress;
    id <SDWebImageOperation> _webImageOperation;
}
- (void)imageLoadingComplete;
@end

@implementation TFPhoto
@synthesize underlyingImage = _underlyingImage; // synth property from protocol
@synthesize currentPhotoUrl = _currentPhotoUrl;


+ (TFPhoto *)photoWithImage:(UIImage *)image {
    return [[TFPhoto alloc] initWithImage:image];
}


+ (TFPhoto *)photoWithURL:(NSURL *)url {
    return [[TFPhoto alloc] initWithURL:url];
}

#pragma mark - Init

- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        _image = image;
    }
    return self;
}

// Deprecated
- (id)initWithFilePath:(NSString *)path {
    if ((self = [super init])) {
        _photoURL = [NSURL fileURLWithPath:path];
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _photoURL = [url copy];
    }
    return self;
}

#pragma mark - MWPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (NSURL *)currentPhotoUrl {
    return _photoURL;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (_loadingInProgress) return;
    _loadingInProgress = YES;
    @try {
        if (self.underlyingImage) {
            [self imageLoadingComplete];
        } else {
            [self performLoadUnderlyingImageAndNotify];
        }
    }
    @catch (NSException *exception) {
        self.underlyingImage = nil;
        _loadingInProgress = NO;
        [self imageLoadingComplete];
    }
    @finally {
    }
}

// Set the underlyingImage
- (void)performLoadUnderlyingImageAndNotify {
    
    // Get underlying image
    if (_image) {
        // We have UIImage!
        self.underlyingImage = _image;
        [self imageLoadingComplete];
        
    } else if (_photoURL) {
        
        // Check what type of url it is
        if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
            // Load from asset library async
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    @try {
                        [[DBLibraryManager sharedInstance] fixAssetForURL:_photoURL
                                                              resultBlock:^(ALAsset *asset)
                         {
                             ALAssetRepresentation *rep = [asset defaultRepresentation];
                             CGImageRef iref = [rep fullScreenImage];
                             if (iref) {
                                 self.underlyingImage = [UIImage imageWithCGImage:iref];
                             }
                             [self performSelectorOnMainThread:@selector(imageLoadingComplete)
                                                    withObject:nil
                                                 waitUntilDone:NO];
                         } failureBlock:^(NSError *error) {
                             
                             self.underlyingImage = nil;
                             TFLog(@"Photo from asset library error: %@",error);
                             [self performSelectorOnMainThread:@selector(imageLoadingComplete)
                                                    withObject:nil
                                                 waitUntilDone:NO];
                         }];
                    } @catch (NSException *e) {
                        TFLog(@"Photo from asset library error: %@", e);
                        [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                    }
                }
            });
            
        } else if ([_photoURL isFileReferenceURL]) {
            
            // Load from local file async
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    @try {
                        self.underlyingImage = [UIImage imageWithContentsOfFile:_photoURL.path];
                        if (!_underlyingImage) {
                            TFLog(@"Error loading photo from path: %@", _photoURL.path);
                        }
                    } @finally {
                        [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                    }
                }
            });
            
        } else {
            
            // Load async from web (using SDWebImage)
            @try {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                _webImageOperation = [manager downloadImageWithURL:_photoURL
                                                           options:0
                                                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                              if (expectedSize > 0) {
                                                                  float progress = receivedSize / (float)expectedSize;
                                                                  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                        [NSNumber numberWithFloat:progress], @"progress",
                                                                                        self, @"photo", nil];
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_TFPHOTO_PROGRESS object:dict];
                                                              }
                                                          }
                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                             if (error) {
                                                                 TFLog(@"SDWebImage failed to download image: %@", error);
                                                             }
                                                             _webImageOperation = nil;
                                                             self.underlyingImage = image;
                                                             [self imageLoadingComplete];
                                                         }];
            } @catch (NSException *e) {
                TFLog(@"Photo from web: %@", e);
                _webImageOperation = nil;
                [self imageLoadingComplete];
            }
            
        }
        
    } else {
        
        // Failed - no source
        @throw [NSException exceptionWithName:@"" reason:nil userInfo:nil];
        
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
    self.underlyingImage = nil;
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    // Notify on next run loop
    [self performSelector:@selector(postCompleteNotification) withObject:nil afterDelay:0];
}

- (void)postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_TFPHOTO_ENDLOADING
                                                        object:self];
}

- (void)cancelAnyLoading {
    if (_webImageOperation) {
        [_webImageOperation cancel];
        _loadingInProgress = NO;
    }
}

@end
