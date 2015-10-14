//
//  TFLibraryViewController.h
//  TimeFaceV2
//  本机相册内照片选择界面
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFCameraDelegate.h"


@interface TFLibraryViewController : UIViewController

@property (nonatomic, weak) id<TFLibraryViewControllerDelegate> libraryControllerDelegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *selectedAssets;
@property (nonatomic, strong) NSMutableArray   *items;
@property (nonatomic, strong) NSMutableArray   *photos;
@property (nonatomic, strong) NSDictionary     *expandData;
@property (nonatomic, assign) BOOL             allowsMultipleSelection;
@property (nonatomic, assign) BOOL             allowsImageCrop;
@property (nonatomic, assign) NSUInteger       minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger       maximumNumberOfSelection;


@end
