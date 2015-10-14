//
//  TFPhotoBrowser.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TSubViewController.h"
#import <UIKit/UIKit.h>
#import "TFPhoto.h"
#import "TFPhotoProtocol.h"
#import "TFPhotoToolbar.h"


#define kBrowserLikeTag    3001
#define kBrowserCommentTag 3002
#define kBrowserDeleteTag  3003
#define kBrowserSaveTag    3000

@class TFPhotoBrowser;
@class ImageTagModel;
@class TimeLineModel;

@protocol TFPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(TFPhotoBrowser *)photoBrowser;
- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional
- (NSMutableArray *)photoBrowser:(TFPhotoBrowser *)photoBrowser tagInfosAtIndex:(NSUInteger)index;
- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(TFPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(TFPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser deletePhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index updateURL:(NSURL *)newURL;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didFinishSavingWithError:(NSError *)error;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser updateTagInfo:(NSDictionary *)info index:(NSUInteger)index;
/**
 *  图片tag
 *
 *  @param photoBrowser
 *  @param info
 */
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser infos:(NSMutableArray *)infos;

- (void)updatePhotoInfos:(NSMutableArray *)array photoAtIndex:(NSUInteger)index;

- (void)nextAction;

@end

@interface TFPhotoBrowser : TSubViewController

@property (nonatomic, weak    ) IBOutlet id<TFPhotoBrowserDelegate> delegate;
@property (nonatomic, strong  ) UIScrollView   *menuView;
@property (nonatomic, strong  ) NSMutableArray *tagInfos;
@property (nonatomic, assign  ) BOOL           zoomPhotosToFill;
@property (nonatomic, assign  ) BOOL           browserMode;
@property (nonatomic, assign  ) NSUInteger     delayToHideElements;
@property (nonatomic, readonly) NSUInteger     currentIndex;
@property (nonatomic, readonly) UIImageView    *imageView;
@property (nonatomic, strong  ) NSDictionary   *expandData;
@property (nonatomic, assign  ) BOOL           onlyShow;

@property (nonatomic, copy)   NSMutableArray *toolItems;

// Init
- (id)initWithDelegate:(id <TFPhotoBrowserDelegate>)delegate;

- (void)reloadData;

- (void)setCurrentPhotoIndex:(NSUInteger)index;

- (void)showNextPhotoAnimated:(BOOL)animated;

- (void)showPreviousPhotoAnimated:(BOOL)animated;

/**
 *  配置当前page tag view
 *
 *  @param index
 */
- (void)configurePageTag:(NSUInteger)index;

- (UIImage *)imageForPhoto:(id<TFPhoto>)photo;
// Controls
- (void)lockScrollView;
- (void)toggleControls;
- (void)doubleZoomView;
- (void)longTapOnView:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)onItemClick:(TFPhotoToolItem*)item;

//-(void) refreshTime:(TimeLineModel *)model type:(TimeType)type;

@end
