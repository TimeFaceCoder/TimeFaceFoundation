//
//  RootViewController.h
//  TimeFace
//
//  Created by boxwu on 15/4/27.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "TNavigationViewController.h"

@interface RootViewController : UITabBarController<UITabBarControllerDelegate>

- (void)handleContent:(id)content type:(PushActionType)type;

- (void)handleURL:(NSURL *)url;

@end
