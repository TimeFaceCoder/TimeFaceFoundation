//
//  TFAlertView.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFAlertView.h"
#import "Utility.h"
#import "TFDefaultStyle.h"
#import <GPUImage/GPUImage.h>
#import <pop/POP.h>

@interface TFAlertView()

@property (nonatomic ,strong) UIImageView   *blurImageView;
/**
 *  alert 主内容View
 */
@property (nonatomic ,strong) UIView        *contentView;
/**
 *  标题label
 */
@property (nonatomic ,strong) UILabel       *titleLabel;
/**
 *  内容label
 */
@property (nonatomic ,strong) UILabel       *contentLabel;
/**
 *  默认按钮
 */
@property (nonatomic ,strong) UIButton      *firstButton;
/**
 *  第二个按钮
 */
@property (nonatomic ,strong) UIButton      *secondButton;
/**
 *  石榴仔手部图片
 */
@property (nonatomic ,strong) UIImageView   *leftHandImageView;
@property (nonatomic ,strong) UIImageView   *rightHandImageView;
/**
 *  石榴仔头部图片
 */
@property (nonatomic ,strong) UIImageView   *faceImageView;

//@property (nonatomic ,strong) GPUImageiOSBlurFilter *blurFilter;


/**
 *  弹出样式
 */
@property (nonatomic ,assign) AlertType         alertType;

@property (nonatomic ,copy)   NSString          *title;
@property (nonatomic ,copy)   NSString          *content;

//@property (nonatomic ,weak)   AlertClickBlock   clickBlock;

@property (nonatomic, copy) void (^AlertClickBlock)(NSInteger index);


@property (nonatomic ,copy)   NSString          *firstButtonTitle;

@property (nonatomic ,copy)   NSString          *secondButtonTitle;

@end

const static CGFloat kContentPadding    = 24.0f;
const static CGFloat kViewPadding       = 15.0f;
const static CGFloat kButtonHeight      = 34.0f;
const static CGFloat kCornerRadius      = 8.0f;
const static NSInteger kFirstButtonTag  = 100;
const static NSInteger kSecondButtonTag = 101;

@implementation TFAlertView

+ (id)showAlertWithTitle:(NSString *)title
                   content:(NSString *)content
                 alertType:(AlertType)alertType
                clickBlock:(AlertClickBlock)clickBlock {
    TFAlertView *alertView = [[TFAlertView alloc] initWithTitle:title
                                                        content:content
                                                      alertType:alertType
                                                     clickBlock:clickBlock];
    [alertView show];
    return alertView;
}

+ (id)showAlertWithTitle:(NSString *)title
                 content:(NSString *)content
              fisrtTitle:(NSString *)fisrtTitle
             secondTitle:(NSString *)secondTitle
               alertType:(AlertType)alertType
              clickBlock:(AlertClickBlock)clickBlock {
    
    TFAlertView *alertView = [[TFAlertView alloc] initWithTitle:title
                                                        content:content
                                                     fisrtTitle:fisrtTitle
                                                    secondTitle:secondTitle
                                                      alertType:alertType
                                                     clickBlock:clickBlock];
    [alertView show];
    return alertView;
}


- (id)initWithTitle:(NSString *)title content:(NSString *)content
         fisrtTitle:(NSString *)fisrtTitle
        secondTitle:(NSString *)secondTitle alertType:(AlertType)alertType
         clickBlock:(AlertClickBlock)clickBlock {
    self = [super init];
    if (self) {
        self.frame = TTScreenBounds();
        self.title = title;
        self.content = content;
        self.alertType = alertType;
        self.AlertClickBlock = clickBlock;
        if (fisrtTitle) {
            [self setFirstButtonTitle:fisrtTitle];
        }
        else {
            [self setFirstButtonTitle:NSLocalizedString(@"确定", nil)];
        }
        if (secondTitle) {
            [self setSecondButtonTitle:secondTitle];
        }else {
            [self setSecondButtonTitle:NSLocalizedString(@"取消", nil)];
        }
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];

        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleClick:)];
        [self addGestureRecognizer:viewTap];
