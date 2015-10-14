//
//  UIImageView+TFCache.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIImageView+TFCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation UIImageView (TFCache)

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware {
    [self tf_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:nil
                   completed:nil
                    animated:animated
                   faceAware:faceAware];
}

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(SDWebImageCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware {
    [self tf_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:0
                   completed:completedBlock
                    animated:animated
                   faceAware:faceAware];
    
}

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(SDWebImageCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware {
    [self tf_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    __block UIImage *tempImage = nil;
                    if (faceAware) {
                        //image 人脸识别处理
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            CGRect facesRect = CGRectZero;
                            @autoreleasepool {
                                CIImage *ciImage = image.CIImage;
                                if (!ciImage) {
                                    ciImage = [CIImage imageWithCGImage:image.CGImage];
                                }
                                CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                                          context:nil
                                                                          options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
                                NSArray* features = [detector featuresInImage:ciImage];
                                facesRect = CGRectMake(image.size.width/2.0, image.size.height/2.0, 0, 0);
                                if (features.count > 0) {
                                    facesRect = ((CIFaceFeature*)[features objectAtIndex:0]).bounds;
                                    for (CIFaceFeature* faceFeature in features) {
                                        facesRect = CGRectUnion(facesRect, faceFeature.bounds);
                                    }
                                }
                            }
                            if (facesRect.size.width != 0 && facesRect.size.height != 0) {
                                //识别到人脸
                                tempImage = [self scaleImageFocusingOnRect:facesRect image:image];
                            }
                            dispatch_main_sync_safe(^{
                                if (animated) {
                                    CATransition *animation = [CATransition animation];
                                    animation.delegate = self;
                                    animation.duration = .35;
                                    animation.timingFunction = UIViewAnimationCurveEaseInOut;
                                    animation.type = kCATransitionFade;
                                    wself.image = tempImage?tempImage:image;
                                    [wself setNeedsLayout];
                                    [[wself layer] addAnimation:animation forKey:@"animation"];
                                }
                                else {
                                    wself.image = tempImage?tempImage:image;
                                    [wself setNeedsLayout];
                                }
                            });
                        });
                    }
                    else {
                        if (animated) {
                            CATransition *animation = [CATransition animation];
                            animation.delegate = self;
                            animation.duration = .35;
                            animation.timingFunction = UIViewAnimationCurveEaseInOut;
                            animation.type = kCATransitionFade;
                            wself.image = tempImage?tempImage:image;
                            [wself setNeedsLayout];
                            [[wself layer] addAnimation:animation forKey:@"animation"];
                        }
                        else {
                            wself.image = tempImage?tempImage:image;
                            [wself setNeedsLayout];
                        }
                    }
                  
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (NSURL *)tf_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)tf_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self tf_cancelCurrentAnimationImagesLoad];
    __weak UIImageView *wself = self;
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];
                    
                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }
    
    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)tf_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)tf_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

- (UIImage *)scaleImageFocusingOnRect:(CGRect) facesRect image:(UIImage *)image {
    CGFloat multi1 = self.frame.size.width / image.size.width;
    CGFloat multi2 = self.frame.size.height / image.size.height;
    CGFloat multi = MAX(multi1, multi2);
    
    //We need to 'flip' the Y coordinate to make it match the iOS coordinate system one
    facesRect.origin.y = image.size.height - facesRect.origin.y - facesRect.size.height;
    
    facesRect = CGRectMake(facesRect.origin.x*multi, facesRect.origin.y*multi, facesRect.size.width*multi, facesRect.size.height*multi);
    
    CGRect imageRect = CGRectZero;
    imageRect.size.width = image.size.width * multi;
    imageRect.size.height = image.size.height * multi;
    imageRect.origin.x = MIN(0.0, MAX(-facesRect.origin.x + self.frame.size.width/2.0 - facesRect.size.width/2.0, -imageRect.size.width + self.frame.size.width));
    imageRect.origin.y = MIN(0.0, MAX(-facesRect.origin.y + self.frame.size.height/2.0 -facesRect.size.height/2.0, -imageRect.size.height + self.frame.size.height));
    
    imageRect = CGRectIntegral(imageRect);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 2.0);
    [image drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
//    NSInteger theRedRectangleTag = -3312;
//    UIView* facesRectLine = [self viewWithTag:theRedRectangleTag];
//    if (!facesRectLine) {
//        facesRectLine = [[UIView alloc] initWithFrame:facesRect];
//        facesRectLine.tag = theRedRectangleTag;
//    }
//    else {
//        facesRectLine.frame = facesRect;
//    }
//    
//    facesRectLine.backgroundColor = [UIColor clearColor];
//    facesRectLine.layer.borderColor = [UIColor redColor].CGColor;
//    facesRectLine.layer.borderWidth = 1;
//    
//    CGRect frame = facesRectLine.frame;
//    frame.origin.x = imageRect.origin.x + frame.origin.x;
//    frame.origin.y = imageRect.origin.y + frame.origin.y;
//    facesRectLine.frame = frame;
//    
//    [self addSubview:facesRectLine];
    
    return newImage;
}

@end
