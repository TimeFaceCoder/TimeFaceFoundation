//
//  TFPhotoBrowser.m
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFPhotoBrowser.h"
#import "TFZoomingScrollView.h"
#import <SDWebImage/SDImageCache.h>
#import "TFImageEditorViewController.h"
#import "DBLibraryManager.h"
#import "Utility.h"

#import "SVProgressHUD.h"
#import "TFImageToolBase.h"
#import "CLImageToolInfo.h"
#import "TFPhotoTagView.h"
#import "ImageTagModel.h"
#import <pop/POP.h>

#import "TSubViewController+TFHandle.h"
#import "TimeLineModel.h"
#import "TNavigationViewController.h"

#define PADDING                  10




@interface TFPhotoBrowser ()<TFImageEditorViewControllerDelegate,UIScrollViewDelegate,
CLImageToolProtocol,TFPhotoTagViewDelegate> {
    // Data
    NSUInteger _photoCount;
    NSMutableArray *_photos;
    NSMutableArray *_thumbPhotos;


    // Views
    UIScrollView *_pagingScrollView;


    // Paging & layout
    NSMutableSet *_visiblePages, *_recycledPages,*_editorInfos;
    NSUInteger _currentPageIndex;
    NSUInteger _previousPageIndex;
    CGRect _previousLayoutBounds;

    // Navigation & controls
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    // Appearance
    BOOL _performingLayout;
    BOOL _tagOnView;

    ImageTagModel   *_editTagModel;

    TFPhotoToolbar *_toolbar;

    CGPoint         _editPoint;
}

@property (nonatomic, strong           ) TFImageToolBase *currentTool;
@property (nonatomic, strong, readwrite) CLImageToolInfo *toolInfo;

@property (nonatomic, strong           ) TimeLineModel   *timeModel;
@property (nonatomic, assign           ) TimeType        timeType;

@end

@implementation TFPhotoBrowser

#pragma mark- ImageTool setting

+ (NSString*)defaultIconImagePath {
    return nil;
}

+ (CGFloat)defaultDockedNumber {
    return 0;
}

+ (NSString*)defaultTitle
{
    return nil;
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (NSArray*)subtools {

    return [CLImageToolInfo toolsWithToolClass:[TFImageToolBase class]];
}

+ (NSDictionary*)optionalInfo {
    return nil;
}

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self _initialisation];
    }
    return self;
}

- (id)initWithDelegate:(id <TFPhotoBrowserDelegate>)delegate {
    if ((self = [self init])) {
        _delegate = delegate;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        [self _initialisation];
    }
    return self;
}

- (void)_initialisation {

    self.hidesBottomBarWhenPushed = YES;
    _photoCount = NSNotFound;
    _previousLayoutBounds = CGRectZero;
    _currentPageIndex = 0;
    _previousPageIndex = NSUIntegerMax;
    _zoomPhotosToFill = YES;
    _delayToHideElements = 5;
    _performingLayout = NO;
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _photos = [[NSMutableArray alloc] init];
    _tagInfos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;



    // Listen for MWPhoto notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                 name:NOTICE_TFPHOTO_ENDLOADING
                                               object:nil];

    //识别到人脸
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFaceLoadedNotification:)
                                                 name:NOTICE_TFPHOTO_ENDFACELOADING
                                               object:nil];
    //通讯录选择完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleContactsLoadedNotification:)
                                                 name:NOTICE_SIMPLE_CONTACTS_SELECTED
                                               object:nil];
    self.toolInfo = [CLImageToolInfo toolInfoForToolClass:[self class]];
}

- (void)dealloc {
    _pagingScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseAllUnderlyingPhotos:NO];
    [[SDImageCache sharedImageCache] clearMemory]; // clear memory
}

- (void)releaseAllUnderlyingPhotos:(BOOL)preserveCurrent {
    // Create a copy in case this array is modified while we are looping through
    // Release photos
    NSArray *copy = [_photos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            if (preserveCurrent && p == [self photoAtIndex:self.currentIndex]) {
                continue; // skip current
            }
            [p unloadUnderlyingImage];
        }
    }
    // Release thumbs
    copy = [_thumbPhotos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            [p unloadUnderlyingImage];
        }
    }
}

- (void)didReceiveMemoryWarning {

    // Release any cached data, images, etc that aren't in use.
    [self releaseAllUnderlyingPhotos:YES];
    [_recycledPages removeAllObjects];

    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

#pragma mark - View Loading

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    // View
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;

    // Setup paging scrolling view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self.view addSubview:_pagingScrollView];


    // Menu View
    _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    _menuView.top = self.view.height - _menuView.height;
    _menuView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    _menuView.showsHorizontalScrollIndicator = NO;
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.backgroundColor = RGBACOLOR(0, 0, 0, .8);
    [self.view addSubview:_menuView];

    //nav bar
    _navigationItem  = [[UINavigationItem alloc] init];

    //返回
    _navigationItem.leftBarButtonItem = [[Utility sharedUtility] createBarButtonWithImage:@"NavButtonBack2"
                                                                        selectedImageName:@"NavButtonBack2"
                                                                                 delegate:self
                                                                                 selector:@selector(dismiss)];


    //下一步
    _navigationItem.rightBarButtonItem = [[Utility sharedUtility] createBarButtonWithTitle:NSLocalizedString(@"下一步", nil)
                                                                                  delegate:self
                                                                                  selector:@selector(onRightNavClick:)];

    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_navigationBar pushNavigationItem:_navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[[Utility sharedUtility] createImageWithColor:RGBACOLOR(0, 0, 0, .8)]
                         forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:_navigationBar];

    // Update
    [self reloadData];



    // Super
    [super viewDidLoad];

    [self setMenuView];
    [self removeStateView];
    [self setToolItems:nil];
    
    _toolbar.hidden = YES;
}

