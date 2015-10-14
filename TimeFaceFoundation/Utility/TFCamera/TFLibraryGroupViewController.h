//
//  TFLibraryGroupViewController.h
//  TimeFaceV2
//  本机相册选择界面
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TSubViewController.h"
#import "TFCameraDelegate.h"

@interface TFLibraryGroupViewController : UIViewController

@property (nonatomic ,weak) id<TFLibraryGroupDelegate>      delegate;
@property (nonatomic, strong, readonly) UICollectionView    *collectionView;

@end

