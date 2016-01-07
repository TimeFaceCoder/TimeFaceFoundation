//
//  TSubTableViewController.h
//  TimeFaceFire
//
//  Created by zguanyu on 9/9/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TSubViewController.h"
#import "TFTableViewDataSource.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface TSubTableViewController : TSubViewController <TFTableViewDataSourceDelegate>


@property (nonatomic ,strong ,readonly) UITableView           *tableView;
@property (nonatomic ,strong ,readonly) ASTableView           *asTableView;
@property (nonatomic ,assign          ) UITableViewStyle      tableViewStyle;
@property (nonatomic ,strong ,readonly) TFTableViewDataSource *dataSource;
@property (nonatomic ,assign          ) NSInteger             listType;
@property (nonatomic ,assign          ) BOOL                  loaded;
@property (nonatomic ,assign          ) BOOL                  usePullReload;
@property (nonatomic ,assign          ) BOOL                  useASKit;


@end
