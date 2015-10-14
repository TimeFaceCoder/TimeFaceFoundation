//
//  TFStickerCollectionViewCell.m
//  TimeFaceV2
//
//  Created by Melvin on 3/23/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFStickerCollectionViewCell.h"
#import <pop/POP.h>

@interface TFStickerCollectionViewCell()


@end

@implementation TFStickerCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imageView];
        self.backgroundColor = [UIColor darkTextColor];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.tfSize = self.tfSize;
}

@end
