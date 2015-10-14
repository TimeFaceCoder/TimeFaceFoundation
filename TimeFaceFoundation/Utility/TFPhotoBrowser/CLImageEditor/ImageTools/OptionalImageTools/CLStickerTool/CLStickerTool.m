//
//  CLStickerTool.m
//
//  Created by sho yakushiji on 2013/12/11.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLStickerTool.h"

#import "CLCircleView.h"

#import "ALAssetsLibrary+TFPhotoAlbum.h"

#import "TFStickerView.h"

static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";

@interface _CLStickerView : UIView
+ (void)setActiveStickerView:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (void)setScale:(CGFloat)scale;
@end


@interface CLStickerTool()<TFStickerViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation CLStickerTool
{
    UIImage         *_originalImage;
    
    UIView          *_workingView;
    
    TFStickerView   *_stickerView;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return nil;
    return [CLImageEditorTheme localizedString:@"CLStickerTool_DefaultTitle" withDefault:@"Sticker"];
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (BOOL)isAvailable
{
    return YES;
}

#pragma mark- optional info

+ (NSString*)defaultStickerPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLStickerToolStickerPathKey:[self defaultStickerPath],
             kCLStickerToolDeleteIconName:@"",
             };
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame
                                                                      fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    UITapGestureRecognizer *viewTapClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(viewTapClick:)];
    [_workingView addGestureRecognizer:viewTapClick];
    viewTapClick.delegate = self;
    for (UIView *view in self.editor.view.subviews) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            [self.editor.view insertSubview:_workingView belowSubview:view];
        }
    }

    _stickerView = [[TFStickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(TTScreenBounds()), CGRectGetWidth(TTScreenBounds()), CGRectGetHeight(TTScreenBounds())/4 + 20)];
    _stickerView.delegate = self;
    [self.editor.view addSubview:_stickerView];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _stickerView.top = CGRectGetHeight(TTScreenBounds())  - _stickerView.height;
                     }];
}

- (void)viewTapClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self.editor toggleControls];
}

- (void)cleanup
{    
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _stickerView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_stickerView.top);
                     }
                     completion:^(BOOL finished) {
                         [_stickerView removeFromSuperview];
                     }];
}

- (BOOL)handleSingleTap {
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _stickerView.top = CGRectGetHeight(TTScreenBounds()) - 40;
                         [_stickerView updateArrowState:YES];
                     }
     ];
    if ([_workingView.subviews count] > 0) {
        return YES;
    }
    return NO;
}


- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLStickerView setActiveStickerView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

- (void)executeOriginalImage:(NSURL *)URL completionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock {
    [_CLStickerView setActiveStickerView:nil];
    
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
                    
                    UIImage *image = [self buildImage:result];
                    
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
                                                   //删除原有图片
//                                                   [asset setImageData:NULL metadata:NULL completionBlock:NULL];
                                                   completionBlock(fullImage, nil, @{@"URL":[assetRepresentation url]});
                                               });
                                           }
                                       }];
                    inProgress = NO;
                });
                
                
            }
            else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [self buildImage:_originalImage];
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
                                                   completionBlock(fullImage, nil, @{@"URL":[assetRepresentation url]});
                                               });
                                           }
                                       }];
                });
            }
            
            
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [self buildImage:_originalImage];
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
                                               completionBlock(fullImage, nil, @{@"URL":[assetRepresentation url]});
                                           });
                                       }
                                   }];
            });
        }];
    }
}


#pragma mark-
- (void)didStickerSelected:(NSString *)stickerPath {
    
    if(stickerPath){
        _CLStickerView *view = [[_CLStickerView alloc] initWithImage:[UIImage imageWithContentsOfFile:stickerPath]
                                                                tool:self];
        CGFloat ratio = MIN( (0.3 * _workingView.width) / view.width, (0.3 * _workingView.height) / view.height);
        [view setScale:ratio];
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        
        [_workingView addSubview:view];
        [_CLStickerView setActiveStickerView:view];
    }
}

- (void)didStickerClose:(BOOL)close {
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _stickerView.top = CGRectGetHeight(TTScreenBounds()) - (close?_stickerView.height:40);
                     }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect toolFrame = CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()), 44);
    CGPoint point = [touch locationInView:_workingView];
    if (CGRectContainsPoint(toolFrame, point)) {
        return NO;
    }
    return YES; // handle the touch
    
}


- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end


@implementation _CLStickerView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveStickerView:(_CLStickerView*)view
{
    static _CLStickerView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
        [_deleteButton setImage:[tool imageForKey:kCLStickerToolDeleteIconName defaultImageName:@"btn_delete.png"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor blackColor];
        _circleView.borderWidth = 5;
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLStickerView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLStickerView class]]){
            nextTarget = (_CLStickerView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLStickerView class]]){
                nextTarget = (_CLStickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)setScale:(CGFloat)scale
{
    if (scale >= 2.5) {
        return;
    }
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

@end
