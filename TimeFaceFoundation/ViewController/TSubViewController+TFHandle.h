//
//  TSubViewController+TFHandle.h
//  TimeFace
//
//  Created by boxwu on 14/11/18.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import "TSubViewController.h"

#import "Custom.h"



@interface TSubViewController (TFHandle) <UINavigationControllerDelegate>

/**
 *  提示
 *
 *  @param dic
 */
-(void)progressMessage:(NSDictionary *)dic;

//扩展出来的stateViewType
- (void)getTFViewStateMain:(TFViewStateMain)TFViewStateMain;

@end
