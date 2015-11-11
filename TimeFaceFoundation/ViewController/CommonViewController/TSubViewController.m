//
//  TSubViewController.m
//  TFProject
//
//  Created by Melvin on 8/18/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TSubViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "TFStateView.h"
#import "TimeFaceFoundationConst.h"
//#import "TFLogAgent.h"

#import "JMHoledView.h"
#import "ViewGuideModel.h"


#import "TFDataHelper.h"
#import "GuideHelpView.h"

@interface TSubViewController ()<ViewStateDataSource,ViewStateDelegate> {
}
/**
 *  页面参数
 */
@property (nonatomic ,strong ,readwrite) NSDictionary             *params;
/**
 *  页面数据请求参数
 */
@property (nonatomic ,strong ,readwrite) NSMutableDictionary      *requestParams;

@property (nonatomic ,strong           ) CMMotionManager          *manager;

@property (nonatomic ,strong           ) TFStateView              *stateView;

@property (nonatomic ,strong           ) GuideHelpView              *guideHelpView;

@end

@implementation TSubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    if (nil != self.nibName) {
        [super loadView];
    } else {
        self.view = [[UIView alloc] initWithFrame:TTScreenBounds()];
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = TFSTYLEVAR(viewBackgroundColor);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //手机敲击左手返回
    __weak __typeof(self)weakSelf = self;
    if (_manager.deviceMotionAvailable) {
        _manager.deviceMotionUpdateInterval = 0.01f;
        [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                      withHandler:^(CMDeviceMotion *data, NSError *error) {
                                          if (data.userAcceleration.x < -2.5f) {
                                              NSString *classname = weakSelf.class.description;
                                              if ([classname isEqualToString:@"CircleQuickViewController"]) {
                                                  return ;
                                              }
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                          }
                                      }];
    }
    [self checkGuide];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_manager stopDeviceMotionUpdates];
    [self removeGuideView];
}