//        
//        //init view
//        _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
//        _blurFilter.blurRadiusInPixels = 1.0;
//        
//        
//        //毛玻璃背景
//        UIImage *blurredSnapshotImage = [_blurFilter imageByFilteringImage:[self currentViewToImage]];
//        [self.blurImageView setImage:blurredSnapshotImage];
        [self.blurImageView setImage:[[[Utility sharedUtility] currentViewToImage] blurredImage]];

        _blurImageView.layer.opacity = 0.0;
        _blurImageView.userInteractionEnabled = NO;
        [self addSubview:_blurImageView];
        
        
        //主体view
        [self addSubview:self.contentView];
        
        
        
        //线条
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kContentPadding, 54, _contentView.tfWidth - kContentPadding*2, .5)];
        line1.backgroundColor = TFSTYLEVAR(lineColor);
        [_contentView addSubview:line1];
 
        if (self.title.length) {
            self.titleLabel.text = self.title;
            self.titleLabel.tfTop = kContentPadding;
            self.titleLabel.tfLeft = kContentPadding;
            self.titleLabel.tfWidth = self.tfWidth - kContentPadding * 2;
            [self.titleLabel sizeToFit];

            [_contentView addSubview:self.titleLabel];
        }
        CGFloat top = line1.tfBottom + 20.f;
        if (self.content.length) {
            self.contentLabel.text = self.content;
            self.contentLabel.tfTop = top;
            self.contentLabel.tfLeft = kContentPadding;
            self.contentLabel.tfWidth = self.tfWidth - kContentPadding * 3;
            [self.contentLabel sizeToFit];

            [_contentView addSubview:self.contentLabel];
            
            top = self.contentLabel.tfBottom + 20;
        }
        
        if (self.alertType == AlertInfo) {
            CGFloat buttonWidth = (_contentView.tfWidth - kContentPadding*3)/2;
            self.firstButton.tfSize = CGSizeMake(buttonWidth, kButtonHeight);
            self.firstButton.tfLeft = kContentPadding;
            self.firstButton.tfTop = top;
            
            self.secondButton.tfSize = CGSizeMake(buttonWidth, kButtonHeight);
            self.secondButton.tfLeft = _contentView.tfWidth - kContentPadding - buttonWidth;
            self.secondButton.tfTop = self.firstButton.tfTop;
            
            [_contentView addSubview:self.firstButton];
            [_contentView addSubview:self.secondButton];
            
        }
        else {
            self.firstButton.tfSize = CGSizeMake(_contentView.tfWidth - kViewPadding * 2, kButtonHeight);
            self.firstButton.tfLeft = kViewPadding;
            self.firstButton.tfTop = top;
            [_contentView addSubview:self.firstButton];
        }
        self.contentView.tfHeight = self.firstButton.tfBottom + 20;
        
        //石榴仔
        [_contentView addSubview:self.leftHandImageView];
        [_contentView addSubview:self.rightHandImageView];
        
//        _leftHandImageView.top = _contentView.top - _leftHandImageView.height / 2;
        _leftHandImageView.tfTop = _contentView.tfTop  - 10;
        _leftHandImageView.tfLeft = 24;
        
//        _rightHandImageView.top = _contentView.top - _rightHandImageView.height / 2;
        _rightHandImageView.tfTop = _contentView.tfTop - 10;
        _rightHandImageView.tfLeft = _contentView.tfWidth - 24 - _rightHandImageView.tfWidth;
        
//        [self insertSubview:self.faceImageView belowSubview:_contentView];
        [self addSubview:self.faceImageView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
          alertType:(AlertType)alertType
         clickBlock:(AlertClickBlock)clickBlock {
    return [self initWithTitle:title
                       content:content
                    fisrtTitle:nil
                   secondTitle:nil
                     alertType:alertType
                    clickBlock:clickBlock];
}

#pragma mark - Public

/**
 *  弹出alert view
 */
- (void)show {

    //背景显示动画
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    [_blurImageView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    //主view位移动画
    CGRect frame = _contentView.frame;
    frame.origin.x = (CGRectGetWidth(TTScreenBounds()) - _contentView.tfWidth ) / 2;
    frame.origin.y = (CGRectGetHeight(TTScreenBounds()) - _contentView.tfHeight ) / 2;
    
    CGRect faceFrame = _faceImageView.frame;
    faceFrame.origin.y = frame.origin.y - 112;
    
    
    POPBasicAnimation *faceShowAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    faceShowAnimation.toValue = @(1);
    [faceShowAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
       
    }];
    
    
    POPSpringAnimation *faceAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    faceAnimation.toValue = [NSValue valueWithCGRect:faceFrame];
//    faceAnimation.springBounciness = 10;
    [faceAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:.35 animations:^{
//            [self bringSubviewToFront:self.faceImageView];
            [_contentView sendSubviewToBack:self.faceImageView];
        }];    }];
    
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    positionAnimation.toValue = [NSValue valueWithCGRect:frame];
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //石榴仔移动
        [_leftHandImageView.layer pop_addAnimation:opacityAnimation forKey:@"handAlpha"];
        [_rightHandImageView.layer pop_addAnimation:opacityAnimation forKey:@"handAlpha"];
        
        [_faceImageView.layer pop_addAnimation:faceShowAnimation forKey:@"faceShowAnimation"];
        [_faceImageView pop_addAnimation:faceAnimation forKey:@"faceAnimation"];
    }];
    
    
    [_contentView pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
}

