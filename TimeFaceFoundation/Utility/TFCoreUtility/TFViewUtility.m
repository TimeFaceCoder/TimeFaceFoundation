//
//  TFViewUtility.m
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TFViewUtility.h"

@implementation TFViewUtility

+(instancetype)shared {
    static TFViewUtility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}

/**
 *  创建导航条按纽
 *
 *  @param imageName
 *  @param selectedImageName
 *  @param delegate
 *  @param selector
 *
 *  @return
 */
- (NSArray *)createBarButtonsWithImage:(NSString *)imageName
                     selectedImageName:(NSString *)selectedImageName
                              delegate:(id)delegate
                              selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttomImage = [UIImage imageNamed:imageName];
    UIImage *buttomImageH = [UIImage imageNamed:selectedImageName];
    [button setTfSize:buttomImage.size];
    [button setImage:buttomImage forState:UIControlStateNormal];
    [button setImage:buttomImageH forState:UIControlStateHighlighted];
    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithImages:(NSArray *)imageNames
                     selectedImageNames:(NSArray *)selectedImageNames
                               delegate:(id)delegate
                               selector:(SEL)selector {
    
    NSMutableArray *barButtons = [NSMutableArray arrayWithCapacity:1];
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    [barButtons addObject:barButtonSpacer];
    NSInteger index = 0;
    for (NSString *imageName in imageNames) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttomImage = [UIImage imageNamed:imageName];
        UIImage *buttomImageH = [UIImage imageNamed:[selectedImageNames objectAtIndex:index]];
        [button setTfSize:buttomImage.size];
        [button setImage:buttomImage forState:UIControlStateNormal];
        [button setImage:buttomImageH forState:UIControlStateHighlighted];
        [button setImage:buttomImageH forState:UIControlStateSelected];
        [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [barButtons addObject:barButtonItem];
        [barButtons addObject:barButtonSpacer];
        
        index ++;
    }
    [barButtons removeLastObject];
    
    return barButtons;
}


- (NSArray *)createBarButtonsWithTitle:(NSString *)title
                              delegate:(id)delegate
                              selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TFSTYLEVAR(navBarTitleColor) forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithButton:(UIButton *)button {
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithView:(UIView *)view
                             delegate:(id)delegate
                             selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    return @[barButtonSpacer,barButtonItem];
}

- (UIBarButtonItem *)createBarButtonWithImage:(NSString *)imageName
                            selectedImageName:(NSString *)selectedImageName
                                     delegate:(id)delegate
                                     selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttomImage = [UIImage imageNamed:imageName];
    UIImage *buttomImageH = [UIImage imageNamed:selectedImageName];
    [button setTfSize:buttomImage.size];
    [button setImage:buttomImage forState:UIControlStateNormal];
    [button setImage:buttomImageH forState:UIControlStateHighlighted];
    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

- (UIBarButtonItem *)createBarButtonWithTitle:(NSString *)title
                                     delegate:(id)delegate
                                     selector:(SEL)selector {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TFSTYLEVAR(navBarTitleColor) forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}


@end