- (void)setToolItems:(NSMutableArray *)toolItems {
    if (toolItems && toolItems.count) {
        _toolItems = toolItems;
    }else {
        TFPhotoToolItemBlock clickBlock = ^(TFPhotoToolItem *item){
            [self onItemClick:item];
        };
        NSArray *array = @[
                       [TFPhotoToolItem actionItem:NSLocalizedString(@"保存", nil)
                                             image:[UIImage imageNamed:@"SaveImage"]
                                     selectedImage:[UIImage imageNamed:@"SaveImage"]
                                             state:NO
                                               tag:kBrowserSaveTag
                                             block:clickBlock],
                       [TFPhotoToolItem actionItem:NSLocalizedString(@"赞", nil)
                                             image:[UIImage imageNamed:@"TimeLineLike"]
                                     selectedImage:[UIImage imageNamed:@"TimeLineLikeSelected"]
                                             state:NO
                                               tag:kBrowserLikeTag
                                             block:clickBlock],
                       [TFPhotoToolItem actionItem:NSLocalizedString(@"评论", nil)
                                             image:[UIImage imageNamed:@"TimeLineComment"]
                                     selectedImage:[UIImage imageNamed:@"TimeLineComment"]
                                             state:NO
                                               tag:kBrowserCommentTag
                                             block:clickBlock],
                       ];
        _toolItems = [[NSMutableArray alloc]initWithArray:array];
    }
    [self createToolbar];
}

- (void)performLayout {

    // Setup
    _performingLayout = YES;


    // Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];


    // Update nav
    [self updateNavigation];

    // Content offset
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    [self tilePages];
    _performingLayout = NO;

}


- (void)setMenuView
{
    CGFloat x = 0;
    CGFloat W = self.view.width / ([self.toolInfo.sortedSubtools count]);
    CGFloat H = _menuView.height;

    //create tool info

    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H)
                                                                 target:self
                                                                 action:@selector(tappedMenuView:)
                                                               toolInfo:info];
        [_menuView addSubview:view];


        x += W;
    }
    _menuView.contentSize = CGSizeMake(MAX(x, _menuView.frame.size.width+1), 0);
}


// Release any retained subviews of the main view.
- (void)viewDidUnload {
    _currentPageIndex = 0;
    _pagingScrollView = nil;
    _visiblePages = nil;
    _recycledPages = nil;
    [super viewDidUnload];
}


#pragma mark - Appearance

- (void)viewWillAppear:(BOOL)animated {
    // Super
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    [self releaseAllUnderlyingPhotos:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // Super
    [super viewWillDisappear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutVisiblePages];
}

- (void)layoutVisiblePages {

    // Flag
    _performingLayout = YES;

    // Remember index
    NSUInteger indexPriorToLayout = _currentPageIndex;

    // Get paging scroll view frame to determine if anything needs changing
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];

    // Frame needs changing
    _pagingScrollView.frame = pagingScrollViewFrame;

    // Recalculate contentSize based on current orientation
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];

    // Adjust frames and configuration of each visible page
    for (TFZoomingScrollView *page in _visiblePages) {
        NSUInteger index = page.index;
        page.frame = [self frameForPageAtIndex:index];

        // Adjust scales if bounds has changed since last time
        if (!CGRectEqualToRect(_previousLayoutBounds, self.view.bounds)) {
            // Update zooms for new bounds
            [page setMaxMinZoomScalesForCurrentBounds];
            _previousLayoutBounds = self.view.bounds;
        }

    }

    // Adjust contentOffset to preserve page location based on values collected prior to location
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
    [self didStartViewingPageAtIndex:_currentPageIndex]; // initial

    // Reset
    _currentPageIndex = indexPriorToLayout;
    _performingLayout = NO;

}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Layout
    // Perform layout

    _toolbar.bottom = self.view.height;
    _toolbar.width = self.view.width;
    [_toolbar layoutSubviews];

    [self layoutVisiblePages];
}



#pragma mark - Data

- (NSUInteger)currentIndex {
    return _currentPageIndex;
}

- (void)reloadData {
    // Reset
    _photoCount = NSNotFound;

    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    [self releaseAllUnderlyingPhotos:YES];
    [_photos removeAllObjects];
    [_thumbPhotos removeAllObjects];
    for (int i = 0; i < numberOfPhotos; i++) {
        [_photos addObject:[NSNull null]];
        [_tagInfos addObject:[NSNull null]];
        [_thumbPhotos addObject:[NSNull null]];
    }

    // Update current page index
    if (numberOfPhotos > 0) {
        _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
    } else {
        _currentPageIndex = 0;
    }

    // Update layout
    if ([self isViewLoaded]) {
        while (_pagingScrollView.subviews.count) {
            [[_pagingScrollView.subviews lastObject] removeFromSuperview];
        }
        [self performLayout];
        [self.view setNeedsLayout];
    }

}

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
        }
    }
    if (_photoCount == NSNotFound) _photoCount = 0;
    return _photoCount;
}

