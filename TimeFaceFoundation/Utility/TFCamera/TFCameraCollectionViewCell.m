//
//  TFCameraCollectionViewCell.m
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFCameraCollectionViewCell.h"
#import "CollectionOverlayView.h"
#import <pop/POP.h>


@interface TFCameraCollectionViewCell()

@property (nonatomic, strong) CollectionOverlayView *overlayView;

@end

@implementation TFCameraCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.itemImage];
        [self.contentView addSubview:self.overlayView];
        
        _overlayView.hidden = YES;
        
    }
    return self;
}

- (UIImageView *) itemImage
{
    if( !_itemImage ) {
        _itemImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [_itemImage setBackgroundColor:[UIColor clearColor]];
        [_itemImage setContentMode:UIViewContentModeScaleAspectFill];
        [_itemImage setClipsToBounds:YES];
    }
    
    return _itemImage;
}

- (void)updateItemImage:(UIImage *)image {
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [self.itemImage setImage:image];
    [[self.itemImage layer] addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        _overlayView.hidden = NO;
    }
}

- (CollectionOverlayView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[CollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _overlayView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected && self.showsOverlayViewWhenSelected) {
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
    [_overlayView checkMark:selected];
}

- (void)setShowsOverlayViewWhenSelected:(BOOL)showsOverlayViewWhenSelected {
    _showsOverlayViewWhenSelected = showsOverlayViewWhenSelected;
    _overlayView.hidden = !_showsOverlayViewWhenSelected;
}

- (void)showOverlayView {
    POPBasicAnimation *backgroundColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    backgroundColorAnimation.toValue = RGBACOLOR(0, 0, 0, .5);
    [self.overlayView pop_addAnimation:backgroundColorAnimation forKey:@"showBackgroundColorAnimation"];
}

- (void)hideOverlayView {
    POPBasicAnimation *backgroundColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    backgroundColorAnimation.toValue = [UIColor clearColor];
    [self.overlayView pop_addAnimation:backgroundColorAnimation forKey:@"hideBackgroundColorAnimation"];
}

- (void)setViewType:(CollectionViewType)viewType {
    _viewType = viewType;
    if (_viewType == CollectionViewTypeLibrary) {
        //打开相册选择界面
    }
}



@end
