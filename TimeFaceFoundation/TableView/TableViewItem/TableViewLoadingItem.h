//
//  TableViewLoadingItem.h
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFTableViewItem.h"

@interface TableViewLoadingItem : TFTableViewItem


@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,NSInteger actionType);

+ (TableViewLoadingItem *)itemWithTitle:(NSString *)title
                       clickHandler:(void(^)(TableViewLoadingItem *item,NSInteger actionType))clickHandler
                   selectionHandler:(void(^)(TableViewLoadingItem *item))selectionHandler;


@end
