//
//  ViewControllerDelegate.h
//  TimeFaceV2
//
//  Created by Melvin on 11/12/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

@class TableViewDataSource;
@class RETableViewItem;
@class TSubViewController;

@protocol ViewControllerDelegate <NSObject>

@required
- (void)onLeftNavClick:(id)sender;
- (void)onRightNavClick:(id)sender;
- (void)actionOnView:(RETableViewItem *)item actionType:(NSInteger)actionType;


@optional
- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoadWithError:(NSError*)error;


@end
