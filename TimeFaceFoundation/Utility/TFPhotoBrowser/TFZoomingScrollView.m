//
//  TFZoomingScrollView.m
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFZoomingScrollView.h"
#import <AVFoundation/AVFoundation.h>
#import "TFPhoto.h"
#import "TFPhotoBrowser.h"
#import "TFTapDetectingView.h"
#import "TFTapDetectingImageView.h"
#import "DACircularProgressView.h"
#import "UIImageView+FaceAwareFill.h"
#import "TFPhotoTagView.h"

@interface TFZoomingScrollView()<UIGestureRecognizerDelegate,UIScrollViewDelegate,TFTapDetectingViewDelegate,TFTapDetectingImageViewDelegate> {
    TFPhotoBrowser __weak *_photoBrowser;
    TFTapDetectingView *_tapView; // for background taps
    DACircularProgressView *_loadingIndicator;
    UIImageView *_loadingError;
}

@end

@implementation TFZoomingScrollView

- (id)initWithPhotoBrowser:(TFPhotoBrowser *)browser {
    if ((self = [super init])) {
        
        // Setup
        _index = NSUIntegerMax;
        _photoBrowser = browser;
        
        // Tap view for background
        _tapView = [[TFTapDetectingView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapView.backgroundColor = [UIColor blackColor];
        [self addSubview:_tapView];
        
        // Image view
        _photoImageView = [[TFTapDetectingImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.tapDelegate = self;
        _photoImageView.contentMode = UIViewContentModeCenter;
        _photoImageView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_photoImageView];
        
        
        // Loading indicator
        _loadingIndicator = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
        _loadingIndicator.userInteractionEnabled = NO;
        _loadingIndicator.thicknessRatio = 0.1;
        _loadingIndicator.roundedCorners = NO;
        
        _loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_loadingIndicator];
        
        // Listen progress notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setProgressFromNotification:)
                                                     name:NOTICE_TFPHOTO_PROGRESS
                                                   object:nil];
        
        // Setup
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        
        UILongPressGestureRecognizer *imageLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(handleLongTap:)];
        imageLongTap.delegate = self;
        [self addGestureRecognizer:imageLongTap];
        
        
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [[UIColor redColor] CGColor];
        
        
//        _photoImageView.layer.borderWidth = 1;
//        _photoImageView.layer.borderColor = [[UIColor blueColor] CGColor];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForReuse {
    [self hideImageFailure];
    self.photo = nil;
    _photoImageView.image = nil;
    _index = NSUIntegerMax;
    [self removeAllTags];
}

#pragma mark - Image


- (void)updatePagePhoto:(id<TFPhoto>)photo {
    if (_photo && photo == nil) {
        if ([_photo respondsToSelector:@selector(cancelAnyLoading)]) {
            [_photo cancelAnyLoading];
        }
    }
    _photo = photo;
}

- (void)setPhoto:(id<TFPhoto>)photo {
    // Cancel any loading on old photo
    if (_photo && photo == nil) {
        if ([_photo respondsToSelector:@selector(cancelAnyLoading)]) {
            [_photo cancelAnyLoading];
        }
    }
    _photo = photo;
    UIImage *img = [_photoBrowser imageForPhoto:_photo];
    if (img) {
        [self displayImageWithDoneBlock:^{
            
        }];
    } else {
        // Will be loading so show loading
        [self showLoadingIndicator];
    }
}

// Get and display image
- (void)displayImageWithDoneBlock:(void (^)(void))doneBlock {
    if (_photo && _photoImageView.image == nil) {
        // Reset
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeMake(0, 0);
        
        // Get image from browser as it handles ordering of fetching
        UIImage *img = [_photoBrowser imageForPhoto:_photo];
        if (img) {
            
            // Hide indicator
            [self hideLoadingIndicator];
            
            // Set image
            _photoImageView.image = img;
            _photoImageView.hidden = NO;
            
            // Setup photo frame
            CGRect photoImageViewFrame;
            photoImageViewFrame.origin = CGPointZero;
            photoImageViewFrame.size = img.size;
            _photoImageView.frame = photoImageViewFrame;
            self.contentSize = photoImageViewFrame.size;
            
            // Set zoom to minimum zoom
            [self setMaxMinZoomScalesForCurrentBounds];
            //识别人脸
            [self faceFeature];
            if (doneBlock) {
                doneBlock();
            }
        } else {
            // Failed no image
            [self displayImageFailure];
        }
        [self setNeedsLayout];
    }
}

// Image failed so just show black!
- (void)displayImageFailure {
    [self hideLoadingIndicator];
    _photoImageView.image = nil;
    if (!_loadingError) {
        _loadingError = [UIImageView new];
        _loadingError.image = [UIImage imageNamed:@"CellImageDefault"];
        _loadingError.userInteractionEnabled = NO;
        _loadingError.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [_loadingError sizeToFit];
        [self addSubview:_loadingError];
    }
    _loadingError.frame = CGRectMake(floorf((self.bounds.size.width - _loadingError.frame.size.width) / 2.),
                                     floorf((self.bounds.size.height - _loadingError.frame.size.height) / 2),
                                     _loadingError.frame.size.width,
                                     _loadingError.frame.size.height);
}

- (void)imageRest {
//    [self handleDoubleTap:_tapView.center];
    [self setZoomScale:self.minimumZoomScale animated:YES];

}

- (void)removeAllTags {
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[TFPhotoTagView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)hideImageFailure {
    if (_loadingError) {
        [_loadingError removeFromSuperview];
        _loadingError = nil;
    }
}

#pragma mark - Loading Progress

- (void)setProgressFromNotification:(NSNotification *)notification {
    NSDictionary *dict = [notification object];
    id <TFPhoto> photoWithProgress = [dict objectForKey:@"photo"];
    if (photoWithProgress == self.photo) {
        float progress = [[dict valueForKey:@"progress"] floatValue];
        _loadingIndicator.progress = MAX(MIN(1, progress), 0);
    }
}

- (void)hideLoadingIndicator {
    _loadingIndicator.hidden = YES;
}

- (void)showLoadingIndicator {
    self.zoomScale = 0;
    self.minimumZoomScale = 0;
    self.maximumZoomScale = 0;
    _loadingIndicator.progress = 0;
    _loadingIndicator.hidden = NO;
    [self hideImageFailure];
}

#pragma mark - Setup

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView && _photoBrowser.zoomPhotosToFill) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_photoImageView.image == nil) return;
    
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
    CGFloat maxScale = 1.5;
    if (imageSize.height < imageSize.width) {
        //横幅图片
        
    }
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }
    
    // Layout
    [self setNeedsLayout];
    
}

