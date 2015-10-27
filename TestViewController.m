//
//  TestViewController.m
//  TimeFaceFoundation
//
//  Created by zguanyu on 10/26/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NetWorkUrlBlock block = ^(NSString *interface, NSString *url){
//        if ([interface isEqualToString:@"keyLogin"]) {
//            url = [NSString stringWithFormat:@"%@%@",@"dsdsd",interface];
//        } else {
//            url = [NSString stringWithFormat:@"%@%@",@"dsdsds",interface];
//        }
//        return url;
//    };
//    
//    [[NetworkAssistant sharedAssistant] setUrlBlock:block];
//    
//    [[NetworkAssistant sharedAssistant] getDataByInterFace:@"dsdsds" params:nil fileData:nil hud:nil start:nil completed:^(id result, NSError *error)
//     {
//        
//     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