- (id<TFPhoto>)photoAtIndex:(NSUInteger)index {
    id <TFPhoto> photo = nil;
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
                photo = [_delegate photoBrowser:self photoAtIndex:index];
            }
            if (photo) [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    return photo;
}

- (NSURL *)photoURLAtIndex:(NSUInteger)index {
    id <TFPhoto> photo = [self photoAtIndex:index];
    if (photo) {
        return [photo currentPhotoUrl];
    }
    return nil;
}

- (void)updatePhotoAtIndex:(NSUInteger)index URL:(NSURL *)URL {
    TFPhoto *photo = [TFPhoto photoWithURL:URL];
    [_photos replaceObjectAtIndex:index withObject:photo];
    //更新当前页面
    [[self pageDisplayedAtIndex:_currentPageIndex] updatePagePhoto:photo];
    if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:updateURL:)]) {
        [_delegate photoBrowser:self photoAtIndex:index updateURL:URL];
    }

}

- (void)updatePhotoAtIndex:(NSUInteger)index image:(UIImage *)image {
    TFPhoto *photo = [TFPhoto photoWithImage:image];
    [_photos replaceObjectAtIndex:index withObject:photo];
}

- (id<TFPhoto>)thumbPhotoAtIndex:(NSUInteger)index {
    id <TFPhoto> photo = nil;
    if (index < _thumbPhotos.count) {
        if ([_thumbPhotos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:thumbPhotoAtIndex:)]) {
                photo = [_delegate photoBrowser:self thumbPhotoAtIndex:index];
            }
            if (photo) [_thumbPhotos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_thumbPhotos objectAtIndex:index];
        }
    }
    return photo;
}



- (UIImage *)imageForPhoto:(id<TFPhoto>)photo {
    if (photo) {
        // Get image or obtain in background
        if ([photo underlyingImage]) {
            return [photo underlyingImage];
        } else {
            [photo loadUnderlyingImageAndNotify];
        }
    }
    return nil;
}

- (UIImageView *)imageView {
    TFZoomingScrollView *page = [self pageDisplayedAtIndex:_currentPageIndex];
    if (page) {
        return (UIImageView *)page.photoImageView;
    }

    return nil;
}


- (NSURL *)urlForPhoto:(id<TFPhoto>)photo {
    if (photo) {
        // Get image or obtain in background
        if ([photo currentPhotoUrl]) {
            return [photo currentPhotoUrl];
        }
    }
    return nil;
}


- (void)loadAdjacentPhotosIfNecessary:(id<TFPhoto>)photo {
    TFZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        // If page is current page then initiate loading of previous and next pages
        NSUInteger pageIndex = page.index;
        if (_currentPageIndex == pageIndex) {
            if (pageIndex > 0) {
                // Preload index - 1
                id <TFPhoto> photo = [self photoAtIndex:pageIndex-1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    TFLog(@"Pre-loading image at index %@", @(pageIndex-1));
                }
            }
            if (pageIndex < [self numberOfPhotos] - 1) {
                // Preload index + 1
                id <TFPhoto> photo = [self photoAtIndex:pageIndex+1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    TFLog(@"Pre-loading image at index %@", @(pageIndex+1));
                }
            }
        }
    }
}

#pragma mark - TFPhoto Loading Notification

- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <TFPhoto> photo = [notification object];
    TFZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        if ([photo underlyingImage]) {
            // Successful load
            [page displayImageWithDoneBlock:^{
                if (_tagOnView) {
                    [self configurePageTag:_currentPageIndex];
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    if (self.timeModel) {
                        UIImage *resizeImage = [photo.underlyingImage resizedImageWithMinimumSize:CGSizeMake(800, 800)];
                        NSInteger timeid = [[Utility sharedUtility] decodeTimeUID:self.timeModel.timeId];
//                        [[NetworkAssistant sharedAssistant] putImageData:resizeImage
//                                                                  hashID:timeid ];
                        [[NetUtility shareNetUtility] putImageData:resizeImage hashID:timeid];
                        
                    }
                });
                
            }];
            [self loadAdjacentPhotosIfNecessary:photo];
        } else {
            // Failed to load
            [page displayImageFailure];
        }
        // Update nav
        [self updateNavigation];
    }
}