- (void)faceFeature {
    if (!_faceFeatures) {
        _faceFeatures = [NSMutableArray array];
    }
    [_faceFeatures removeAllObjects];
//    if ([_faceFeatures count] > 0)
//        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            CIImage *ciImage = _photoImageView.image.CIImage;
            if (!ciImage) {
                ciImage = [CIImage imageWithCGImage:_photoImageView.image.CGImage];
            }
            CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                      context:nil
                                                      options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            CGSize inputImageSize = ciImage.extent.size;
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformScale(transform, 1, -1);
            transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
            
            NSArray* features = [detector featuresInImage:ciImage];
            if (features.count > 0) {
                for (CIFaceFeature* faceFeature in features) {
                    CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
                    CGFloat scale = MIN(_photoImageView.bounds.size.width / inputImageSize.width,
                                        _photoImageView.bounds.size.height / inputImageSize.height);
                    CGFloat offsetX = (_photoImageView.bounds.size.width - inputImageSize.width * scale) / 2;
                    CGFloat offsetY = (_photoImageView.bounds.size.height - inputImageSize.height * scale) / 2;
                    
                    faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale));
                    faceViewBounds.origin.x += offsetX;
                    faceViewBounds.origin.y += offsetY;


                    CGPoint faceCenter = CGPointMake(faceViewBounds.origin.x + faceViewBounds.size.width/2, faceViewBounds.origin.y + faceViewBounds.size.height / 2);
                    TFLog(@"features:%@",NSStringFromCGRect(faceViewBounds));
                    TFLog(@"features center:%@",NSStringFromCGPoint(faceCenter));
                    if (faceViewBounds.size.width > 0 && faceViewBounds.size.height > 0) {
                        [_faceFeatures addObject:NSStringFromCGRect(faceViewBounds)];
                    }
                }
                
                dispatch_main_sync_safe(^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_TFPHOTO_ENDFACELOADING
                                                                        object:nil];
                });
            }
        }
    });
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    // Update tap view frame
    _tapView.frame = self.bounds;
    
    // Position indicators (centre does not seem to work!)
    if (!_loadingIndicator.hidden)
        _loadingIndicator.frame = CGRectMake(floorf((self.bounds.size.width - _loadingIndicator.frame.size.width) / 2.),
                                             floorf((self.bounds.size.height - _loadingIndicator.frame.size.height) / 2),
                                             _loadingIndicator.frame.size.width,
                                             _loadingIndicator.frame.size.height);
    if (_loadingError)
        _loadingError.frame = CGRectMake(floorf((self.bounds.size.width - _loadingError.frame.size.width) / 2.),
                                         floorf((self.bounds.size.height - _loadingError.frame.size.height) / 2),
                                         _loadingError.frame.size.width,
                                         _loadingError.frame.size.height);
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES; // reset

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
    [_photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Cancel any single tap handling
    [NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)handleLongTap:(UILongPressGestureRecognizer *)gestureRecognizer {
    if(_photoImageView.image == nil){
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pointOnImage = [gestureRecognizer locationInView:_photoImageView];
        
        CGPoint screenTouchPoint = [gestureRecognizer locationInView:self];
        if (!CGRectContainsPoint(_photoImageView.frame, screenTouchPoint))
            return;
        NSDictionary *touchInfo =
        @{@"pointOnImage":[NSValue valueWithCGPoint:pointOnImage]};
        [_photoBrowser performSelector:@selector(longTapOnView:) withObject:touchInfo afterDelay:0.2];
    }
}


- (void)startNewTagPopover:(TFPhotoTagView *)popover
         atNormalizedPoint:(CGPoint)normalizedPoint
              pointOnImage:(CGPoint)pointOnImage
{
//    NSAssert(((normalizedPoint.x >= 0.0 && normalizedPoint.x <= 1.0) &&
//              (normalizedPoint.y >= 0.0 && normalizedPoint.y <= 1.0)),
//             @"Point is outside of photo.");
    
    CGRect photoFrame = [self frameForImage];
    
    CGPoint tagLocation =
    CGPointMake(photoFrame.origin.x + (photoFrame.size.width * normalizedPoint.x),
                photoFrame.origin.y + (photoFrame.size.height * normalizedPoint.y));
    
    [popover presentPopoverFromPoint:tagLocation inView:self animated:YES];
    [popover setNormalizedArrowPoint:normalizedPoint];
    [popover setPointOnImage:pointOnImage];
    if (!popover.text.length) {
        [popover becomeFirstResponder];
    }
}

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleSingleTap:CGPointMake(touchX, touchY)];
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}



