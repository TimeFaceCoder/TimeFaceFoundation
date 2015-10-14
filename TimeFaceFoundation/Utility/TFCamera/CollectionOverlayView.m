//
//  CollectionOverlayView.m
//  TimeFaceV2
//
//  Created by Melvin on 11/26/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "CollectionOverlayView.h"

@interface CollectionCheckmarkView : UIView

@end
@implementation CollectionCheckmarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(24.0, 24.0);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillEllipseInRect(context, self.bounds);
    
    // Body
    CGContextSetRGBFillColor(context, 20.0/255.0, 111.0/255.0, 223.0/255.0, 1.0);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1.2);
    
    CGContextMoveToPoint(context, 6.0, 12.0);
    CGContextAddLineToPoint(context, 10.0, 16.0);
    CGContextAddLineToPoint(context, 18.0, 8.0);
    
    CGContextStrokePath(context);
}

@end


@interface CollectionOverlayView()

@property (nonatomic, strong) UIImageView *checkmarkView;

@end

@implementation CollectionOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        
        self.backgroundColor = [UIColor clearColor];
        
        // Create a checkmark view
        
        _checkmarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SimpleBookUnChecked"]];
        _checkmarkView.highlightedImage = [UIImage imageNamed:@"SimpleBookChecked"];
        _checkmarkView.tfTop = 4;
        _checkmarkView.userInteractionEnabled = NO;
        _checkmarkView.tfLeft = self.tfWidth - _checkmarkView.tfWidth - 4;
        
        
        [self addSubview:_checkmarkView];
    }
    
    return self;
}

- (void)checkMark:(BOOL)selected {
    _checkmarkView.highlighted = selected;
}
@end
