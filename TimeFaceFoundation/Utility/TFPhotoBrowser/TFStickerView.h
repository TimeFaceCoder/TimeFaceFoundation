//
//  TFStickerView.h
//  TimeFaceV2
//
//  Created by Melvin on 3/16/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TFStickerViewDelegate<NSObject>
- (void)didStickerSelected:(NSString *)stickerPath;
- (void)didStickerClose:(BOOL)close;


@end

@interface TFStickerView : UIView

@property (nonatomic ,weak) id<TFStickerViewDelegate> delegate;

- (void)updateArrowState:(BOOL)selected;

@end