- (BOOL)canTagPhotoAtNormalizedPoint:(CGPoint)normalizedPoint
{
    if((normalizedPoint.x >= 0.0 && normalizedPoint.x <= 1.0) &&
       (normalizedPoint.y >= 0.0 && normalizedPoint.y <= 1.0)){
        return YES;
    }
    return NO;
}


- (CGPoint)normalizedPositionForPoint:(CGPoint)point {
    return   [self normalizedPositionForPoint:point inFrame:[self frameForImage]];
}

- (CGPoint)normalizedPositionForPoint:(CGPoint)point inFrame:(CGRect)frame
{
    CGFloat startX = self.frame.origin.x;
    if (startX > 10) {
        startX = 10;
    }
    point.x -= (frame.origin.x - startX);
    point.y -= (frame.origin.y - self.frame.origin.y);
    
    CGPoint normalizedPoint = CGPointMake(point.x / frame.size.width,
                                          point.y / frame.size.height);
    
    return normalizedPoint;
}


- (CGRect)frameForImage
{
    if(_photoImageView.image == nil){
        return CGRectZero;
    }
//    return _photoImageView.frame;
    
    
    TFLog(@"image frame:%@",NSStringFromCGRect(_photoImageView.frame));
    TFLog(@"image bounds:%@",NSStringFromCGRect(_photoImageView.bounds));
    
    CGRect photoDisplayedFrame;
    if(_photoImageView.contentMode == UIViewContentModeScaleAspectFit){
        photoDisplayedFrame = AVMakeRectWithAspectRatioInsideRect(_photoImageView.image.size, _photoImageView.frame);
    } else if(_photoImageView.contentMode == UIViewContentModeCenter) {
        CGPoint photoOrigin = CGPointZero;
        photoOrigin.x = (_photoImageView.frame.size.width - (_photoImageView.image.size.width * self.zoomScale)) * 0.5;
        photoOrigin.y = (_photoImageView.frame.size.height - (_photoImageView.image.size.height * self.zoomScale)) * 0.5;
        photoDisplayedFrame = CGRectMake(photoOrigin.x,
                                         photoOrigin.y,
                                         _photoImageView.image.size.width*self.zoomScale,
                                         _photoImageView.image.size.height*self.zoomScale);
    } else {
        NSAssert(0, @"Don't know how to generate frame for photo with current content mode.");
    }
    
    return photoDisplayedFrame;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer numberOfTouches] > 1) {
        return YES;
    }
    return NO;
}

@end
