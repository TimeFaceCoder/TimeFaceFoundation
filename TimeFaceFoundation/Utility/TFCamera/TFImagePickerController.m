//
//  TFImagePickerController.m
//  TimeFaceV2
//
//  Created by Melvin on 12/11/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFImagePickerController.h"

@implementation TFImagePickerController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    TFLog(@"%s",__func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TFLog(@"%s",__func__);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *pvLog = [NSString stringWithFormat:@"TimeBook| |%@",NSStringFromClass([self class])];
    [TFLogAgent startTracPage:pvLog];
    TFLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString *pvLog = [NSString stringWithFormat:@"TimeBook| |%@",NSStringFromClass([self class])];
    [TFLogAgent endTracPage:pvLog];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate {
    return YES;
}

@end
