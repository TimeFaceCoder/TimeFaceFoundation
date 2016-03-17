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
#import "TimeFaceFoundationConst.h"
#import "TFStateView.h"
#import "ViewGuideModel.h"


typedef id (^TFViewControllerBlock)(id object);

// toast提示类型
typedef NS_ENUM (NSInteger, MessageType) {
    /**
     *  默认提示
     */
    MessageTypeDefault = 0,
    /**
     *  成功提示
     */
    MessageTypeSuccess = 1,
    /**
     *  失败提示
     */
    MessageTypeFaild   = 2,
    /**
     *  一般性消息提示
     */
    MessageTypeInfo    = 3
};

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

@property (nonatomic ,strong           ) TFStateView              *stateView;


#pragma mark - Public
- (void)showBackButton;
- (void)showStateView:(NSInteger)viewState;
- (void)removeStateView;

-(void)startGuide:(ViewGuideModel *)model;

- (void)showToastMessage:(NSString *)message messageType:(MessageType)messageType;
- (void)dismissToastView;
- (NSString *)stateViewTitle:(NSInteger)viewState;
- (NSString *)stateViewButtonTitle:(NSInteger)viewState;
- (UIImage *)stateViewImage:(NSInteger)viewState;

@end
