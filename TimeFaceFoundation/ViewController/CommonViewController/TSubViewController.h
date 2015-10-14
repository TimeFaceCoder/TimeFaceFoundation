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
#import "Utility.h"
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
    /**
     *  显示空View
     */
    TFViewStateEmpty     = 6,
    TFViewStateNoBook    = 7,
    /**
     *  时光已被删除
     */
    TFViewStateTimeDel   = 8,
    /**
     *  时光书已被删除
     */
    TFViewStateBookDel   = 9,
    /**
     *  话题已被删除
     */
    TFViewStateTalkDel   = 10,
    /**
     *  无权查看时光
     */
    TFViewStateTimeNoPermission = 11,
    /**
     *  无权查看时光书
     */
    TFViewStateBookNoPermission = 12,
    /**
     *  时光圈－无通讯录
     */
    TFViewStateNoContacts = 13,
    
    /**
     * 我的收藏－无数据
     */
    TFViewStateMyCollect = 14,
    /**
     * 我的消息－无消息
     */
    TFViewStateMyMessageOne = 15,
    /**
     * 我的消息－无评论
     */
    TFViewStateMyMessageTwo = 16,
    /**
     * 我的消息－无赞
     */
    TFViewStateMyMessageThree = 17,
    /**
     * 我的消息－无通知
     */
    TFViewStateMyMessageFour = 18,

    
//    /**
//     * 我的评论－无数据
//     */
//    TFViewStateMyComment = 19,
    /**
     * 我的时光－无数据
     */
    TFViewStateMyTime    = 20,
    
    /**
     * 欣赏－无数据
     */
    TFViewStateAppreciate    = 21,
    /**
     * 观众－无数据
     */
    TFViewStateAudience    = 22,
    /**
     *  还未绑定iTV账号
     */
    TFViewStateNoITVAccount  = 23,
    /**
     *  扩展的
     */
    TFViewStateOther          = 24

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


@property (nonatomic ,strong) NSString *viewStateTitle;
@property (nonatomic ,strong) NSString *viewStateBtnTilte;
@property (nonatomic ,strong) NSString *viewStateimgName;
@property (nonatomic ,assign) TFViewState    viewStateMain;
@property (nonatomic ,assign) BOOL  stateBool;

#pragma mark - Public
- (void)showBackButton;
- (void)showStateView:(TFViewState)viewState;
- (void)removeStateView;

//扩展出来的stateViewType
- (void)getTFViewState:(BOOL)TFViewState
        stateViewTitle:(NSString *)title
  stateViewButtonTitle:(NSString *)btnTilte
        stateViewImage:(NSString *)imgName;
@end
