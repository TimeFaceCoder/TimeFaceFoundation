//
//  UIPageViewController+ViewPageViewController.m
//  TimeFace
//
//  Created by zguanyu on 2/4/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "UIPageViewController+ViewPageViewController.h"
#import "TimeFaceFoundationConst.h"

#define kObserverForUIQueuingScrollView  @"contentInset"


@implementation UIPageViewController (ViewPage)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (UIView *view in self.view.subviews) {
        TFLog(@"view class = %@",NSStringFromClass([view class]));
        [view addObserver:self forKeyPath:kObserverForUIQueuingScrollView options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew  context:nil];
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kObserverForUIQueuingScrollView]) {
        UIScrollView *view = object;
        TFLog(@"view rect = %@",NSStringFromUIEdgeInsets(view.contentInset));
        if (view.contentInset.top > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                view.contentInset = UIEdgeInsetsMake(0, view.contentInset.left, view.contentInset.bottom, view.contentInset.right);
                view.scrollIndicatorInsets = UIEdgeInsetsMake(0, view.contentInset.left, view.contentInset.bottom, view.contentInset.right);
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    for (UIView *view in self.view.subviews) {
        TFLog(@"view class = %@",NSStringFromClass([view class]));
        if ([view observationInfo]) {
            [view removeObserver:self forKeyPath:kObserverForUIQueuingScrollView context:nil];
        }
        
        
    }
}

@end
