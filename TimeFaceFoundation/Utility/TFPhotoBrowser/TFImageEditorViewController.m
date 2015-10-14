//
//  TFImageEditorViewController.m
//  TimeFaceV2
//
//  Created by Melvin on 1/28/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFImageEditorViewController.h"
#import "DBLibraryManager.h"
#import <pop/POP.h>

@interface TFImageEditorViewController ()<UIScrollViewDelegate> {
    UIImage *_originalImage;
    NSURL   *_originalUrl;
    
    UIToolbar *_toolbar;
    UIBarButtonItem *_cancelButton,*_saveButton,*_filterButton,*_stickerButton,*_cropButton,*_depthButton,*_gloButton;
}

@end

const static NSInteger    kCancelButtonTag  = 100;
const static NSInteger    kSaveButtonTag    = 101;
const static NSInteger    kFilterButtonTag  = 102;
const static NSInteger    kStickerButtonTag = 103;
const static NSInteger    kCropButtonTag    = 104;
const static NSInteger    kDepthButtonTag   = 105;
const static NSInteger    kGloButtonTag     = 106;

@implementation TFImageEditorViewController


- (id)initWithImage:(UIImage*)image delegate:(id<TFImageEditorViewControllerDelegate>)delegate {
    if ((self = [self init])) {
        _originalImage = image;
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithURL:(NSURL*)url delegate:(id<TFImageEditorViewControllerDelegate>)delegate {
    if ((self = [self init])) {
        _originalUrl = url;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self initImageScrollView];
    
//    [self setMenuView];
    
    if(_imageView==nil){
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
        [self refreshImageView];
    }
    
    //tool bar
    _toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation:self.interfaceOrientation]];
    _toolbar.tintColor = nil;
    if ([_toolbar respondsToSelector:@selector(setBarTintColor:)]) {
        _toolbar.barTintColor = nil;
    }
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    }
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    // Toolbar Items
    _cancelButton = [self createBarButtonItem:@"ImageEditorCancel" imagePressed:@"ImageEditorCancel" tag:kCancelButtonTag];
    
    _filterButton = [self createBarButtonItem:@"ImageEditorFilter" imagePressed:@"ImageEditorFilter" tag:kFilterButtonTag];
    
    _filterButton = [self createBarButtonItem:@"ImageEditorFilter" imagePressed:@"ImageEditorFilter" tag:kFilterButtonTag];
    _stickerButton = [self createBarButtonItem:@"ImageEditorSticker" imagePressed:@"ImageEditorSticker" tag:kStickerButtonTag];
    _gloButton = [self createBarButtonItem:@"EditorGloOff" imagePressed:@"EditorGloOn" tag:kGloButtonTag];
    _cropButton = [self createBarButtonItem:@"EditorCropOff" imagePressed:@"EditorCropOn" tag:kCropButtonTag];
    
    
    
    _saveButton = [self createBarButtonItem:@"ImageEditorSave" imagePressed:@"ImageEditorSave" tag:kSaveButtonTag];
    
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _toolbar.items = @[_cancelButton,flexibleSpace,
                       _filterButton,flexibleSpace,
                       _stickerButton,flexibleSpace,
                       _gloButton,flexibleSpace,
                       _cropButton,flexibleSpace,
                       _saveButton];
    [self.view addSubview:_toolbar];
    
    [self initMenuScrollView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // Super
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // Super
    [super viewWillDisappear:animated];
    
}

#pragma mark- Custom initialization

- (void)initMenuScrollView
{
    if(self.menuView==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.tfWidth, 80)];
        menuScroll.tfTop = _toolbar.tfTop - menuScroll.tfHeight;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator = NO;
        menuScroll.showsVerticalScrollIndicator = NO;
        [self.view addSubview:menuScroll];
        self.menuView = menuScroll;
    }
    self.menuView.backgroundColor = RGBACOLOR(0, 0, 0, .8);
}

- (void)initImageScrollView
{
    if(_scrollView==nil){
        UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        imageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.showsVerticalScrollIndicator = NO;
        imageScroll.delegate = self;
        imageScroll.clipsToBounds = NO;
        imageScroll.tfTop = 0;
        [self.view insertSubview:imageScroll atIndex:0];
        _scrollView = imageScroll;
    }
}

- (void)refreshImageView {
    __weak __typeof(self)weakSelf = self;
    [[DBLibraryManager sharedInstance] fixAssetForURL:_originalUrl resultBlock:^(ALAsset *asset) {
        weakSelf.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        [weakSelf resetImageViewFrame];
        [weakSelf resetZoomScaleWithAnimated:NO];
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.tfWidth-W)/2), MAX(0, (_scrollView.tfHeight-H)/2), W, H);
    }
}

- (void)fixZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.95*minZoomScale;
    _scrollView.minimumZoomScale = 0.95*minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}


- (void)barButtonPressed:(id)sender {
    if ([sender isEqual:_cancelButton]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([sender isEqual:_saveButton]) {
        
    }
}

- (void)onViewClick:(id)sender {
    switch ([sender tag]) {
        case kCancelButtonTag:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case kSaveButtonTag:
            break;
        case kFilterButtonTag:
            
            break;
        case kStickerButtonTag:
            break;
        case kCropButtonTag:
            break;
        case kDepthButtonTag:
            break;
        case kGloButtonTag:
            break;
            
        default:
            break;
    }
}

- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
    return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}

- (UIBarButtonItem *)createBarButtonItem:(NSString *)imageName
                            imagePressed:(NSString *)imagePressed
                                     tag:(NSInteger)tag {
    UIButton *button = [UIButton createButtonWithImage:imageName
                                          imagePressed:imagePressed
                                                target:self
                                              selector:@selector(onViewClick:)];
    button.tag = tag;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- ScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}

@end