- (void)handleFaceLoadedNotification:(NSNotification *)notification {
//    if (_browserMode && BUILDWITHOUTCIRCLE)
//        return;
//    if (BUILDWITHOUTCIRCLE)
//        return;
    TFZoomingScrollView *zoomingScrollView = [self pageDisplayedAtIndex:_currentPageIndex];
    if (zoomingScrollView) {
        TFLog(@"photo face:%@",zoomingScrollView.faceFeatures);
        if (zoomingScrollView.faceFeatures && [zoomingScrollView.faceFeatures count] > 0) {
            //检查是否保存过人脸数据
            NSMutableArray *array = [_tagInfos objectAtIndex:_currentPageIndex];
            if ([array isKindOfClass:[NSNull class]] || [array count] <=0) {
                for (NSString *faceBounds in zoomingScrollView.faceFeatures) {
                    if (faceBounds) {
                        [self addFaceRectOnView:CGRectFromString(faceBounds)];
                    }
                }
            }
            [self configurePageTag:_currentPageIndex];

        }
    }
}

- (void)handleContactsLoadedNotification:(NSNotification *)notification {
    if ([notification userInfo]) {
        NSDictionary *userInfo = [notification userInfo];
        if ([[userInfo objectForKey:@"name"] length]) {
            if (_editPoint.x > 0 && _editPoint.y > 0) {
                NSMutableArray *array = [_tagInfos objectAtIndex:_currentPageIndex];
                if (![array isKindOfClass:[NSNull class]]) {
                    for (ImageTagModel *model in array) {
                        if (model.pointX == _editPoint.x && model.pointY == _editPoint.y) {
                            model.content = [userInfo objectForKey:@"name"];
                            model.selected = YES;
                        }
                    }
                    [self configurePageTag:_currentPageIndex];

                    if ([_delegate respondsToSelector:@selector(updatePhotoInfos:photoAtIndex:)]) {
                        [_delegate updatePhotoInfos:array photoAtIndex:_currentPageIndex];
                    }
                }
            }

        }
    }
}

#pragma mark - Paging


- (void)tilePages {

    // Calculate which pages should be visible
    // Ignore padding as paging bounces encroach on that
    // and lead to false page loads
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger iFirstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
    NSInteger iLastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > [self numberOfPhotos] - 1) iFirstIndex = [self numberOfPhotos] - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > [self numberOfPhotos] - 1) iLastIndex = [self numberOfPhotos] - 1;

    // Recycle no longer needed pages
    NSInteger pageIndex;
    for (TFZoomingScrollView *page in _visiblePages) {
        pageIndex = page.index;
        if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
            [_recycledPages addObject:page];
            [page prepareForReuse];
            [page removeFromSuperview];
            TFLog(@"Removed page at index %@", @(pageIndex));
        }
    }
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];

    // Add missing pages
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {

            // Add new page
            TFZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[TFZoomingScrollView alloc] initWithPhotoBrowser:self];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];

            [_pagingScrollView addSubview:page];
            TFLog(@"Added page at index %@", @(index));
        }
    }
}


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for (TFZoomingScrollView *page in _visiblePages)
        if (page.index == index) return YES;
    return NO;
}

- (TFZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
    TFZoomingScrollView *thePage = nil;
    for (TFZoomingScrollView *page in _visiblePages) {
        if (page.index == index) {
            thePage = page; break;
        }
    }
    return thePage;
}

- (TFZoomingScrollView *)pageDisplayingPhoto:(id<TFPhoto>)photo {
    TFZoomingScrollView *thePage = nil;
    for (TFZoomingScrollView *page in _visiblePages) {
        if (page.photo == photo) {
            thePage = page; break;
        }
    }
    return thePage;
}

- (void)configurePage:(TFZoomingScrollView *)page forIndex:(NSUInteger)index {
    page.frame = [self frameForPageAtIndex:index];
    page.index = index;
    page.photo = [self photoAtIndex:index];
}

- (TFZoomingScrollView *)dequeueRecycledPage {
    TFZoomingScrollView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {

    if (![self numberOfPhotos]) {
        // Show controls
        return;
    }

    // Release images further away than +/-1
    NSUInteger i;
    if (index > 0) {
        // Release anything < index - 1
        for (i = 0; i < index-1; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                TFLog(@"Released underlying image at index %@", @(i));
            }
        }
    }
    if (index < [self numberOfPhotos] - 1) {
        // Release anything > index + 1
        for (i = index + 2; i < _photos.count; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                TFLog(@"Released underlying image at index %@", @(i));
            }
        }
    }

    // Load adjacent images if needed and the photo is already
    // loaded. Also called after photo has been loaded in background
    id <TFPhoto> currentPhoto = [self photoAtIndex:index];
    if ([currentPhoto underlyingImage]) {
        // photo loaded so load ajacent now
        [self loadAdjacentPhotosIfNecessary:currentPhoto];
    }

    // Notify delegate
    if (index != _previousPageIndex) {
        _previousPageIndex = index;
    }

    // Update nav
    [self updateNavigation];


}

#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index * pageWidth;
    return CGPointMake(newOffset, 0);
}

- (CGRect)frameForMenuViewAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
    return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // Checks
    if ( _performingLayout) return;

    // Tile pages
    [self tilePages];

    // Calculate current page
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
    NSUInteger previousCurrentPage = _currentPageIndex;
    _currentPageIndex = index;
    if (_currentPageIndex != previousCurrentPage) {
        [self didStartViewingPageAtIndex:index];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Update nav when page changes
    [self updateNavigation];
}

#pragma mark - Navigation

