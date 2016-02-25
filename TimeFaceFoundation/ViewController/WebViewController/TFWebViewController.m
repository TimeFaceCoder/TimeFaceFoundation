//
//  TFWebViewController.m
//  TimeFace
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFWebViewController.h"
#import "TFDefaultStyle.h"
#import "TFCoreUtility.h"

#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
#import "TFDataHelper.h"
#import "TimeFaceFoundationConst.h"

@interface TFWebViewController ()<NJKWebViewProgressDelegate>{
    BOOL            firstLoaded;
    NSDictionary    *shareContent;
}

@property (nonatomic ,strong) NJKWebViewProgress      *progressProxy;
@property (nonatomic ,strong) NJKWebViewProgressView  *progressView;

@end

@implementation TFWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [self setUrl:url];
        self.shareType = LocalViewTypeNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url share:(LocalViewType)shareType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [self setUrl:url];
        self.shareType = shareType;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.tfTop = 64.f;
    self.webView.tfHeight -= 64.f;
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = [[TFCoreUtility sharedUtility] createBarButtonsWithImage:@"NavButtonBack.png"
                                                                              selectedImageName:@"NavButtonBackH.png"
                                                                                       delegate:self
                                                                                       selector:@selector(onLeftNavClick:)];
    switch (_shareType) {
        case LocalViewTypeNone:
        case LocalViewTypeTimeDetail:
        case LocalViewTypeTopicDetail:
        case LocalViewTypeUserDetail:
        case LocalViewTypeEventDetail:
            self.navigationItem.rightBarButtonItems = [[TFCoreUtility sharedUtility] createBarButtonsWithImage:@"NavButtonMore.png"
                                                                                       selectedImageName:@"NavButtonMoreH.png"
                                                                                                delegate:self
                                                                                                selector:@selector(onRightNavClick:)];
            break;
            
        default:
            break;
    }
 
    [self addObserver];
 
}

- (void)addObserver {
    //关闭web view 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotice:)
                                                 name:kTFCloseWebViewNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotice:)
                                                 name:kTFOpenLocalNotification
                                               object:nil];
}

- (void)removeObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTFCloseWebViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTFOpenLocalNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   if (_url.length) {
        if (!firstLoaded) {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
            firstLoaded = YES;
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_webView stopLoading];
    _webView = nil;
}

- (void)dealloc {
    [_webView stopLoading];
    _webView.delegate = nil;
    [self removeObserver];
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressDelegate = nil;
}


#pragma mark - Private
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
        
        
        _jsBridge = [WebViewJavascriptBridge bridgeForWebView:_webView
                                              webViewDelegate:self
                                                      handler:^(id data, WVJBResponseCallback responseCallback)
        {
            NSLog(@"ObjC received message from JS: %@", data);
            responseCallback(@{@"status":@"1",@"info":@"success" });
        }];
        
        
        
        [self regestBridge];
        
        //关闭当前页面
        [_jsBridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback)
         {
             [self closeAction];
         }];
        
                
               
        
        _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = _jsBridge;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
    }
    return _webView;
}


- (void)onLeftNavClick:(id)sender {
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else {
        [self closeAction];
    }
}

- (void)onRightNavClick:(id)sender {
//    ShareTFType shareType = ShareTFTypeWeb;
//    NSString *title = [shareContent objectForKey:@"title"]?[shareContent objectForKey:@"title"]:self.navigationItem.title;
//    NSString *content = [shareContent objectForKey:@"content"]?[shareContent objectForKey:@"content"]:self.navigationItem.title;
//    NSString *url = [shareContent objectForKey:@"url"]?[shareContent objectForKey:@"title"]:_url;
//    NSString *imageUrl = @"";
//    if ([[shareContent objectForKey:@"icon"] length]) {
//        imageUrl = [shareContent objectForKey:@"icon"];
//    }
//    switch (_shareType) {
//        case LocalViewTypeEventDetail:
//            shareType = ShareTFTypeEvent;
//            break;
//            
//        default:
//            break;
//    }
//
//    [self shareWithTitle:title content:content imageUrl:imageUrl shareType:shareType url:url];
    
    
}

- (void)handleNotice:(NSNotification *)notice {
    if ([notice.name isEqualToString:kTFCloseWebViewNotification]) {
        //关闭
        [self closeAction];
    }
    if ([notice.name isEqualToString:kTFOpenLocalNotification]) {
        //打开本地页面
        NSInteger type = [[[notice userInfo] objectForKey:@"type"] integerValue];
        NSString *dataId = [[[notice userInfo] objectForKey:@"dataId"] stringValue];
        [self handleLocalView:dataId type:type];
        
    }
}

- (void)handleLocalView:(NSString *)dataId type:(NSInteger)type {
//    switch (type) {
//        case 1:     //打开时光详情
//            [self openTimeDetail:dataId onlyComment:NO];
//            break;
//            
//        case 2:     //打开话题详情
//            [self openTopicDetail:dataId onlyComment:NO];
//            break;
//            
//        case 3:     //打开用户详情
//            [self openUserDetail:dataId];
//            break;
//            
//        case 4:     //打开评论详情
//            [self openTimeDetail:dataId onlyComment:YES];
//            break;
//            
//        case 5:     //打开时光书详情
//            [self openBookSummary:dataId sell:NO];
//            break;
//            
//        default:
//            break;
//    }
}




- (void)closeAction {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [_webView loadRequest:request];
    [self setUrl:URL.absoluteString];
}


#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


- (void)updateLeftBarButton {
    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = [self createBarButtons];
    }
    else {
        self.navigationItem.leftBarButtonItems = [[TFCoreUtility sharedUtility] createBarButtonsWithImage:@"NavButtonBack.png"
                                                                                  selectedImageName:@"NavButtonBackH.png"
                                                                                           delegate:self
                                                                                           selector:@selector(onLeftNavClick:)];
    }
}

-(NSString *) routerUrlWithString:(NSString *)string key:(NSString *) key {
    NSArray *array = [string componentsSeparatedByString:key];
    if (array.count > 1) {
        return [array objectAtIndex:1];
    }
    
    return @"";
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
    self.title = NSLocalizedString(@"正在加载...", @"");
    [self updateLeftBarButton];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateLeftBarButton];
}


- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [self webViewDidFinishLoad:webView];
    if (error) {
        [self showStateView:kTFViewStateDataError];
    }
}

- (NSArray *)createBarButtons {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    [barButtonSpacer setWidth:0];
    
    UIButton *button = [UIButton createButtonWithImage:@"NavButtonBack.png"
                                          imagePressed:@"NavButtonBackH.png"
                                                target:self
                                              selector:@selector(onLeftNavClick:)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    UIButton *close = [UIButton createButtonWithImage:@"NavButtonClose"
                                         imagePressed:@"NavButtonClose"
                                               target:self
                                             selector:@selector(closeAction)];
    
    [close setTitleColor:[UIColor darkTextColor]
                forState:UIControlStateNormal];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:close];
    
    
    return @[barButtonSpacer,barButtonItem,closeButtonItem];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}


@end
