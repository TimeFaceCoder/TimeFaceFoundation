//
//  TFStickerFlowLayout.h
//  TimeFaceV2
//
//  Created by Melvin on 3/23/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFStickerFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat singleCellWidth;
@property (nonatomic, assign) NSInteger maxCellSpace;
@property (nonatomic, assign) BOOL forceCellWidthForMinimumInteritemSpacing;
@property (nonatomic, assign) NSInteger fullImagePercentageOfOccurrency;

@end
