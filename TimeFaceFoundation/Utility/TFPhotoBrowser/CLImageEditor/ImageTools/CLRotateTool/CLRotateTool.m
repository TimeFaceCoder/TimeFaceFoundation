//
//  CLRotateTool.m
//
//  Created by sho yakushiji on 2013/11/08.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLRotateTool.h"
#import "ALAssetsLibrary+TFPhotoAlbum.h"

static NSString* const kCLRotateToolRotateIconName = @"rotateIconAssetsName";
static NSString* const kCLRotateToolFlipHorizontalIconName = @"flipHorizontalIconAssetsName";
static NSString* const kCLRotateToolFlipVerticalIconName = @"flipVerticalIconAssetsName";

@interface CLRotatePanel : UIView
@property(nonatomic, assign) CGRect gridRect;
- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;
@end



@implementation CLRotateTool
{
    CGRect _initialRect;
    
    CGFloat rotateValue;
    
    BOOL _executed;
    
    UIImageView *_rotateImageView;
    
    NSInteger _flipState1;
    
    NSInteger _flipState2;
    
    UIView *_workingView;
    
    UIScrollView *_menuScroll;
    
}

+ (NSString*)defaultTitle
{
    return nil;
    return [CLImageEditorTheme localizedString:@"CLRotateTool_DefaultTitle" withDefault:@"Rotate"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 3;
}
#pragma mark- optional info

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLRotateToolRotateIconName : @"",
             kCLRotateToolFlipHorizontalIconName : @"",
             kCLRotateToolFlipVerticalIconName : @""
             };
}

#pragma mark-

- (void)setup
{
    
    _executed = NO;
    
    _initialRect = self.editor.imageView.bounds;
    
    rotateValue = 0;
    
    _flipState1 = 0;
    _flipState2 = 0;
    
    _workingView = [[UIView alloc] initWithFrame:self.editor.imageView.frame];
    _workingView.backgroundColor = [UIColor clearColor];
    _workingView.clipsToBounds = NO;
    
    UITapGestureRecognizer *viewTapClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(viewTapClick:)];
    viewTapClick.delaysTouchesBegan = YES;
    [_workingView addGestureRecognizer:viewTapClick];
    [self.editor.view insertSubview:_workingView
                       aboveSubview:self.editor.imageView.superview.superview];

    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    [self setMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         _rotateImageView = [[UIImageView alloc] initWithFrame:_workingView.bounds];
                         _rotateImageView.image = [self.editor.imageView.image resize:CGSizeMake(self.editor.imageView.width*2, self.editor.imageView.height*2)];
                         [_workingView addSubview:_rotateImageView];
                         self.editor.imageView.hidden = YES;
                     }];
}


- (void)viewTapClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self.editor toggleControls];
}

