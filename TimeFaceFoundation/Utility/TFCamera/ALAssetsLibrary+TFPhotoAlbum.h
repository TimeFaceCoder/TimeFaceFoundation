//
//  ALAssetsLibrary+TFPhotoAlbum.h
//  TimeFaceV2
//
//  Created by Melvin on 12/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(id assetURL,NSError* error);


@interface ALAssetsLibrary (TFPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end
