// TFTabBarController.m
// TFTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TFTabBarController.h"
#import "TFTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (TFTabBarControllerItemInternal)

- (void)tf_setTabBarController:(TFTabBarController *)tabBarController;

@end

@interface TFTabBarController () {
    UIView *_contentView;
}

@property (nonatomic, readwrite) TFTabBar *tabBar;
@property (nonatomic, readwrite) UIButton *actionButton;


@end

@implementation TFTabBarController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
    [self setTabBarHidden:NO animated:NO];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            TFTabBarItem *tabBarItem = [[TFTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController tf_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController tf_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (TFTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TFTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}



- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _tabBarHidden = hidden;
    
    __weak TFTabBarController *weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        TFLog(@"viewSize = %@", NSStringFromCGSize(viewSize));
        
        if (!tabBarHeight) {
            tabBarHeight = 50;
        }
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

- (void)showTFTabBar:(BOOL)animated
{
    CGSize viewSize = [self contentView].frame.size;
    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
    CGFloat toolbarHeight = [self tabBar].frame.size.height;
    [self setTFTabBarOriginY:viewHeight - toolbarHeight animated:animated];
}

- (void)hideTFTabBar:(BOOL)animated
{
    CGSize viewSize = [self contentView].frame.size;
    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
    [self setTFTabBarOriginY:viewHeight animated:animated];
}

- (void)moveTFTabBar:(CGFloat)deltaY animated:(BOOL)animated
{
    CGRect frame = [self tabBar].frame;
    CGFloat nextY = frame.origin.y + deltaY;
    [self setTFTabBarOriginY:nextY animated:animated];
}

- (void)setTFTabBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGRect frame = [self tabBar].frame;
    CGFloat toolBarHeight = frame.size.height;
    CGSize viewSize = [self contentView].frame.size;
    CGFloat viewHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? viewSize.height : viewSize.width;
    
    CGFloat topLimit = viewHeight - toolBarHeight;
    CGFloat bottomLimit = viewHeight;
    
    frame.origin.y = fmin(fmax(y, topLimit), bottomLimit); // limit over moving
    
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        [self tabBar].frame = frame;
    }];
}


#pragma mark - TFTabBarDelegate

- (BOOL)tabBar:(TFTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_RECLICK_ROOTBAR object:self userInfo:@{@"index":@(index)}];
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(TFTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

- (void)onViewClick:(id)sender {
}




@end

#pragma mark - UIViewController+TFTabBarControllerItem

@implementation UIViewController (TFTabBarControllerItemInternal)

- (void)tf_setTabBarController:(TFTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(tf_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (TFTabBarControllerItem)

- (TFTabBarController *)tf_tabBarController {
    TFTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(tf_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController tf_tabBarController];
    }
    
    return tabBarController;
}

- (TFTabBarItem *)tf_tabBarItem {
    TFTabBarController *tabBarController = [self tf_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)tf_setTabBarItem:(TFTabBarItem *)tabBarItem {
    TFTabBarController *tabBarController = [self tf_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    TFTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end