- (void)dealloc {
    if (!_stateView) {
        _stateView.stateDataSource = nil;
        _stateView.stateDelegate = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_requestParams) {
        _requestParams = [NSMutableDictionary dictionary];
    }
    
        
    if (!_manager) {
        _manager = [[CMMotionManager alloc] init];
    }
   
    [self showStateView:kTFViewStateLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLeftNavClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public


- (TFStateView *)stateView {
    if (!_stateView) {
        _stateView = [[TFStateView alloc] init];
        _stateView.stateDataSource = self;
        _stateView.stateDelegate = self;
    }
    return _stateView;
}

- (void)showStateView:(NSInteger)viewState {
    _viewState = viewState;
    [self.stateView showStateView];
}
- (void)removeStateView {
    [self.stateView removeStateView];
}

- (void)showBackButton {
    self.navigationItem.leftBarButtonItems = [[TFCoreUtility sharedUtility] createBarButtonsWithImage:@"NavButtonBack.png"
                                                                              selectedImageName:@"NavButtonBackH.png"
                                                                                       delegate:self
                                                                                       selector:@selector(onLeftNavClick:)];
}

- (void)reloadData {
    
}

- (void)showToastMessage:(NSString *)message messageType:(MessageType)messageType {
    TFMainRun(^{
        switch (messageType) {
            case MessageTypeDefault:
                [SVProgressHUD showWithStatus:message];
                break;
            case MessageTypeSuccess:
                [SVProgressHUD showSuccessWithStatus:message];
                break;
            case MessageTypeFaild:
                [SVProgressHUD showErrorWithStatus:message];
                break;
            default:
                [SVProgressHUD showInfoWithStatus:message];
                break;
        }
    });
}

- (void)dismissToastView {
    TFMainRun(^{
        [SVProgressHUD dismiss];
    });
}

- (NSString *)stateViewTitle:(NSInteger)viewState {
    NSString *title = @"";
    switch (viewState) {
        case kTFViewStateDataError:
            title = NSLocalizedString(@"网络数据异常", nil);
            break;
        case kTFViewStateLoading:
            title = NSLocalizedString(@"正在加载数据", nil);
            break;
        case kTFViewStateNetError:
            title = NSLocalizedString(@"网络连接错误", nil);
            break;
        case kTFViewStateNoData:
            title = NSLocalizedString(@"网络数据为空", nil);
            break;
        case kTFViewStateTimeOut:
            title = NSLocalizedString(@"网络连接超时", nil);
            break;
    }
    return title;
}

- (NSString *)stateViewButtonTitle:(NSInteger)viewState {
    NSString *title = @"";
    switch (viewState) {
        case kTFViewStateDataError:
            title = NSLocalizedString(@"重新加载", nil);
            break;
        case kTFViewStateLoading:
            
            break;
        case kTFViewStateNetError:
            title = NSLocalizedString(@"设置网络", nil);
            break;
        case kTFViewStateNoData:
            
            break;
        case kTFViewStateTimeOut:
            title = NSLocalizedString(@"重新加载", nil);
            break;
    }
    return title;
}



- (UIImage *)stateViewImage:(NSInteger)viewState {
    UIImage *image = [UIImage new];
    switch (viewState) {
        case kTFViewStateDataError:
            image =[UIImage imageNamed:NSLocalizedString(@"ViewDataError", nil)];
            break;
        case kTFViewStateLoading:
            
            break;
        case kTFViewStateNetError:
            image =[UIImage imageNamed:NSLocalizedString(@"ViewDataNetError", nil)];
            break;
        case kTFViewStateNoData:
            image =[UIImage imageNamed:NSLocalizedString(@"ViewDataNetError", nil)];
            break;
        case kTFViewStateTimeOut:
            image =[UIImage imageNamed:NSLocalizedString(@"ViewDataError", nil)];
            break;
    }
    return image;
}

#pragma mark - Private

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - EmptyDataSetSource

- (NSAttributedString *)titleForStateView:(UIView *)view {
    
    NSDictionary *attributes = @{NSFontAttributeName:TFSTYLEVAR(loadingTextFont),
                                 NSForegroundColorAttributeName:TFSTYLEVAR(loadingTextColor)};
    
    NSString *text = [self stateViewTitle:_viewState];
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

- (NSAttributedString *)buttonTitleForStateView:(UIView *)view forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName:TFSTYLEVAR(font16),
                                 NSForegroundColorAttributeName:TFSTYLEVAR(loadingTextColor)};
    NSString *text = [self stateViewButtonTitle:_viewState];
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
    
}

- (UIImage *)imageForStateView:(UIView *)view {
    UIImage *image = [self stateViewImage:_viewState];
    return image;
}

- (FLAnimatedImage *)animationImageForStateView:(UIView *)view {
    if (_viewState == kTFViewStateLoading) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ViewLoading" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        return image;
    }
    return nil;
}

- (UIColor *)backgroundColorForStateView:(UIView *)view {
    return TFSTYLEVAR(viewBackgroundColor);
   }

- (CGFloat)spaceHeightForStateView:(UIView *)view {
    return 12;
}

- (void)stateViewDidTapButton:(UIView *)view {
   [self reloadData];
}

- (void)stateViewDidTapView:(UIView *)view {
    [self reloadData];
}

- (void)stateViewWillAppear:(UIView *)view {
    [UIView animateWithDuration:.25 animations:^{
        [self.view addSubview:self.stateView];
    }];
}
- (void)stateViewWillDisappear:(UIView *)view {
    [UIView animateWithDuration:.25 animations:^{
        [self.stateView removeFromSuperview];
    }];
}


#pragma mark - 页面引导

-(void) checkGuide {
    NSString *viewId = self.class.description;
    //取出当前页面 的引导信息
    ViewGuideModel *model = [[TFDataHelper shared] loadViewGuideWithViewId:viewId];
    if (!model) {
        TFLog(@"（%@）页面未找到引导信息！",viewId);
        return;
    }
    //引导 开始
    if (model.index < model.guides.count) {
        [self performSelector:@selector(startGuide:)
                   withObject:model
                   afterDelay:model.delayShow];
    } else {
        TFLog(@"（%@）引导信息已处理完！",viewId);
    }
}
-(void)startGuide:(ViewGuideModel *)model {
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideHelpView];
    [self.guideHelpView refreshGuide:model inview:self];
}

- (void)removeGuideView {
    [self.guideHelpView removeFromSuperview];
}

/**
 *  引导页面
 *
 *  @return
 */
-(GuideHelpView *) guideHelpView {
    if (!_guideHelpView) {
        _guideHelpView = [[GuideHelpView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _guideHelpView;
}

@end
