//
//  TFCameraViewCollectionViewCell.m
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFCameraViewCollectionViewCell.h"
#import <GPUImage/GPUImage.h>

@interface TFCameraViewCollectionViewCell() {
    GPUImageVideoCamera     *_videoCamera;
    GPUImageiOSBlurFilter   *_filter;
}

@property (nonatomic ,strong) GPUImageView          *primaryView;

@end



@implementation TFCameraViewCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LibraryOpenCamera"]];
        imageView.center = self.contentView.center;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)startCamera {
    BOOL iPhone4 = CGRectGetHeight(TTScreenBounds()) < 500;
    if (iPhone4) {
        return;
    }

    if (!_primaryView) {
        _primaryView = [[GPUImageView alloc] initWithFrame:self.bounds];
        _primaryView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [self.contentView insertSubview:_primaryView atIndex:0];
    }
    
    
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset352x288
                                                          cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIDeviceOrientationPortrait;
        if (!_filter) {
             _filter = [[GPUImageiOSBlurFilter  alloc] init];
            _filter.blurRadiusInPixels = 2;
            [_filter addTarget:_primaryView];
            [_videoCamera addTarget:_filter];
        }
        [_videoCamera startCameraCapture];
    }
}

- (void)removeCamera {
    if (_videoCamera) {
        [_videoCamera stopCameraCapture];
        _videoCamera = nil;
    }
    if (_filter) {
        [_filter removeAllTargets];
        _filter = nil;
    }
}


@end
