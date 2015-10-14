//
//  CellImagesView.h
//  TimeFaceV2
//
//  Created by Melvin on 12/26/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellImagesView : UIView

typedef void (^ImageClickBlock)(NSInteger index);


/**
 *  图片间距
 */
@property (nonatomic ,assign) CGFloat            padding;
/**
 *  图片上下间距
 */
@property (nonatomic ,assign) CGFloat            linePadding;
/**
 *  图片尺寸
 */
@property (nonatomic ,assign) CGSize             imageSize;

@property (nonatomic ,assign) NSInteger          maxImageCount;

@property (nonatomic ,assign) NSInteger          maxCellsNum;

@property (nonatomic ,assign) BOOL               empty;

@property (nonatomic ,strong) ImageClickBlock    imageClickBlock;

@property (nonatomic ,assign) NSInteger               tagSelectImage;


/**
 *  图片控件高度计算
 *
 *  @param maxImageCount
 *  @param maxCellsNum
 *  @param imageHeight
 *  @param padding
 *
 *  @return
 */
+(CGFloat)imagesViewHeight:(NSInteger)maxImageCount
               maxCellsNum:(NSInteger)maxCellsNum
               imageHeight:(CGFloat)imageHeight
                   padding:(CGFloat)padding;

- (void)reUserImagesView;

- (id)initWithFrame:(CGRect)frame imageCount:(NSInteger)imageCount;
- (void)initImageViews;
- (void)loadImageList:(NSArray *)imageList;

- (void)initImageViewsSTime;
//- (void)loadImageListSTime:(NSArray *)imageList tag:(NSInteger)tag;

@end