- (void)updateNavigation {
    // Title
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    if (numberOfPhotos > 1) {
        if ([_delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
            self.title = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPageIndex];
        } else {
            [_navigationItem setTitle:[NSString stringWithFormat:@"%@ / %@",@(_currentPageIndex+1),@(numberOfPhotos)]];
        }
    } else {
        _navigationItem.title = nil;
    }
}

- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {

    // Change page
    if (index < [self numberOfPhotos]) {
        CGRect pageFrame = [self frameForPageAtIndex:index];
        [_pagingScrollView setContentOffset:CGPointMake(pageFrame.origin.x - PADDING, 0) animated:animated];
        [self updateNavigation];
    }

}

- (void)gotoPreviousPage {
    [self showPreviousPhotoAnimated:NO];
}
- (void)gotoNextPage {
    [self showNextPhotoAnimated:NO];
}

- (void)showPreviousPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex-1 animated:animated];
}

- (void)showNextPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex+1 animated:animated];
}



#pragma mark - Control
- (void)lockScrollView {

}

- (void)toggleControls {
    if (self.currentTool) {
        if ([self.currentTool handleSingleTap]) {

        }
        else {
            self.currentTool = nil;
        }
    }
    else {
        if (_onlyShow) {
            if (_tagOnView) {
                //remove tag
                _tagOnView = NO;
                [[self pageDisplayedAtIndex:_currentPageIndex] removeAllTags];
            }
            else {
                [self configurePageTag:_currentPageIndex];
                _tagOnView = YES;
            }
        }
        else {
            [self dismiss];
        }
    }
}

- (void)longTapOnView:(NSDictionary *)touchInfo {

    CGPoint pointOnImage = [touchInfo[@"pointOnImage"] CGPointValue];
    CGPoint pointOnView = [self.view convertPoint:pointOnImage fromView:[self imageView]];
    CGPoint normalizedPoint = [[self pageDisplayedAtIndex:_currentPageIndex] normalizedPositionForPoint:pointOnView];
    TFPhotoTagView *tagView = [[TFPhotoTagView alloc] initWithDelegate:self];
    [[self pageDisplayedAtIndex:_currentPageIndex] startNewTagPopover:tagView
                                                    atNormalizedPoint:normalizedPoint
                                                         pointOnImage:pointOnImage];
}

- (void)addFaceRectOnView:(CGRect)bounds {
    CGPoint pointOnImage = CGPointMake(bounds.origin.x + bounds.size.width / 2, bounds.origin.y + bounds.size.height / 2);

    ImageTagModel *model = [ImageTagModel tagWithProperties:@{@"size":NSStringFromCGSize(bounds.size),
                                                              @"content":NSLocalizedString(@"这是?", nil),
                                                              @"pointOnImage":NSStringFromCGPoint(pointOnImage)}];
    [self updateImageTagInfo:model];
}

/**
 *  配置当前page tag view
 *
 *  @param index
 */
- (void)configurePageTag:(NSUInteger)index {
    //显示当前page tag
    if ([_tagInfos count]<=0)
        return;
    NSMutableArray *array = [_tagInfos objectAtIndex:index];
    if (array && [array isKindOfClass:[NSMutableArray class]]) {
        TFLog(@"current page tag is:%@",array);
        //remove all tags
        [[self pageDisplayedAtIndex:_currentPageIndex] removeAllTags];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[ImageTagModel class]]) {
                    ImageTagModel *model = (ImageTagModel *)obj;
                    if (model) {
                        CGPoint pointOnImage = CGPointMake(model.pointX, model.pointY);
                        CGPoint pointOnView = [self.view convertPoint:pointOnImage fromView:[self imageView]];
                        CGPoint normalizedPoint = [[self pageDisplayedAtIndex:_currentPageIndex] normalizedPositionForPoint:pointOnView];
                        dispatch_main_sync_safe(^{

                            TFPhotoTagView *tagView = [[TFPhotoTagView alloc] initWithDelegate:self];
                            if (model.content.length) {
                                [tagView setText:model.content];
                            }
                            [[self pageDisplayedAtIndex:_currentPageIndex] startNewTagPopover:tagView
                                                                            atNormalizedPoint:normalizedPoint
                                                                                 pointOnImage:pointOnImage];
                        });
                    }
                    if ([_delegate respondsToSelector:@selector(updatePhotoInfos:photoAtIndex:)]) {
                        [_delegate updatePhotoInfos:array photoAtIndex:_currentPageIndex];
                    }
                }
            }];
        });
    }
}



- (void)doubleZoomView {
    //hidden control
    [_navigationBar setHidden:!_navigationBar.hidden];
    [_menuView setHidden:!_menuView.hidden];
}


#pragma mark - Properties

// Handle depreciated method
- (void)setInitialPageIndex:(NSUInteger)index {
    [self setCurrentPhotoIndex:index];
}

- (void)setCurrentPhotoIndex:(NSUInteger)index {
    // Validate
    NSUInteger photoCount = [self numberOfPhotos];
    if (photoCount == 0) {
        index = 0;
    } else {
        if (index >= photoCount)
            index = [self numberOfPhotos]-1;
    }
    _currentPageIndex = index;
    if ([self isViewLoaded]) {
        [self jumpToPageAtIndex:index animated:NO];
            [self tilePages]; // Force tiling if view is not visible
    }
}


