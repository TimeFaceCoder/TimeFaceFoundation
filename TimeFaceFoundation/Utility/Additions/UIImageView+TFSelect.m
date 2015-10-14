//
//  UIImageView+TFSelect.m
//  TimeFace
//
//  Created by zguanyu on 3/17/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "UIImageView+TFSelect.h"
#import "UIImageView+TFCache.h"

#define kDistance  3.0f
#define kIconWidth 15.0f

@implementation TFSTimeImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.select = YES;
        [self addSubview:self.imageView];
        
        [self addSubview:self.selectedIcon];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setImageWithName:(NSString *)url imageCut:(NSString *)imageCut{
    self.imageUrl = url;
    NSString *image = [NSString stringWithFormat:@"%@!m%.0fx%.0f.jpg",url,(self.tfWidth - kDistance) * 2,(self.tfHeight - kDistance) * 2];
    NSURL *imageUrl = [NSURL URLWithString:image];
    TFLog(@"imageUrl = %@ _imageView = %@",imageUrl,_imageUrl);
    [self.imageView tf_setImageWithURL:imageUrl
                 placeholderImage:[UIImage imageNamed:@"CellImageDefault"] animated:YES faceAware:NO];
//    if (url.selected) {
//        [self setImageSelected:url.selected];
//    }
}

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.tfWidth = self.tfWidth -kDistance;
        _imageView.tfHeight = self.tfHeight - kDistance;
        _imageView.tfTop = kDistance;
        _imageView.tfLeft = 0;
        _imageView.userInteractionEnabled = YES;
        
    }
    return _imageView;
}

- (void)setImageSelected:(BOOL)select {
    _select = select;
    if (_select) {
        _selectedIcon.image = [UIImage imageNamed:@"circleSelectedRemove"];
        [self.floatingView removeFromSuperview];
    }else {
        _selectedIcon.image = [UIImage imageNamed:@"circleSelectedAdd"];
//        [self addSubview:self.floatingView];
        [self insertSubview:self.floatingView belowSubview:_selectedIcon];
    }
    
}

- (BOOL)select {
    return _select;
}



- (UIImageView*)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc]init];
        _selectedIcon.backgroundColor = [UIColor clearColor];
        _selectedIcon.tfWidth = kIconWidth;
        _selectedIcon.tfHeight = kIconWidth;
        _selectedIcon.tfRight = self.tfWidth;
        _selectedIcon.tfTop = 0;
        
        if (_select) {
            _selectedIcon.image = [UIImage imageNamed:@"circleSelectedRemove"];
        }else {
            _selectedIcon.image = [UIImage imageNamed:@"circleSelectedAdd"];
        }
        
    }
    return _selectedIcon;
}

- (UIView*)floatingView {
    if (!_floatingView) {
        _floatingView = [[UIView alloc]init];
        _floatingView.tfWidth = _imageView.tfWidth;
        _floatingView.tfHeight = _imageView.tfHeight;
        _floatingView.tfLeft = 0;
        _floatingView.tfTop = kDistance;
        _floatingView.backgroundColor = RGBACOLOR(255.0f, 255.0f, 255.0f,.7f);
        _floatingView.userInteractionEnabled = YES;
    }
    return _floatingView;
}




@end
