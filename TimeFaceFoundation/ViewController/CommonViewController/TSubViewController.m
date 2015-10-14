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
//#import "TFLogAgent.h"

#import "JMHoledView.h"
#import "ViewGuideModel.h"


#import "KvStore.h"
#import "GuideHelpView.h"

@interface TSubViewController ()<ViewStateDataSource,ViewStateDelegate> {
    CGRect stateViewFrame;
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
    
    
    [[SVProgressHUD appearance] setHudBackgroundColor:RGBACOLOR(0, 0, 0, .5)];
    [[SVProgressHUD appearance] setHudForegroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [TFLogAgent startTracPage:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TFLogAgent endTracPage:NSStringFromClass([self class])];
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
    stateViewFrame = self.view.bounds;

    // Do any additional setup after loading the view.
    
    
    
    if (!_requestParams) {
        _requestParams = [NSMutableDictionary dictionary];
    }
    
        
    if (!_manager) {
        _manager = [[CMMotionManager alloc] init];
    }
   
    [self showStateView:TFViewStateLoading];
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
        _stateView = [[TFStateView alloc] initWithFrame:stateViewFrame];
        _stateView.stateDataSource = self;
        _stateView.stateDelegate = self;
    }
    return _stateView;
}

- (void)showStateView:(TFViewState)viewState {
    _viewState = viewState;
    if (_viewState == TFViewStateEmpty) {
        [self.stateView removeStateView];
        return;
    }
    [self.stateView showStateView];
}
- (void)removeStateView {

    [self.stateView removeStateView];
}

- (void)showBackButton {
    self.navigationItem.leftBarButtonItems = [[Utility sharedUtility] createBarButtonsWithImage:@"NavButtonBack.png"
                                                                              selectedImageName:@"NavButtonBackH.png"
                                                                                       delegate:self
                                                                                       selector:@selector(onLeftNavClick:)];
}

- (void)reloadData {
    
}

-(void)getTFViewState:(BOOL)TFViewState stateViewTitle:(NSString *)title stateViewButtonTitle:(NSString *)btnTilte stateViewImage:(NSString *)imgName{
    //    _viewState = TFViewState;
    //    _viewStateMain = _viewState;
    _stateBool = TFViewState;
    _viewStateTitle = title;
    _viewStateBtnTilte = btnTilte;
    _viewStateimgName = imgName;
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
    
    NSString *text = nil;
    switch (_viewState) {
        case TFViewStateDataError:
        case TFViewStateTimeOut:
            text = NSLocalizedString(@"网络连接超时,请稍后再试", nil);
            break;
        case TFViewStateNoData:
            text = NSLocalizedString(@"暂无内容", nil);
            break;
        case TFViewStateNetError:
            text = NSLocalizedString(@"未检测到网络连接,请检查网络", nil);
            break;
        case TFViewStateNoBook:
            text = NSLocalizedString(@"您还没有时光书，点击右上角创建一本吧！", nil);
            attributes = @{NSFontAttributeName:TFSTYLEVAR(loadingTextFont),
                           NSForegroundColorAttributeName:[UIColor whiteColor]};
            break;
        case TFViewStateTimeDel:
            text = NSLocalizedString(@"时光已被删除", nil);
            break;
        case TFViewStateBookDel:
            text = NSLocalizedString(@"时光书已被删除", nil);
            break;
        case TFViewStateTalkDel:
            text = NSLocalizedString(@"话题已被删除", nil);
            break;
        case TFViewStateTimeNoPermission:
            text = NSLocalizedString(@"无权看时光", nil);
            break;
        case TFViewStateBookNoPermission:
            text = NSLocalizedString(@"无权看书", nil);
            break;
        case TFViewStateNoContacts:
            text = NSLocalizedString(@"暂无通讯录", nil);
            break;
        case TFViewStateMyCollect:
            text = NSLocalizedString(@"收藏列表是空的\n收藏的时光书会显示在这里哦", nil);
            break;
        case TFViewStateMyMessageOne:
            text = NSLocalizedString(@"还没人@你", nil);
            break;
        case TFViewStateMyMessageTwo:
            text = NSLocalizedString(@"还没有收到评论", nil);
            break;
        case TFViewStateMyMessageThree:
            text = NSLocalizedString(@"还没有收到赞", nil);
            break;
        case TFViewStateMyMessageFour:
            text = NSLocalizedString(@"还没有收到通知", nil);
            break;
//        case TFViewStateMyComment:
//            text = NSLocalizedString(@"暂无评论", nil);
//            break;
        case TFViewStateMyTime:
            text = NSLocalizedString(@"还没有发布任何时光哦", nil) ;
            break;
        case TFViewStateAppreciate:
            text = NSLocalizedString(@"你还没有欣赏任何人呢\n去发现频道看看吧",nil );
            break;
        case TFViewStateAudience:
            text = NSLocalizedString(@"你的观众列表是空的\n多邀请一些人来关注你吧", nil);
            break;
        case TFViewStateNoITVAccount:
            text = NSLocalizedString(@"未绑定iTV账号", nil);
            break;
        case TFViewStateOther:
            if (_viewStateTitle) {
                text = _viewStateTitle;
            }
            else{
                text = @"";
            }
            break;
        default:
            text = NSLocalizedString(@"不是我太慢,是时间太快了...", nil);
            break;
    }
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
}