#pragma mark - Actions

- (void)dismiss {
//    return;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onRightNavClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(nextAction)]) {
        [_delegate nextAction];
    }
    else {
        [self dismiss];
    }
}

- (void)saveImageAction {
    if ([_delegate respondsToSelector:@selector(photoBrowser:didFinishSavingWithError:)]) {
        [_delegate photoBrowser:self didFinishSavingWithError:nil];
    }
}

- (void)deleteImageAction {
    //删除
    if ([_delegate respondsToSelector:@selector(photoBrowser:deletePhotoAtIndex:)]) {
        [_delegate photoBrowser:self deletePhotoAtIndex:_currentPageIndex];
    }
    if (_photoCount > 1) {
        [self reloadData];
    }
    else {
        [self dismiss];
    }
}

- (void)setupToolWithToolInfo:(CLImageToolInfo*)info
{
    if(self.currentTool){ return; }

    Class toolClass = NSClassFromString(info.toolName);

    if(toolClass){
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[TFImageToolBase class]]){
            instance = [instance initWithImageEditor:self withToolInfo:info];
            self.currentTool = instance;
        }
    }
}

- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    //image view 缩放重置
    CGFloat minScale = [[self pageDisplayedAtIndex:_currentPageIndex] minimumZoomScale];
    if ([[self pageDisplayedAtIndex:_currentPageIndex] zoomScale] > minScale) {
        [[self pageDisplayedAtIndex:_currentPageIndex] imageRest];
    }
    TFLog(@"tool info :%@",NSStringFromClass(view.toolInfo.class));
    if ([view.toolInfo.toolName isEqualToString:@"TFDeleteTool"]) {
        //执行删除操作
        if ([_delegate respondsToSelector:@selector(photoBrowser:deletePhotoAtIndex:)]) {
            [_delegate photoBrowser:self deletePhotoAtIndex:_currentPageIndex];
        }
        if (_photoCount > 1) {
            [self reloadData];
        }
        else {
            [self dismiss];
        }
    }
    else {
        [self setupToolWithToolInfo:view.toolInfo];
    }
}

#pragma mark- Tool actions

- (void)setCurrentTool:(TFImageToolBase *)currentTool
{
    //lock scroll view
    _pagingScrollView.scrollEnabled = _currentTool!=nil;
    if(currentTool != _currentTool){
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];

        [self swapToolBarWithEditting:(_currentTool!=nil)];
    }
}

#pragma mark- Menu actions

- (void)swapMenuViewWithEditting:(BOOL)editting
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         if(editting){
                             _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         }
                         else{
                             _menuView.transform = CGAffineTransformIdentity;
                         }
                     }
     ];
}


- (void)swapToolBarWithEditting:(BOOL)editting
{
    [self swapMenuViewWithEditting:editting];

    if(self.currentTool){
        UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:self.currentTool.toolInfo.title];

        item.leftBarButtonItem = [[Utility sharedUtility] createBarButtonWithImage:@"ImageEditorCancel"
                                                                 selectedImageName:@"ImageEditorCancel"
                                                                          delegate:self
                                                                          selector:@selector(pushedCancelBtn:)];

        item.rightBarButtonItem = [[Utility sharedUtility] createBarButtonWithImage:@"ImageEditorSave"
                                                                  selectedImageName:@"ImageEditorSave"
                                                                           delegate:self
                                                                           selector:@selector(pushedDoneBtn:)];
        [_navigationBar pushNavigationItem:item animated:NO];
    }
    else{
        [_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
    }
}

- (IBAction)pushedCancelBtn:(id)sender
{
    self.currentTool = nil;
}

/**
 *  当前编辑模式下保存
 *
 *  @param sender
 */
- (IBAction)pushedDoneBtn:(id)sender
{
    self.view.userInteractionEnabled = NO;

    [SVProgressHUD showGifWithStatus:NSLocalizedString(@"正在处理", nil)];
    if ([self.currentTool respondsToSelector:@selector(executeOriginalImage:completionBlock:)]) {
        [self.currentTool executeOriginalImage:[self photoURLAtIndex:_currentPageIndex]
                               completionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo)
         {

             if ([userInfo objectForKey:@"URL"]) {
                 [self updatePhotoAtIndex:_currentPageIndex URL:[userInfo objectForKey:@"URL"]];
             }
             if(error){
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else if(image){
                 self.currentTool = nil;
             }
             [SVProgressHUD dismiss];
             self.view.userInteractionEnabled = YES;
         }];
    }
    else {
        [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
            if(error){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if(image){
                [self updatePhotoAtIndex:_currentPageIndex image:image];
                self.currentTool = nil;
            }
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = YES;
        }];
    }
}

