//
//  TFCameraDelegate.h
//  TimeFaceV2
//
//  Created by Melvin on 11/26/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  照片选择回调
 */
@protocol TFLibraryViewControllerDelegate <NSObject>

@optional
- (void)didSelectAssets:(NSArray *)assets removeList:(NSArray *)removeList infos:(NSMutableArray *)infos;
- (void)didSelectImage:(UIImage *)image;
/**
 *  是否使用图片剪裁
 *
 *  @return
 */
- (BOOL)useImageCrop;
/**
 *  图片检测尺寸
 *
 *  @return 
 */
- (CGSize)sizeOfImageCrop;

@end

/**
 *  相册选择回调
 */
@protocol TFLibraryGroupDelegate <NSObject>

@required
- (void)didSelectedLibraryGroup:(ALAssetsGroup *)group;


@end

/**
 *  相机拍照回调
 */
@protocol TFCameraViewControllerDelegate <NSObject>


@end

/**
 *  照片编辑回调
 */
@protocol TFImageEditorViewControllerDelegate <NSObject>


@end
