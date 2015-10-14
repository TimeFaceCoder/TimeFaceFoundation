//
//  TFLibraryViewCollectionViewCell.m
//  TimeFaceV2
//
//  Created by Melvin on 1/28/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFLibraryViewCollectionViewCell.h"

@implementation TFLibraryViewCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LibraryOpenOther"]];
        imageView.center = self.contentView.center;
        [self.contentView addSubview:imageView];
        
        self.contentView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.5];
    }
    return self;
}


@end
