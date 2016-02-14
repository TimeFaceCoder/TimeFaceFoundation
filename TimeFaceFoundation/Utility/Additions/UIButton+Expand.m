//
//  UIButton+Expand.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIButton+Expand.h"
#import <objc/runtime.h>

static void * ExpandDataPropertyKey = &ExpandDataPropertyKey;
static void * ExpandBlockPropertyKey = &ExpandBlockPropertyKey;


@implementation UIButton (Expand)

- (id)expand {
    return objc_getAssociatedObject(self, ExpandDataPropertyKey);
}

- (void)setExpand:(id)expand {
    objc_setAssociatedObject(self, ExpandDataPropertyKey, expand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(__strong id))DeleteBlock {
    return objc_getAssociatedObject(self, ExpandBlockPropertyKey);
    
}

- (void)setDeleteBlock:(void (^)(id))deleteBlock {
    objc_setAssociatedObject(self, ExpandBlockPropertyKey, deleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIButton*) createButtonWithFrame: (CGRect) frame target:(id)target selector:(SEL)selector image:(NSString *)image imagePressed:(NSString *)imagePressed
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    UIImage *newImage = [UIImage imageNamed: image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = [UIImage imageNamed: imagePressed];
    [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *) createButtonWithImage:(NSString *)image
                        imagePressed:(NSString *)imagePressed
                              target:(id)target
                            selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttomImage = [UIImage imageNamed:image];
    UIImage *buttomImageH = [UIImage imageNamed:imagePressed];
    [button setTfSize:buttomImage.size];
    [button setImage:buttomImage forState:UIControlStateNormal];
    [button setImage:buttomImageH forState:UIControlStateHighlighted];
    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    //    [button setBackgroundColor:TTSTYLEVAR(navigationBarButtonColor)];
    
    //    button.layer.borderColor = [[UIColor blueColor] CGColor];
    //    button.layer.borderWidth = 1;
    return button;
}

+ (UIButton *) createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *) createButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}


- (void)showDeleteView:(void (^)(id expand))deleteBlock {
    self.DeleteBlock = deleteBlock;
    UIButton *deleteButton = [UIButton createButtonWithImage:@"PostTimeDel.png"
                                                imagePressed:@"PostTimeDel.png"
                                                      target:self
                                                    selector:@selector(deleteImageClick)];
    deleteButton.tfSize = CGSizeMake(30, 30);
    deleteButton.tfLeft = self.tfWidth - deleteButton.tfWidth/2;
    deleteButton.tfTop = 0;
    [self addSubview:deleteButton];
}

- (void)deleteImageClick {
    if (self.DeleteBlock) {
        self.DeleteBlock(self.expand);
    }
}

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat imagePadding = (self.frame.size.width - imageSize.width ) / 2;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),  imagePadding, 0.0, 0.0);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)centerImageAndButton:(CGFloat)gap imageOnTop:(BOOL)imageOnTop {
    NSInteger sign = imageOnTop ? 1 : -1;
    
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake((imageSize.height+gap)*sign, -imageSize.width, 0, 0);
    
    CGSize titleSize = self.titleLabel.bounds.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height+gap)*sign, 0, 0, -titleSize.width);
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end
