//
//  MYTableViewLoadingItem.m
//  MYTableViewManager
//
//  Created by Melvin on 12/22/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

#import "MYTableViewLoadingItem.h"

@implementation MYTableViewLoadingItem

+ (MYTableViewLoadingItem*)itemWithTtile:(NSString *)title {
    MYTableViewLoadingItem *item = [[MYTableViewLoadingItem alloc] init];
    item.title = title;
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    return item;
}

@end
