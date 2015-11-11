//
//  TFAlertView.h
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertType) {
    AlertSuccess,
    AlertFailure,
    AlertInfo
};

@class TFAlertView;

typedef void (^AlertClickBlock)(NSInteger index);

#define REDCOLOR    [UIColor colorWithRed:0.906 green:0.296 blue:0.235 alpha:1]


@interface TFAlertView : UIView

/**
 *  打开AlertView
 *
 *  @param title
 *  @param content
 *  @param alertType
 *  @param clickBlock
 *
 *  @return
 */
+ (id)showAlertWithTitle:(NSString *)title
                 content:(NSString *)content
               alertType:(AlertType)alertType
              clickBlock:(AlertClickBlock)clickBlock;

+ (id)showAlertWithTitle:(NSString *)title
                 content:(NSString *)content
              fisrtTitle:(NSString *)fisrtTitle
             secondTitle:(NSString *)secondTitle
               alertType:(AlertType)alertType
              clickBlock:(AlertClickBlock)clickBlock;

- (void)show;




@end