- (void)cleanup
{
    if(_executed){
        _rotateImageView.transform = CGAffineTransformIdentity;
        _rotateImageView.frame = _workingView.bounds;
        _rotateImageView.image = self.editor.imageView.image;
    }
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                         _rotateImageView.transform = CGAffineTransformIdentity;
                         _rotateImageView.frame = _workingView.bounds;

                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
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
        UIImage *image = [self buildImage:self.editor.imageView.image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _executed = YES;
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setMenu
{
    CGFloat W = 46;
    
    CGFloat H = 46;
    
    CGFloat x = 0;
	
    NSArray *_menu = @[
                       @{@"title":@"",
                         @"icon":[UIImage imageNamed:@"ImageEditorRotate"],
                         @"iconH":[UIImage imageNamed:@"ImageEditorRotateH"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, (_menuScroll.height - H)/2, W, H)
                                                                 target:self
                                                                 action:@selector(tappedMenu:) toolInfo:nil];
        view.tag = tag++;
        view.iconImage = obj[@"icon"];
        view.iconImageH = obj[@"iconH"];
        view.title = obj[@"title"];
        
        [_menuScroll addSubview:view];
        x += W + 12;
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(containerLongPress:)];
    longPress.delaysTouchesBegan = YES;
    longPress.minimumPressDuration = 2.5;
    [_menuScroll addGestureRecognizer:longPress];
}


- (void)containerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    [_menuScroll removeAllSubviews];
    CGFloat W = 46;
    CGFloat H = 46;
    CGFloat x = 0;
    NSArray *_menu = @[
                       @{@"title":@"",
                         @"icon":[UIImage imageNamed:@"ImageEditorRotate"],
                         @"iconH":[UIImage imageNamed:@"ImageEditorRotateH"]},
                       
                                              @{@"title":@"",
                                                @"icon":[UIImage imageNamed:@"RotateHorizontal"],
                                                @"iconH":[UIImage imageNamed:@"RotateHorizontalH"]},
                       
                                              @{@"title":@"",
                                                @"icon":[UIImage imageNamed:@"RotateVertical"],
                                                @"iconH":[UIImage imageNamed:@"RotateVerticalH"]},
                       ];
    
    NSInteger tag = 0;
    for(NSDictionary *obj in _menu){
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, (_menuScroll.height - H)/2, W, H)
                                                                 target:self
                                                                 action:@selector(tappedMenu:) toolInfo:nil];
        view.tag = tag++;
        view.iconImage = obj[@"icon"];
        view.iconImageH = obj[@"iconH"];
        view.title = obj[@"title"];
        
        [_menuScroll addSubview:view];
        x += W + 12;
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);

}


- (void)tappedMenu:(UITapGestureRecognizer*)sender
{
    sender.view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         sender.view.alpha = 1;
                     }
     ];
    
    switch (sender.view.tag) {
        case 0:
        {
            CGFloat value = (int)floorf((rotateValue + 1)*2) + 1;
            if(value>4){ value -= 4; }
            rotateValue = value / 2 - 1;
            break;
        }
        case 1:
            _flipState1 = (_flipState1==0) ? 1 : 0;
            break;
        case 2:
            _flipState2 = (_flipState2==0) ? 1 : 0;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         [self rotateStateDidChange];
                     }
                     completion:^(BOOL finished) {
//                        _gridView.hidden = NO;
                     }
     ];
}


- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise
{
    CGFloat arg = rotateValue*M_PI;
    if(!clockwise){
        arg *= -1;
    }
    
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    transform = CATransform3DRotate(transform, _flipState1*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, _flipState2*M_PI, 1, 0, 0);
    
    return transform;
}

- (void)rotateStateDidChange
{
    CATransform3D transform = [self rotateTransform:CATransform3DIdentity clockwise:YES];
    
    CGFloat arg = rotateValue*M_PI;
    CGFloat Wnew = fabs(_initialRect.size.width * cos(arg)) + fabs(_initialRect.size.height * sin(arg));
    CGFloat Hnew = fabs(_initialRect.size.width * sin(arg)) + fabs(_initialRect.size.height * cos(arg));
    
    CGFloat Rw = _initialRect.size.width / Wnew;
    CGFloat Rh = _initialRect.size.height / Hnew;
    CGFloat scale = MIN(Rw, Rh) * 1;
    
    transform = CATransform3DScale(transform, scale, scale, 1);
    
    _rotateImageView.layer.transform = transform;
    
//    _workingView.frame = _rotateImageView.frame;
}

- (UIImage*)buildImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    CGAffineTransform transform = CATransform3DGetAffineTransform([self rotateTransform:CATransform3DIdentity clockwise:NO]);
    [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}
@end

@implementation CLRotatePanel

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame
{
    self = [super initWithFrame:superview.bounds];
    if(self){
        self.gridRect = frame;
        [superview addSubview:self];
    }
    return self;
}

- (void)setGridRect:(CGRect)gridRect
{
    _gridRect = gridRect;
    [self setNeedsDisplay];
}
@end