- (NSAttributedString *)buttonTitleForStateView:(UIView *)view forState:(UIControlState)state {
    
    NSDictionary *attributes = @{NSFontAttributeName:TFSTYLEVAR(font16),
                                 NSForegroundColorAttributeName:TFSTYLEVAR(loadingTextColor)};
    
    NSString *text = @"";
    switch (_viewState) {
        case TFViewStateDataError:
        case TFViewStateTimeOut:
            text = NSLocalizedString(@"重新加载", nil);
            break;
        case TFViewStateNetError:
            text = NSLocalizedString(@"设置网络", nil);
            break;
        case TFViewStateOther:
            if (_viewStateBtnTilte) {
                text = _viewStateBtnTilte;
            }
            break;
        default:
            break;
    }
    return [[NSAttributedString alloc] initWithString:text
                                           attributes:attributes];
    
}

- (UIImage *)imageForStateView:(UIView *)view {
    UIImage *image = nil;
    switch (_viewState) {
        case TFViewStateDataError:
        case TFViewStateTimeOut:
            image = [UIImage imageNamed:@"ViewDataError"];
            break;
        case TFViewStateNoData:
        case TFViewStateTimeDel:
        case TFViewStateTalkDel:
        case TFViewStateBookDel:
            image = [UIImage imageNamed:@"ViewDataEmpty"];
            break;
        case TFViewStateTimeNoPermission:
        case TFViewStateBookNoPermission:
            image = [UIImage imageNamed:@"ViewDataNoPermission.png"];
            break;
        case TFViewStateNetError:
            image = [UIImage imageNamed:@"ViewDataNetError"];
            break;
        case TFViewStateMyCollect:
            image = [UIImage imageNamed:@"MyCollectNoDate.png"];
            break;
        case TFViewStateMyMessageOne:
            image = [UIImage imageNamed:@"NoMessage"];
            break;
        case TFViewStateMyMessageTwo:
            image = [UIImage imageNamed:@"NoComment"];
            break;
        case TFViewStateMyMessageThree:
            image = [UIImage imageNamed:@"NoPraise"];
            break;
        case TFViewStateMyMessageFour:
            image = [UIImage imageNamed:@"NoNotification"];
            break;
//        case TFViewStateMyComment:
//            image = [UIImage imageNamed:@"NoComment"];
//            break;
        case TFViewStateAppreciate:
            image = [UIImage imageNamed:@"NoAppreciate.png"];
            break;
        case TFViewStateAudience:
            image = [UIImage imageNamed:@"NoAudience.png"];
            break;
        case TFViewStateNoITVAccount:
            image = [UIImage imageNamed:@"ViewDataNetError"];
            break;
        case TFViewStateOther:
            if (_viewStateimgName) {
                image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",_viewStateimgName]];
            }
            break;
        default:
            break;
    }
    return image;
}

- (FLAnimatedImage *)animationImageForStateView:(UIView *)view {
    if (_viewState == TFViewStateLoading) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ViewLoading" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        return image;
    }
    return nil;
}
//
//- (NSArray *)imagesForStateView:(UIView *)view {
//    return @[[UIImage imageNamed:@"HUDLoading1.png"],
//             [UIImage imageNamed:@"HUDLoading2.png"],
//             [UIImage imageNamed:@"HUDLoading3.png"],
//             [UIImage imageNamed:@"HUDLoading4.png"],
//             [UIImage imageNamed:@"HUDLoading5.png"],
//             [UIImage imageNamed:@"HUDLoading6.png"],
//             [UIImage imageNamed:@"HUDLoading7.png"]];
//}


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
    ViewGuideModel *model = [[KvStore shared] loadViewGuideWithViewId:viewId];
    if (!model) {
        TFLog(@"（%@）页面未找到引导信息！",viewId);
        return ;
    }
    //引导 开始
    if (model.index < model.guides.count) {
        [self performSelector:@selector(startGuide:) withObject:model afterDelay:model.delayShow];
    } else {
        TFLog(@"（%@）引导信息已处理完！",viewId);
    }
}
-(void) startGuide:(ViewGuideModel *)model {
    [[UIApplication sharedApplication].keyWindow addSubview:self.guideHelpView];
    [_guideHelpView refreshGuide:model inview:self];
}

- (void)removeGuideView {
    
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
