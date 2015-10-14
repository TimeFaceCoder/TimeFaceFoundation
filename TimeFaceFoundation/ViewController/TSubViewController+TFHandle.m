//
//  TSubViewController+TFHandle.m
//  TimeFace
//
//  Created by boxwu on 14/11/18.
//  Copyright (c) 2014年 TimeFace. All rights reserved.
//

#import "TSubViewController+TFHandle.h"


@implementation TSubViewController (TFHandle)

/**
 *  提示
 *
 *  @param dic
 */
-(void)progressMessage:(NSDictionary *)dic {
    NSInteger type = [[dic objectForKey:@"type"] integerValue];
    NSString *message = [dic objectForKey:@"message"];
    switch (type) {
        case MessageTypeDefault:
            [SVProgressHUD showImage:nil status:message];
            break;
        case MessageTypeSuccess:
            [SVProgressHUD showSuccessWithStatus:message];
            break;
        case MessageTypeFaild:
            [SVProgressHUD showErrorWithStatus:message];
            break;
            
        default:
            break;
    }
}
//对stateView的扩展

-(void)getTFViewStateMain:(TFViewStateMain)TFViewStateMain
{
    if (TFViewStateMain == TFViewStateMyComment) {
        [self getTFViewState:YES stateViewTitle:@"暂无评论" stateViewButtonTitle:@"测试" stateViewImage:@"NoComment"];
    }
    
    [self showStateView:TFViewStateOther];
    
}


@end
