//
//  TSubViewController.h
//  TFProject
//
//  Created by Melvin on 8/18/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "NetworkAssistant.h"
#import "TFDefaultStyle.h"
#import "TFCoreUtility.h"
#import "ViewControllerDelegate.h"
#import "TFAlertView.h"


typedef id (^TFViewControllerBlock)(id object);


@interface TSubViewController : UIViewController
/**
 *  页面参数
 */
@property (nonatomic ,strong ,readonly) NSDictionary        *params;
/**
 *  页面数据请求参数
 */
@property (nonatomic ,strong ,readonly) NSMutableDictionary *requestParams;

@property (nonatomic ,weak) id<ViewControllerDelegate> viewControllerDelegate;

@property (nonatomic ,assign) NSInteger   viewState;

@property (nonatomic ,weak) TFViewControllerBlock   ViewControllerBlock;


#pragma mark - Public
- (void)showBackButton;
- (void)showStateView:(NSInteger)viewState;
- (void)removeStateView;

- (NSString *)stateViewTitle:(NSInteger)viewState;
- (NSString *)stateViewButtonTitle:(NSInteger)viewState;
- (UIImage *)stateViewImage:(NSInteger)viewState;

@end
