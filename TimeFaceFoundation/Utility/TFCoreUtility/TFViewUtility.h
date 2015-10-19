//
//  TFViewUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIAdditions.h"
#import "AppMacro.h"
#import "TFStyle.h"
#import "TFDefaultStyle.h"

@interface TFViewUtility : NSObject


+ (instancetype)shared;


- (NSArray *)createBarButtonsWithImage:(NSString *)imageName
                     selectedImageName:(NSString *)selectedImageName
                              delegate:(id)delegate
                              selector:(SEL)selector;

- (NSArray *)createBarButtonsWithImages:(NSArray *)imageNames
                     selectedImageNames:(NSArray *)selectedImageNames
                               delegate:(id)delegate
                               selector:(SEL)selector;

- (NSArray *)createBarButtonsWithTitle:(NSString *)title
                              delegate:(id)delegate
                              selector:(SEL)selector;

- (NSArray *)createBarButtonsWithButton:(UIButton *)button;

- (NSArray *)createBarButtonsWithView:(UIView *)view
                             delegate:(id)delegate
                             selector:(SEL)selector;

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
- (UIBarButtonItem *)createBarButtonWithImage:(NSString *)imageName
                            selectedImageName:(NSString *)selectedImageName
                                     delegate:(id)delegate
                                     selector:(SEL)selector;

- (UIBarButtonItem *)createBarButtonWithTitle:(NSString *)title
                                     delegate:(id)delegate
                                     selector:(SEL)selector;

@end
