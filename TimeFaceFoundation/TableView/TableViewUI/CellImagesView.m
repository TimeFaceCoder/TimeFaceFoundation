//
//  CellImagesView.m
//  TimeFaceV2
//
//  Created by Melvin on 12/26/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "CellImagesView.h"
#import "UIImageView+TFCache.h"
#import "UIImageView+TFSelect.h"


const static NSInteger kTag = 100;

@interface CellImagesView()<UIGestureRecognizerDelegate> {
    
}
@end

@implementation CellImagesView

- (id)initWithFrame:(CGRect)frame imageCount:(NSInteger)imageCount
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _padding = 5.0f;
        _linePadding = 5.0f;
        _imageSize = CGSizeMake(92, 76);
        _maxCellsNum = 3;
        _maxImageCount = 9;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //[self initImageViews];
        
    }
    return self;
}

- (void)onImageViewTap:(UIGestureRecognizer *)gestureRecognizer {
    UIView *piece = gestureRecognizer.view;
    if ([piece isKindOfClass:[TFSTimeImageView class]]) {
        TFSTimeImageView *imageView = (TFSTimeImageView *)piece;
        if (_imageClickBlock) {
            _imageClickBlock(imageView.tag - kTag);
        }
    }
}

- (void)reUserImagesView {
    for (int i = 0; i < _maxImageCount; i ++) {
        TFSTimeImageView *imageView = (TFSTimeImageView *)[self viewWithTag:kTag + i];
        imageView = nil;
        
        imageView.hidden = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_imageClickBlock) {
        return YES;
    }
    return NO;
}


+(CGFloat)imagesViewHeight:(NSInteger)maxImageCount
               maxCellsNum:(NSInteger)maxCellsNum
               imageHeight:(CGFloat)imageHeight
                   padding:(CGFloat)padding {
    
    CGFloat hegith = imageHeight + padding;
    if (maxImageCount > 9) {
        maxImageCount = 9;
    }
    
    if (maxImageCount%maxCellsNum == 0) {
        //整除
        hegith = (maxImageCount/maxCellsNum)*imageHeight + (maxImageCount/maxCellsNum - 1)*padding;
    }
    else {
        hegith = (maxImageCount/maxCellsNum + 1)*imageHeight + (maxImageCount/maxCellsNum)*padding;
    }
    return hegith;
}

- (void)initImageViews {
    CGFloat left = 0;
    CGFloat top = 0;
    for (int i=0; i<_maxImageCount; i++) {
        top = _linePadding*(i/_maxCellsNum) + _imageSize.height*(i/_maxCellsNum);
        left = (_imageSize.width + _padding)*(i%_maxCellsNum);
        NSInteger tag = kTag + i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(left, top, _imageSize.width, _imageSize.height)];
        imageView.image = [UIImage imageNamed:@"CellImageDefault.png"];
        imageView.tag = tag;
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(onImageViewTap:)];
        imageClick.delegate = self;
        [imageView addGestureRecognizer:imageClick];
        [self addSubview:imageView];
    }
}

- (void)loadImageList:(NSArray *)imageList {
    [self setMaxImageCount:[imageList count]];
    TFLog(@"imageList:%@ image size:%@",imageList,NSStringFromCGSize(_imageSize));
    if ([imageList count] > 0) {
        _empty = NO;
        NSString *imageCut = [NSString stringWithFormat:@"!m%.0fx%.0f.jpg",_imageSize.width*2,_imageSize.height*2];
        for (int i = 0; i < [imageList count]; i ++) {
            __weak UIImageView *imageView = (UIImageView *)[self viewWithTag:kTag + i];
            if (imageView) {
                imageView.hidden = NO;
                [imageView tf_setImageWithURL:[NSURL URLWithString:[[imageList objectAtIndex:i] stringByAppendingString:imageCut]]
                             placeholderImage:[UIImage imageNamed:@"CellImageDefault.png"] animated:YES faceAware:NO];
            }
        }
    }
    else {
        _empty = YES;
    }
}

- (void)initImageViewsSTime {
    CGFloat left = 0;
    CGFloat top = 0;
    for (int i=0; i<_maxImageCount; i++) {
        top = _linePadding*(i/_maxCellsNum) + _imageSize.height*(i/_maxCellsNum);
        left = (_imageSize.width + _padding)*(i%_maxCellsNum) + _padding * 2;
        NSInteger tag = kTag + i;
        TFSTimeImageView *tfStimeView = [[TFSTimeImageView alloc] initWithFrame:
                                  CGRectMake(left, top, _imageSize.width, _imageSize.height)];
        tfStimeView.imageView.image = [UIImage imageNamed:@"CellImageDefault.png"];
        tfStimeView.tag = tag;
        tfStimeView.hidden = YES;
        tfStimeView.imageView.clipsToBounds = YES;
        tfStimeView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        tfStimeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(onImageViewTap:)];
        imageClick.delegate = self;
        [tfStimeView addGestureRecognizer:imageClick];
        [self addSubview:tfStimeView];
    }
}

//- (void)loadImageListSTime:(NSArray *)imageList tag:(NSInteger)tag {
////    TFLog(@"imageList:%@ image size:%@",imageList,NSStringFromCGSize(_imageSize));
//    self.tagSelectImage = tag;
//    if ([imageList count] > 0) {
//        _empty = NO;
//        NSString *imageCut = [NSString stringWithFormat:@"!m%.0fx%.0f.jpg",_imageSize.width*2,_imageSize.height*2];
//        for (int i = 0; i < [imageList count]; i ++) {
//            NSInteger index = kTag + i;
//            UIView *view = [self viewWithTag:index];
//            __weak TFSTimeImageView *tfSTimeView = (TFSTimeImageView *)view;
//            if (tfSTimeView.imageView) {
//                tfSTimeView.hidden = NO;
//                TimeImageModel *model = [imageList objectAtIndex:i];
//                [tfSTimeView setImageWithName:model.imageUrl imageCut:[model.imageUrl stringByAppendingString:imageCut]];
//                [tfSTimeView setImageSelected:model.selected];
//                tfSTimeView.selectedIcon.tag = _tagSelectImage + 1;
//            }
//        }
//    }
//    else {
//        _empty = YES;
//    }
//}


@end
