//
//  AppDelegate.h
//  TimeFaceFoundation
//
//  Created by zguanyu on 9/10/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL isShowIndex;


+ (AppDelegate *)sharedAppDelegate;

@end

