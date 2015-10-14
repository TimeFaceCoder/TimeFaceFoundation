//
//  CLAdjustmentTool.m
//
//  Created by sho yakushiji on 2013/10/23.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLAdjustmentTool.h"
#import "ALAssetsLibrary+TFPhotoAlbum.h"

static NSString* const kCLAdjustmentToolSaturationIconName = @"saturationIconAssetsName";
static NSString* const kCLAdjustmentToolBrightnessIconName = @"brightnessIconAssetsName";
static NSString* const kCLAdjustmentToolContrastIconName = @"contrastIconAssetsName";

static CGFloat   const kSliderContainerHeight = 120.0f;

@implementation CLAdjustmentTool
{
    UIImage *_originalImage;
    
    CGRect _initialRect;

    //亮度滑块
    UISlider *_brightnessSlider;
    //饱和度
    UISlider *_saturationSlider;
    //对比度滑块
    UISlider *_contrastSlider;
    
    UIView   *_sliderContainer;
    
    UIView   *_workingView;
    
    UIImageView *_adjustmentImageView;
    
    BOOL _executed;
}

+ (NSString*)defaultTitle
{
    return nil;
    return [CLImageEditorTheme localizedString:@"CLAdjustmentTool_DefaultTitle" withDefault:@"Adjustment"];
}

+ (BOOL)isAvailable
{
    return YES;
}


+ (CGFloat)defaultDockedNumber
{
    return 1;
}

- (void)setup
{
    _initialRect = self.editor.imageView.frame;

    _workingView = [[UIView alloc] initWithFrame:_initialRect];
    _workingView.backgroundColor = [UIColor clearColor];
    _workingView.clipsToBounds = NO;
    
    UITapGestureRecognizer *viewTapClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(viewTapClick:)];
    viewTapClick.delaysTouchesBegan = YES;
    [_workingView addGestureRecognizer:viewTapClick];
    
    [self.editor.view insertSubview:_workingView
                       aboveSubview:self.editor.imageView.superview.superview];
    
    
    _sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.height - 48, self.editor.view.width, kSliderContainerHeight)];
    _sliderContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    _sliderContainer.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view addSubview:_sliderContainer];

    [self setupSlider];
    
    _sliderContainer.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_sliderContainer.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _sliderContainer.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished)
     {
         
         _adjustmentImageView = [[UIImageView alloc] initWithFrame:_workingView.bounds];
         _adjustmentImageView.image = [self.editor.imageView.image resize:CGSizeMake(self.editor.imageView.width*2, self.editor.imageView.height*2)];
         _originalImage = _adjustmentImageView.image;
         [_workingView addSubview:_adjustmentImageView];
         self.editor.imageView.hidden = YES;
     }];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(containerLongPress:)];
    longPress.delaysTouchesBegan = YES;
    longPress.minimumPressDuration = 2.5;
    [_sliderContainer addGestureRecognizer:longPress];
}

- (void)containerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:.35 animations:^{
        _sliderContainer.top = self.editor.view.height - kSliderContainerHeight;
    }];
}


- (void)viewTapClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self.editor toggleControls];
}

- (void)cleanup
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _sliderContainer.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_sliderContainer.top);
                     }
                     completion:^(BOOL finished) {
                         [_sliderContainer removeFromSuperview];
                         [_workingView removeFromSuperview];
                         self.editor.imageView.hidden = NO;
                     }];
}

- (void)executeOriginalImage:(NSURL *)URL completionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock {
    
    @autoreleasepool {
        [[DBLibraryManager sharedInstance] fixAssetForURL:URL
                                                            resultBlock:^(ALAsset *asset)
         {
             
             if (asset) {
                 static BOOL inProgress = NO;
                 if(inProgress){ return; }
                 inProgress = YES;
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                     UIImage *result = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]
                                                           scale:[assetRepresentation scale]
                                                     orientation:(UIImageOrientation)[assetRepresentation orientation]];
                     UIImage *image = [self filteredImage:result];
                     //保存文件到timeface相册
                     [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] saveImage:image
                                                    toAlbum:NSLocalizedString(@"时光流影", nil)
                                        withCompletionBlock:^(id assetURL, NSError *error) {
                                            if ([assetURL isKindOfClass:[NSURL class]]) {
                                                //暂不返回URL
                                            }
                                            if ([assetURL isKindOfClass:[ALAsset class]]) {
                                                ALAssetRepresentation *assetRepresentation = [assetURL defaultRepresentation];
                                                UIImage *fullImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                                                [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:fullImage waitUntilDone:NO];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    _executed = YES;
                                                    //删除原有图片
                                                    [asset setImageData:NULL metadata:NULL completionBlock:NULL];
                                                    completionBlock(fullImage, nil, @{@"URL":[assetRepresentation url]});
                                                });
                                            }
                                        }];
                     inProgress = NO;
                 });
                 
             }
             else {
                 
             }
             
         } failureBlock:^(NSError *error) {
             
         }];
    }
}


- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_adjustmentImageView.image];
        dispatch_async(dispatch_get_main_queue(), ^{
            _executed = YES;
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark- optional info

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLAdjustmentToolSaturationIconName : @"",
             kCLAdjustmentToolBrightnessIconName : @"",
             kCLAdjustmentToolContrastIconName : @""
             };
}

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    [label sizeToFit];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 240, 24)];
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sliderContainer.width, slider.height)];
//    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    container.layer.cornerRadius = slider.height/2;
    label.left = VIEW_LEFT_SPACE;
    label.top = (container.height - label.height)/2;
    [container addSubview:label];
    
    slider.left = label.right + VIEW_LEFT_SPACE;
    slider.top = (container.height - slider.height)/2;
    slider.width = container.width - slider.left - VIEW_LEFT_SPACE;
    
    [container addSubview:slider];
    
    
    [_sliderContainer addSubview:container];
    
    return slider;
}

- (void)setIconForSlider:(UISlider*)slider withKey:(NSString*)key defaultIconName:(NSString*)defaultIconName
{
//    UIImage *icon = [self imageForKey:key defaultImageName:defaultIconName];
    UIImage *icon = [UIImage imageNamed:defaultIconName];
    [slider setThumbImage:icon forState:UIControlStateNormal];
    [slider setThumbImage:icon forState:UIControlStateHighlighted];
}

- (void)setupSlider
{
    //亮度滑块
    _brightnessSlider = [self sliderWithValue:0
                                 minimumValue:-1
                                 maximumValue:1
                                       action:@selector(sliderDidChange:)
                                        title:NSLocalizedString(@"亮度", nil)];
    _brightnessSlider.superview.top = VIEW_LEFT_SPACE;
    _brightnessSlider.superview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self setIconForSlider:_brightnessSlider withKey:kCLAdjustmentToolBrightnessIconName defaultIconName:@"ImageEditorSliderIcon"];
    
    //饱和度
    _saturationSlider = [self sliderWithValue:1
                                 minimumValue:0
                                 maximumValue:2
                                       action:@selector(sliderDidChange:)
                                        title:NSLocalizedString(@"饱和度", nil)];
    _saturationSlider.superview.top = _brightnessSlider.superview.bottom + VIEW_LEFT_SPACE;
    _saturationSlider.superview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self setIconForSlider:_saturationSlider withKey:kCLAdjustmentToolSaturationIconName defaultIconName:@"ImageEditorSliderIcon"];

    
    //对比度
    _contrastSlider = [self sliderWithValue:1
                               minimumValue:0.5
                               maximumValue:1.5
                                     action:@selector(sliderDidChange:)
                                      title:NSLocalizedString(@"对比度", nil)];
    _contrastSlider.superview.top = _saturationSlider.superview.bottom + VIEW_LEFT_SPACE;
    _contrastSlider.superview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self setIconForSlider:_contrastSlider withKey:kCLAdjustmentToolContrastIconName defaultIconName:@"ImageEditorSliderIcon"];

}

- (void)sliderDidChange:(UISlider*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage];
        [_adjustmentImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image
{
    UIImageOrientation originalOrientation = image.imageOrientation;
    CGFloat originalScale = image.scale;
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_saturationSlider.value] forKey:@"inputSaturation"];
    
    filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat brightness = 2*_brightnessSlider.value;
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = _contrastSlider.value*_contrastSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage scale:originalScale orientation:originalOrientation];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end
