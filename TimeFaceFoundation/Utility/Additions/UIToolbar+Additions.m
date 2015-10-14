//
//  UIToolbar+Additions.m
//  MPBFramework
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UIToolbar+Additions.h"

@implementation UIToolbar (Additions)
- (UIBarButtonItem*)itemWithTag:(NSInteger)tag {
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            return button;
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item {
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:item];
            self.items = newItems;
            break;
        }
        ++buttonIndex;
    }
}

@end
