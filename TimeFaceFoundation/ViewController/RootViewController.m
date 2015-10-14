//
//  RootViewController.m
//  TimeFace
//
//  Created by boxwu on 15/4/27.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "RootViewController.h"
#import "TNavigationBar.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [(TNavigationBar*)self.navigationController.navigationBar setBarBgColor:TFSTYLEVAR(navBarBackgroundColor)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupViewControllers];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitleViewIcon.png"]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setupViewControllers {
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TFSTYLEVAR(defaultRedDragColor)}
//                                             forState:UIControlStateSelected];
//    AddCustomViewController *mainViewController = [[AddCustomViewController alloc]init];
//    
////    UINavigationController *mainNav =[[UINavigationController alloc]initWithRootViewController:mainViewController];
//    
//    mainViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"自定义页面" image:nil selectedImage:nil];
//    
//    
//    [self setViewControllers:@[mainViewController]];
//    [self.tabBar setBackgroundImage:[[Utility sharedUtility] createImageWithColor:TFSTYLEVAR(defaultTabBarBgColor)]];
//
//    
////    MainViewController *mainViewController = [[MainViewController alloc] init];
////    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"首页", nil)
////                                                                       image:[[UIImage imageNamed:@"TabBarMain.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
////                                                               selectedImage:[[UIImage imageNamed:@"TabBarMainSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
//
////    
////    
////    
////    [self setViewControllers:@[mainViewController]];
////    [self.tabBar setBackgroundImage:[[Utility sharedUtility] createImageWithColor:TFSTYLEVAR(defaultTabBarBgColor)]];
//}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    self.navigationItem.rightBarButtonItems = nil;
//    self.navigationItem.titleView = nil;
//    if ([viewController isKindOfClass:[MainViewController class]]) {              //首页
//        self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitleViewIcon.png"]];
//    }
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

#pragma mark -
#pragma mark 处理打开Web内容,push消息处理

- (void)handleContent:(id)content type:(PushActionType)type {
    TFLog(@"handleContent:%@",content);
}

#pragma mark -

- (void)handleURL:(NSURL *)url {
    TFLog(@"handleURL:%@",url);

}


@end
