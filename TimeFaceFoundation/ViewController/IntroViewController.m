//
//  IntroViewController.m
//  TimeFaceV2
//
//  Created by 吴寿 on 15/4/21.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "IntroViewController.h"
#import <pop/POP.h>
#import "TFDefaultStyle.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@interface IntroViewController ()<UIGestureRecognizerDelegate,UIVideoEditorControllerDelegate, UIScrollViewDelegate> {
    NSInteger newIndex;
    NSInteger currentIndex;
    BOOL isFourth;
    BOOL isTap;
    BOOL hasExecute;
}

@property (nonatomic ,strong) UIImageView     *backgroundImageView;
@property (nonatomic, strong) MPMoviePlayerController   *player;
@property (nonatomic, assign) BOOL                      played;
@property (nonatomic, assign) BOOL                      isLoop;

@property (nonatomic, strong) UIScrollView             *indexScrollView;
@property (nonatomic, strong) UIImageView              *imgIndex;

@end

@implementation IntroViewController

- (void)loadView {
    if (nil != self.nibName) {
        [super loadView];
    } else {
        self.view = [[UIView alloc] initWithFrame:TTScreenBounds()];
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = [UIColor clearColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //2015.8.26  4张引导页图片
    [self.view addSubview:self.indexScrollView];
    [self.view addSubview:self.imgIndex];
    
    //    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    _backgroundImageView.image = [UIImage imageNamed:@"IntroBackground.png"];
    //    [self.view addSubview:_backgroundImageView];
    //
    //    [self prepareClipPlayback];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(moviePlayerPlaybackStateChanged:)
    //                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
    //                                               object:nil];
    //
    //    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    view.backgroundColor = RGBACOLOR(0, 0, 0, .1);
    //    view.userInteractionEnabled = YES;
    //    [self.view addSubview:view];
    //    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                                                               action:@selector(onViewClick:)];
    //    [view addGestureRecognizer:imageTap];
    //    [self swipeView];
    //
    //    newIndex = 0;
    //    currentIndex = 0;
    //    _played = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = _indexScrollView.contentOffset;
    NSInteger num = point.x / _indexScrollView.tfWidth;
    _imgIndex.image = [UIImage imageNamed:[NSString stringWithFormat:@"ScrollIndex%@.png", @(num + 1)]];
    
    //这里当滑动到第四张图片的时候，延时1秒跳到广告页
    if(num == 3)
    {
        isFourth = YES;
        //[self performSelector:@selector(hideFourthPage) withObject:nil afterDelay:(3)];
    }
    else
    {
        isFourth = NO;
    }
}

-(void)hideFourthPage
{
    if(!isTap && isFourth && !hasExecute)
    {
        [[AppDelegate sharedAppDelegate] removeIntro];
        
        //这里发通知，通知引导页已消失，广告页splashAnimation方法开启
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADSplashAnimation object:nil];
        
        hasExecute = YES;
    }
}

-(UIImageView*)imgIndex
{
    if(!_imgIndex)
    {
        _imgIndex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollIndex1.png"]];
        _imgIndex.tfCenterX = self.view.tfCenterX;
        _imgIndex.tfBottom = self.view.tfBottom - 40;
    }
    return _imgIndex;
}

-(UIScrollView*)indexScrollView
{
    if(!_indexScrollView)
    {
        _indexScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        CGSize size = CGSizeMake(self.view.tfWidth * 4, self.view.tfHeight);
        _indexScrollView.bounces = NO;
        _indexScrollView.contentSize = size;
        _indexScrollView.pagingEnabled =YES;
        _indexScrollView.delegate = self;
        _indexScrollView.showsHorizontalScrollIndicator = NO;
        
        for(NSInteger n = 0; n<4;n++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"AppGuide%@.jpg", @(n + 1)]];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = self.view.frame;
            imageView.tfLeft = n * self.view.tfWidth;
            [_indexScrollView addSubview:imageView];
            
            if(n == 3)
            {
                UIButton* btnBegin = [UIButton buttonWithType:UIButtonTypeCustom];
                btnBegin.backgroundColor = [UIColor blackColor];
                btnBegin.alpha = 0.4;
                [btnBegin setTitle:NSLocalizedString(@"开始体验", nil) forState:UIControlStateNormal];
                [btnBegin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnBegin.titleLabel.font = [UIFont systemFontOfSize:14];
                btnBegin.layer.cornerRadius = 8.f;
                btnBegin.layer.masksToBounds = YES;
                btnBegin.tfSize = CGSizeMake(102, 30);
                btnBegin.tfCenterX = self.view.tfCenterX;
                btnBegin.tfBottom = self.view.tfHeight - 40 - 30;
                [btnBegin addTarget:self action:@selector(hideIndex) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:btnBegin];
                
//                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideIndex)];
//                [imageView addGestureRecognizer:gesture];
                imageView.userInteractionEnabled = YES;
            }
        }
    }
    return _indexScrollView;
}

-(void)hideIndex
{
    isTap = YES;
    
    [[AppDelegate sharedAppDelegate] removeIntro];
    
    //这里发通知，通知引导页已消失，广告页splashAnimation方法开启
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_ADSplashAnimation object:nil];
}

/**
 *  页面中下滑出现工具菜单
 */
- (void) swipeView {
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [sgrLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:sgrLeft];
    
    UISwipeGestureRecognizer *sgrRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [sgrRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:sgrRight];
}

/**
 *  手势滑动事件方法
 *
 *  @param recognizer
 */
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self playIntro:YES];
    } else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self playIntro:NO];
        if (currentIndex < 0) {
            currentIndex = 0;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Play MPMoviePlayer
    [self.player play];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Unregister MPMoviePlayer notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //Pause/Stop MPMoviePlayer
    [self.player pause];
}

#pragma mark - Player
-(void) prepareClipPlayback{
    if (self.player == nil) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro0"
                                                                            ofType:@"mp4"]];
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [self.player setControlStyle:MPMovieControlStyleNone];
        [self.player prepareToPlay];
        
        [self.player.view setFrame:self.view.frame];
        [self.view addSubview:self.player.view];
        
        self.player.scalingMode = MPMovieScalingModeAspectFill;
        
        currentIndex = 0;
    }
}


#pragma mark - MPMoviePlayerPlaybackStateDidChangeNotification

-(void) moviePlayerPlaybackStateChanged:(NSNotification *) notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    
    switch (playbackState) {
        case MPMoviePlaybackStatePlaying:
            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped: {
            if (!_played) {
                _played = YES;
            }
            break;
        }
        case MPMoviePlaybackStateInterrupted:{
            if (self.isLoop) {
                moviePlayer.controlStyle = MPMovieControlStyleNone;
                [self.player play];
            }
            break;
        }
        default:{
            break;
        }
    }
}

- (void)onViewClick:(UIGestureRecognizer *)gestureRecognizer {
    [self playIntro:YES];
}

-(void)playIntro:(BOOL)next {
    if (_played) {
        if (next) {
            currentIndex++;
        } else {
            currentIndex--;
        }
        if (currentIndex < 0) {
            return ;
        } else if (currentIndex > 3) {
            [[AppDelegate sharedAppDelegate] removeIntro];
            return;
        }
        NSString *mp4name = [NSString stringWithFormat:@"intro%@",@(currentIndex)];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:mp4name ofType:@"mp4"]];
        [self.player setContentURL:url];
        [self.player play];
    }
}

@end
