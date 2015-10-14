//
//  TFCameraViewCollectionViewCell.h
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCameraViewCollectionViewCellDelegate <NSObject>
@optional;
- (void)cameraViewDidAppear;
- (void)cameraViewDidDisappear;

@end

@interface TFCameraViewCollectionViewCell : UICollectionViewCell

@property (nonatomic ,weak) id<TFCameraViewCollectionViewCellDelegate> delegate;
- (void)startCamera;
- (void)removeCamera;

@end
