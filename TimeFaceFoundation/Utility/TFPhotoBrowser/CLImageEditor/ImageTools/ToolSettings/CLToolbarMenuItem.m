//
//  CLToolbarMenuItem.m
//
//  Created by sho yakushiji on 2013/12/11.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLToolbarMenuItem.h"

#import "CLImageEditorTheme+Private.h"
#import "UIView+Frame.h"

@implementation CLToolbarMenuItem
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = 5;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.top = (self.height - _iconView.height) / 2;
        _iconView.left = (self.width - _iconView.width) / 2;
//        _iconView.center = self.center;
        [self addSubview:_iconView];
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [CLImageEditorTheme toolbarTextColor];
        _titleLabel.font = [CLImageEditorTheme toolbarTextFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(CLImageToolInfo*)toolInfo
{
    self = [self initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        
        self.toolInfo = toolInfo;
    }
    return self;
}

- (NSString*)title
{
    return _titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _titleLabel.top = self.height - _titleLabel.height - 4;
    _titleLabel.tfCenterX = _iconView.tfCenterX;
}

- (UIImageView*)iconView
{
    return _iconView;
}

- (UIImage*)iconImage
{
    return _iconView.image;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconView.image = iconImage;
    _iconView.tfSize = iconImage.size;
    _iconView.top = (self.height - iconImage.size.height) / 2;
    _iconView.left = (self.width - iconImage.size.width) / 2;
}

- (UIImage*)iconImageH
{
    return _iconView.highlightedImage;
}

- (void)setIconImageH:(UIImage *)iconImageH {
    _iconView.highlightedImage = iconImageH;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}

- (void)setToolInfo:(CLImageToolInfo *)toolInfo
{
    [super setToolInfo:toolInfo];
    
    self.title = self.toolInfo.title;
    if(self.toolInfo.iconImagePath){
        self.iconImage = self.toolInfo.iconImage;
    }
    else{
        self.iconImage = nil;
    }
}

- (void)setSelected:(BOOL)selected
{
    if(selected != _selected){
        _selected = selected;
        if(selected){
            _iconView.layer.borderColor = [[CLImageEditorTheme toolbarSelectedButtonColor] CGColor];
            _iconView.layer.borderWidth = 1.5;
            
        }
        else{
            _iconView.layer.borderColor = [[UIColor clearColor] CGColor];
            _iconView.layer.borderWidth = 0;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconView.left = (self.width - _iconView.width) / 2;
    _iconView.top = (self.height - _iconView.height) / 2;
    
    if (_titleLabel.text.length) {
        _iconView.top = 6;
        _titleLabel.top = _iconView.bottom + 6;
    }
}

@end

