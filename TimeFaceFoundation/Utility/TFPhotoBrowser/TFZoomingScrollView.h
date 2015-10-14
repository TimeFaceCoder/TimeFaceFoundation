//
//  TFZoomingScrollView.h
//  TimeFaceV2
//
//  Created by Melvin on 1/26/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPhotoProtocol.h"


@class TFPhotoBrowser, TFPhoto ,TFTapDetectingImageView,TFPhotoTagView;


@interface TFZoomingScrollView : UIScrollView


@property (nonatomic ,assign    ) NSUInteger    index;
@property (nonatomic ,assign    ) id <TFPhoto>  photo;
@property (nonatomic ,strong    ) NSMutableArray          *faceFeatures;
@property (nonatomic ,readonly  ) TFTapDetectingImageView *photoImageView;


- (id)initWithPhotoBrowser:(TFPhotoBrowser *)browser;
- (void)displayImageWithDoneBlock:(void (^)(void))doneBlock;
- (void)displayImageFailure;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;
- (void)updatePagePhoto:(id<TFPhoto>)photo;
/**
 *  图片复位
 */
- (void)imageRest;

- (void)faceFeature;

- (void)removeAllTags;


- (CGPoint)normalizedPositionForPoint:(CGPoint)point;

- (void)startNewTagPopover:(TFPhotoTagView *)popover atNormalizedPoint:(CGPoint)normalizedPoint pointOnImage:(CGPoint)pointOnImage;

@end
