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


typedef NS_ENUM (NSInteger, TFViewState) {
    /**
     *  正在加载
     */
    TFViewStateLoading   = 1,
    /**
     *  网络错误
     */
    TFViewStateNetError  = 2,
    /**
     *  数据错误
     */
    TFViewStateDataError = 3,
    /**
     *  空数据
     */
    TFViewStateNoData    = 4,
    /**
     *  连接超时
     */
    TFViewStateTimeOut   = 5,
};

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

@property (nonatomic ,assign) TFViewState   viewState;

@property (nonatomic ,weak) TFViewControllerBlock   ViewControllerBlock;


#pragma mark - Public
- (void)showBackButton;
- (void)showStateView:(TFViewState)viewState;
- (void)removeStateView;

- (NSString *)stateViewTitle:(TFViewState)viewState;
- (NSString *)stateViewButtonTitle:(TFViewState)viewState;
- (UIImage *)stateViewImage:(TFViewState)viewState;

@end
