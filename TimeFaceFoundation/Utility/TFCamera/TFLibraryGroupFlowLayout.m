//
//  TFLibraryGroupFlowLayout.m
//  TimeFaceV2
//
//  Created by Melvin on 12/12/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFLibraryGroupFlowLayout.h"


@implementation TFLibraryGroupFlowLayout
@dynamic  scrollDirection;
-(id) init
{
    self = [super init];
    if ( self ) {
        CGFloat size = (CGRectGetWidth(TTScreenBounds()) - VIEW_LEFT_SPACE*4 ) / 3;
        if (CGRectGetWidth(TTScreenBounds()) > 320) {
            [self setItemSize:(CGSize){ size, size*1.18 }];
        }
        else {
            [self setItemSize:(CGSize){ 136, 160 }];
        }
        [self setScrollDirection:UICollectionViewScrollDirectionVertical];
        [self setSectionInset:UIEdgeInsetsMake(VIEW_LEFT_SPACE, VIEW_LEFT_SPACE, VIEW_LEFT_SPACE, VIEW_LEFT_SPACE)];
        [self setMinimumLineSpacing:VIEW_LEFT_SPACE];
        [self setMinimumInteritemSpacing:6];
    }
    return self;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

@end