/**
 *  关闭 alert view
 */
- (void)dismiss {

    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(0);
    [_contentView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
    [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [_blurImageView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [_faceImageView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
}

#pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = TFSTYLEVAR(defaultBlueColor);
        _titleLabel.font = TFSTYLEVAR(font16);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = TFSTYLEVAR(textColor);
        _contentLabel.font = TFSTYLEVAR(font16);
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 6;
    }
    return _contentLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(TTScreenBounds()) - kViewPadding*2, 200)];
        _contentView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1];
        [_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [_contentView.layer setShadowOpacity:0.4];
        [_contentView.layer setShadowRadius:20.0f];
        [_contentView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
        [_contentView.layer setCornerRadius:8];

    }
    return _contentView;
}

- (UIImageView *)leftHandImageView {
    if (!_leftHandImageView) {
        _leftHandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlertViewLeftHand"]];
        _leftHandImageView.layer.opacity = 0.0;
    }
    return _leftHandImageView;
}

- (UIImageView *)rightHandImageView {
    if (!_rightHandImageView) {
        _rightHandImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlertViewRightHand"]];
        _rightHandImageView.layer.opacity = 0.0;
    }
    return _rightHandImageView;
}

- (UIImageView *)faceImageView {
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc] init];
        if (_alertType == AlertSuccess) {
            _faceImageView.image = [UIImage imageNamed:@"AlertSuccessFace.png"];
        }
        if (_alertType == AlertFailure) {
            _faceImageView.image = [UIImage imageNamed:@"AlertInfoFace.png"];
        }
        if (_alertType == AlertInfo) {
            _faceImageView.image = [UIImage imageNamed:@"AlertInfoFace.png"];
        }
        [_faceImageView sizeToFit];
        
        _faceImageView.tfLeft = (CGRectGetWidth(TTScreenBounds()) - _faceImageView.tfWidth ) / 2;
        _faceImageView.tfTop = (CGRectGetHeight(TTScreenBounds()) - _faceImageView.tfHeight ) / 2;
        _faceImageView.layer.opacity = 0.0;
    }
    return _faceImageView;
}

- (UIImageView *)blurImageView {
    if (!_blurImageView) {
        _blurImageView = [[UIImageView alloc] initWithFrame:TTScreenBounds()];
    }
    return _blurImageView;
}

-(UIImage *)currentViewToImage {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}

- (UIButton *)firstButton {
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton setBackgroundColor:TFSTYLEVAR(defaultBlueColor)];
        [_firstButton addTarget:self action:@selector(onViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_firstButton setTitle:self.firstButtonTitle forState:UIControlStateNormal];
        [_firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_firstButton titleLabel] setFont:TFSTYLEVAR(font15)];
        [_firstButton setTag:kFirstButtonTag];
        [_firstButton.layer setCornerRadius:kCornerRadius];

    }
    return _firstButton;
}

- (UIButton *)secondButton {
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondButton setBackgroundColor:TFSTYLEVAR(alertCancelColor)];
        [_secondButton addTarget:self action:@selector(onViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secondButton setTitle:self.secondButtonTitle forState:UIControlStateNormal];
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_secondButton titleLabel] setFont:TFSTYLEVAR(font15)];
        [_secondButton setTag:kSecondButtonTag];
        [_secondButton.layer setCornerRadius:kCornerRadius];

    }
    return _secondButton;
}

- (void)handleClick:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    if (!CGRectContainsPoint(_contentView.frame, point)) {
        [self dismiss];
    }
}

- (void)onViewClick:(UIButton *)sender {
    NSInteger index = 0;
    if (sender.tag == kFirstButtonTag) {
        index = 1;
    } else if (sender.tag == kSecondButtonTag) {
        index = 2;
    }
    if (self.AlertClickBlock) {
        self.AlertClickBlock(index);
    }
    [self dismiss];
}


@end
