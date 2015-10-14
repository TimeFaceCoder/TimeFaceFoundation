//
//  DefaultViewController.m
//  TimeFaceV2
//
//  Created by Melvin on 11/6/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "DefaultViewController.h"
#import "AdModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+TFCache.h"

#import "AppDelegate.h"

#import "KvStore.h"

@interface DefaultViewController () {
    BOOL showAd;
}

@property (nonatomic ,strong) UIImageView   *defaultImageView;
@property (nonatomic ,strong) AdModel       *adModel;


@end

@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeStateView];
    // Do any additional setup after loading the view.
    _defaultImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    NSArray *allPngImageNames = [[NSBundle mainBundle] pathsForResourcesOfType:@"png"
                                                                   inDirectory:nil];
    for (NSString *imgName in allPngImageNames){
        // Find launch images
        NSRange range = [imgName rangeOfString:@"LaunchImage"];
        if (range.length > 0) {
            UIImage *image = [UIImage imageWithContentsOfFile:imgName];
            if (image.scale == [UIScreen mainScreen].scale &&
                CGSizeEqualToSize(image.size, [UIScreen mainScreen].bounds.size))
            {
                TFLog(@"default image size:%@",NSStringFromCGSize(image.size));
                _defaultImageView.image = image;
            }
        }
    }
    [self.view addSubview:_defaultImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adSplashAnimation)
                                                 name:NOTICE_ADSplashAnimation
                                               object:nil];
}

-(void)adSplashAnimation
{
    [self performSelector:@selector(splashAnimation)
               withObject:nil
               afterDelay:_adModel.showTime];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[Utility sharedUtility] getBoolByKey:STORE_KEY_SPLASHDOWNLOADED]) {
        __weak __typeof(self)weakSelf = self;
        
        _adModel = [[KvStore shared] getObject:NSStringFromClass([AdModel class])
                                         objId:@"current_splash_ad_object"];
        if (_adModel.adImgUrl.length) {
            [_defaultImageView tf_setImageWithURL:[NSURL URLWithString:_adModel.adImgUrl]
                                 placeholderImage:_defaultImageView.image
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 if (!error) {
                     UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(imageViewClick:)];
                     weakSelf.defaultImageView.userInteractionEnabled = YES;
                     imageViewTap.delaysTouchesBegan = YES;
                     [weakSelf.defaultImageView addGestureRecognizer:imageViewTap];
                     showAd = YES;
                     
                     if(![AppDelegate sharedAppDelegate].isShowIndex)
                     {
                         [self performSelector:@selector(splashAnimation)
                                    withObject:nil
                                    afterDelay:_adModel.showTime];
                     }
                 }
                 else {
                     [[AppDelegate sharedAppDelegate] removeSplashAdView];
                 }
             } animated:YES faceAware:NO];
        }
        else {
            [[AppDelegate sharedAppDelegate] removeSplashAdView];
        }
    }
    else {
        [[AppDelegate sharedAppDelegate] removeSplashAdView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)splashAnimation {
    if (showAd) {
        showAd = NO;
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = .35 ;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        [[self.view layer] addAnimation:animation forKey:@"animation"];
        [[AppDelegate sharedAppDelegate] removeSplashAdView];
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)gestureRecognizer {
    if (showAd) {
        [[AppDelegate sharedAppDelegate] splashAdClick:_adModel];
        showAd = NO;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_ADSplashAnimation object:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
