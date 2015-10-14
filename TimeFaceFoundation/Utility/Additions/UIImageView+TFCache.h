//
//  UIImageView+TFCache.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "SDWebImageManager.h"

@interface UIImageView (TFCache)

/**
 *  加载网络图片
 *
 *  @param url
 *  @param placeholder
 *  @param animated
 *  @param faceAware
 */
- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(SDWebImageCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(SDWebImageCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;


@end
