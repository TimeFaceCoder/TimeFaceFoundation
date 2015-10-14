//
//  TableViewLoadingItemCell.h
//  TimeFaceFire
//
//  Created by zguanyu on 9/10/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TFTableViewItemCell.h"
#import "TableViewLoadingItem.h"
#import "FLAnimatedImageView.h"

@interface TableViewLoadingItemCell : TFTableViewItemCell

@property (strong, readwrite, nonatomic) TableViewLoadingItem    *item;

@property (strong ,nonatomic           ) FLAnimatedImageView     *loadingImageView;

@property (strong ,nonatomic           ) UIActivityIndicatorView *loadingView;

@end
