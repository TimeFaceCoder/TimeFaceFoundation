//
//  TFCameraCollectionViewCell.h
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CollectionViewType) {
    /**
     *  默认
     */
    CollectionViewTypeNone          = 0,
    /**
     *  打开相机
     */
    CollectionViewTypeCamera        = 1,
    /**
     *  打开相册
     */
    CollectionViewTypeLibrary       = 2,
};

@interface TFCameraCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView   *itemImage;
@property (nonatomic, strong) UIImageView   *selectedImageView;
@property (nonatomic, assign) CollectionViewType    viewType;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;


- (void)updateItemImage:(UIImage *)image;


@end
