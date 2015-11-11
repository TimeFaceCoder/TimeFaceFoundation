//
//  TSubTableViewController.h
//  TimeFaceFire
//
//  Created by zguanyu on 9/9/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TSubViewController.h"
#import "TFTableViewDataSource.h"

@interface TSubTableViewController : TSubViewController <TFTableViewDataSourceDelegate,UISearchBarDelegate, UISearchDisplayDelegate>


@property (nonatomic ,strong ,readonly) UITableView         *tableView;
@property (nonatomic ,strong ,readonly) UISearchBar         *searchBar;
@property (nonatomic ,assign          ) UITableViewStyle    tableViewStyle;
@property (nonatomic ,strong ,readonly) TFTableViewDataSource *dataSource;
@property (nonatomic ,assign          ) NSInteger            listType;
@property (nonatomic ,assign          ) BOOL                loaded;
@property (nonatomic ,assign          ) BOOL                showSearchBar;
@property (nonatomic ,assign          ) BOOL                usePullReload;

//@property (nonatomic, copy) NSString    *APP_ERROR_DOMAIN;

@end