- (void)updateImageTagInfo:(ImageTagModel *)model {
    NSMutableArray *array = [_tagInfos objectAtIndex:_currentPageIndex];
    if ([array isKindOfClass:[NSNull class]]) {
        //当前为空
        array = [NSMutableArray array];
        [array addObject:model];
    }
    else {
        //检查是否相同位置存在
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[ImageTagModel class]]) {
                ImageTagModel *oldModel = (ImageTagModel *)obj;
                if (![oldModel.debugDescription isEqualToString:model.debugDescription]) {
                    [array addObject:model];
                    *stop = YES;
                }
                else {
                    TFLog(@"array already have tag model:%@",model.debugDescription);
//                    *stop = YES;
                }
            }
        }];
    }
    [_tagInfos replaceObjectAtIndex:_currentPageIndex withObject:array];
    if ([_delegate respondsToSelector:@selector(photoBrowser:infos:)]) {
        [_delegate photoBrowser:self infos:_tagInfos];
    }
}

#pragma mark TFPhotoTagViewDelegate

- (void)tagDidAppear:(TFPhotoTagView *)tagPopover {
//    if ([tagPopover.text isEqualToString:NSLocalizedString(@"这是?", nil)]) {
//        ImageTagModel *model = [ImageTagModel tagWithProperties:@{@"size":NSStringFromCGSize(tagPopover.sizeOnImage),
//                                                                  @"content":tagPopover.text,
//                                                                  @"pointOnImage":NSStringFromCGPoint(tagPopover.pointOnImage)}];
//        [self updateImageTagInfo:model];
//    }
}

- (void)tagPopoverDidEndEditing:(TFPhotoTagView *)tagPopover {
    ImageTagModel *model = [ImageTagModel tagWithProperties:@{@"size":NSStringFromCGSize(tagPopover.sizeOnImage),
                                                              @"content":tagPopover.text,
                                                              @"pointOnImage":NSStringFromCGPoint(tagPopover.pointOnImage)}];
    [self updateImageTagInfo:model];
}
- (void)tagPopover:(TFPhotoTagView *)tagPopover didReceiveSingleTap:(UITapGestureRecognizer *)singleTap {
//    if ([tagPopover.text isEqualToString:NSLocalizedString(@"这是?", nil)]) {
        //打开联系人列表选择
        if (_expandData && [_expandData objectForKey:@"circleId"]) {
//            [self openCircleSimpleContactView:[_expandData objectForKey:@"circleId"]];
            _editPoint = tagPopover.pointOnImage;
//            [tagPopover removeFromSuperview];
        }
//    }
//    else {
//        //删除tag
//        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//        opacityAnimation.toValue = @(0);
//        [opacityAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
//            if (finish) {
//                [tagPopover removeFromSuperview];
//            }
//        }];
//        [tagPopover.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
//
//        NSMutableArray *array = [_tagInfos objectAtIndex:_currentPageIndex];
//        if (![array isKindOfClass:[NSNull class]]) {
//            //删除本地tag数据
//            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                if ([obj isKindOfClass:[ImageTagModel class]]) {
//                    ImageTagModel *model = (ImageTagModel *)obj;
//                    if ([model.content isEqualToString:tagPopover.text]) {
//                        [array removeObject:model];
//                    }
//                }
//            }];
//        }
//    }
}

- (void)tagPopover:(TFPhotoTagView *)tagPopover didReceiveLongTap:(UITapGestureRecognizer *)longTap {
    //删除tag
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
    [opacityAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        if (finish) {
            [tagPopover removeFromSuperview];
        }
    }];
    [tagPopover.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];

    NSMutableArray *array = [_tagInfos objectAtIndex:_currentPageIndex];
    if (![array isKindOfClass:[NSNull class]]) {
        //删除本地tag数据
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[ImageTagModel class]]) {
                ImageTagModel *model = (ImageTagModel *)obj;
                if ([model.content isEqualToString:tagPopover.text]) {
                    [array removeObject:model];
                }
            }
        }];
    }
}

#pragma mark - 图片显示

- (void)refreshTime:(TimeLineModel *)model type:(TimeType)type {
    _toolbar.hidden = NO;
    _navigationItem.leftBarButtonItem = [[Utility sharedUtility] createBarButtonWithImage:@"NavButtonNO"
                                                                        selectedImageName:@"NavButtonNO"
                                                                                 delegate:self
                                                                                 selector:@selector(dismiss)];
    _navigationItem.rightBarButtonItem = nil;
    _menuView.hidden = YES;
    [self updateNavigation];

    if (!model) {
        [_toolbar refreshNull];
        return ;
    }
    _onlyShow = YES;
    self.timeModel = model;
    self.timeType = type;

//    [_toolbar refreshLike:model.like count:model.likeCount];
//    [_toolbar refreshComment:model.commentCount];
    [_toolbar refreshItemTitle:[NSString stringWithFormat:@"%@",@(model.likeCount)] state:model.like tag:kBrowserLikeTag];
    [_toolbar refreshItemTitle:[NSString stringWithFormat:@"%@",@(model.commentCount)] state:NO tag:kBrowserCommentTag];
}

/**
 *  赞时光
 *
 *  @param time
 */
