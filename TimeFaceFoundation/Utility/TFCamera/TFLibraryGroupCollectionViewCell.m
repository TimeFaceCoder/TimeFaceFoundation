//
//  TFLibraryGroupCollectionViewCell.m
//  TimeFaceV2
//
//  Created by Melvin on 12/12/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFLibraryGroupCollectionViewCell.h"
#import "TFDefaultStyle.h"

const static CGFloat kVPadding = 6;

@implementation TFLibraryGroupCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.lasterImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.countLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = TFSTYLEVAR(font12);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}


- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = TFSTYLEVAR(font12);
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.tfLeft = kVPadding;
    }
    return _countLabel;
}

- (UIImageView *)lasterImageView {
    if (!_lasterImageView) {
        CGFloat width = self.contentView.tfWidth - VIEW_LEFT_SPACE;
        CGFloat height = width / 1.1;
        _lasterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_LEFT_SPACE/2, VIEW_LEFT_SPACE/2, width, height)];
        [_lasterImageView setBackgroundColor:[UIColor clearColor]];
        [_lasterImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_lasterImageView setClipsToBounds:YES];
    }
    return _lasterImageView;
}

- (void)updateViews:(UIImage *)image title:(NSString *)title count:(NSInteger)count {
    _lasterImageView.image = image;
    [_titleLabel setText:title];
    
    [_countLabel setText:[NSString stringWithFormat:@"%ld",(long)count]];
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.tfLeft = kVPadding;
    _titleLabel.tfWidth = self.tfWidth - kVPadding*2;
    _titleLabel.tfTop = _lasterImageView.tfBottom + VIEW_LEFT_SPACE/3;
    
    [_countLabel sizeToFit];
    _countLabel.tfLeft = VIEW_LEFT_SPACE/2;
    _countLabel.tfTop = _titleLabel.tfBottom + VIEW_LEFT_SPACE/3.5;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selected) {
        self.contentView.backgroundColor = TFSTYLEVAR(slectedBgColor);
    }
    else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}


@end
