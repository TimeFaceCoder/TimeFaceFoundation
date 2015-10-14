//
//  TFImageEditorFrameView.m
//  TimeFaceV2
//
//  Created by Melvin on 12/23/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFImageEditorFrameView.h"

@interface TFImageEditorFrameView() {
    
}

@property (nonatomic,strong) UIImageView *imageView;

@end


@implementation TFImageEditorFrameView

@synthesize cropRect = _cropRect;

- (void) initialize
{
    self.opaque = NO;
    self.layer.opacity = 0.7;
    self.backgroundColor = [UIColor clearColor];
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}



- (void)setCropRect:(CGRect)cropRect
{
    if(!CGRectEqualToRect(_cropRect,cropRect)){
        _cropRect = CGRectOffset(cropRect, self.frame.origin.x, self.frame.origin.y);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] setFill];
        UIRectFill(self.bounds);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
        CGContextStrokeRect(context, cropRect);
        [[UIColor clearColor] setFill];
        UIRectFill(CGRectInset(cropRect, 1, 1));
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}

@end