- (void)likeTime:(TimeLineModel *)timeModel type:(TimeType)type {
    NSInteger operationType = 0;
    if (!timeModel.like) {
        operationType = 1;
        timeModel.likeCount++;
    } else {
        operationType = 2;
        timeModel.likeCount--;
    }
    timeModel.like = !timeModel.like;
    NSString *timeId = timeModel.timeId;
    if (type == TimeTypeTopic) {
        timeId = timeModel.topicId;
    }
//    NSString *interface = INTERFACE_PRAISE;
    NSDictionary *params = @{@"dataId":(!timeId.length?@"":timeId), //话题/时光ID
                             @"operate":[NSString stringWithFormat:@"%@",@(operationType)],//操作类型 1 赞 2 取消
                             @"type":[NSString stringWithFormat:@"%@",@(type)]};      //赞类型 1 话题 2时光
    if (type == TimeTypeCircleTime) {
        params = @{@"dataId":timeId, //话题/时光ID
                   @"operate":[NSNumber numberWithInteger:operationType],//操作类型 1 赞 2 取消
                   @"circleId":timeModel.circleId};      //时光圈编号

//        interface = INTERFACE_CIRCLE_LIKE;
    }
    NSString *interface = @"接口";
    [[NetworkAssistant sharedAssistant] getDataByInterFace:interface
                                                    params:params
                                                  fileData:nil
                                                       hud:nil
                                                     start:nil
                                                 completed:^(id result, NSError *error)
     {
         TFLog(@"%s %@ info:%@",__func__,result,[result objectForKey:@"info"]);
         if (error) {
//             TFLog(@"%@ ERROR:%@", INTERFACE_PRAISE, error.debugDescription);
         }
         if ([[result objectForKey:@"status"] boolValue]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_RELOAD_TWEETS object:nil];
         }
     }];
}

- (void)createToolbar
{
    if (_toolbar) {
        [_toolbar removeFromSuperview];
        _toolbar = nil;
    }
    CGFloat barHeight = 44;

    CGFloat barY = self.view.height - barHeight;
    
    _toolbar = [[TFPhotoToolbar alloc]initWithItems:_toolItems frame:CGRectMake(0, barY, self.view.frame.size.width, barHeight)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_toolbar];
}


- (void)onItemClick:(TFPhotoToolItem *)item {
    

}

-(void) onViewClick:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        NSInteger tag = ((UIButton *)sender).tag;
        switch (tag) {
            case kBrowserLikeTag:
            {
                [TFLogAgent postEvent:@"picture_preview_praise"];
                [self likeTime:sender];
                [self likeTime:self.timeModel type:self.timeType];
                break;
            }
            case kBrowserCommentTag:
            {
                [TFLogAgent postEvent:@"picture_preview_comment"];
                NSString *url  = nil;
                if (self.timeModel.timeId.length) {
                    if (self.timeModel.circleId.length) {
//                        url = [NSString stringWithFormat:@"/timeDetail/%@/%@/%@/%@/%@/%@",@(ListTypeCircleTimeDetail),self.timeModel.timeId,@(DetailTypeTimeDetail),@(YES),@(0),self.timeModel.circleId];
                    }else {
//                        url = [NSString stringWithFormat:@"/timeDetail/%@/%@/%@/%@/%@",@(ListTypeTimeDetail),self.timeModel.timeId,@(DetailTypeTimeDetail),@(YES),@(0)];
                        
                    }
                } else if (self.timeModel.topicId.length) {
                }
                if (!url.length) {
                    return ;
                }
                UIViewController *vc = [[HHRouter shared] matchController:url];

                TNavigationViewController *navController = [[TNavigationViewController alloc] initWithRootViewController:vc];
                [self presentViewController:navController animated:YES completion:nil];
                break;
            }
//            case kBrowserDeleteTag: {
//                [TFLogAgent postEvent:@"record_time_delete_picture"];
//                TFPhoto *photo = (TFPhoto *)[self photoAtIndex:_currentPageIndex];
//                if (photo) {
//                    TFLog(@"current url:%@",photo.photoURL);
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_DELETE_POSTIMAGE
//                                                                        object:nil
//                                                                      userInfo:@{@"URL":photo.photoURL}];
//                    [_photoDatas removeObjectAtIndex:_currentPageIndex];
//                    [self reloadData];
//
//                    [_toolbar setTotalCount:[_photoDatas count]];
//                    [self updateHeadbarState];
//                }
//            }

                break;
            default:
                break;
        }
    }
}

-(void) likeTime:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        NSUInteger count = 1;
        if ([button titleForState:UIControlStateNormal]) {
            count += [[button titleForState:UIControlStateNormal] integerValue];
        }
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
    } else {
        if ([button titleForState:UIControlStateNormal]) {
            NSUInteger count = [[button titleForState:UIControlStateNormal] integerValue];
            count -= 1;
            if (count <= 0) {
                [button setTitle:NSLocalizedString(@"赞", nil) forState:UIControlStateNormal];

            } else {
                [button setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - Actions

- (void)savePhoto {
    [TFLogAgent postEvent:@"picture_preview_save"];
    id <TFPhoto> photo = [self photoAtIndex:_currentPageIndex];
    if ([photo underlyingImage]) {
        [self performSelector:@selector(actuallySavePhoto:) withObject:photo afterDelay:0];
    }
}

- (void)actuallySavePhoto:(id<TFPhoto>)photo {
    if ([photo underlyingImage]) {
        UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"图片保存失败", nil)];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片保存成功", nil)];
    }
}


@end
