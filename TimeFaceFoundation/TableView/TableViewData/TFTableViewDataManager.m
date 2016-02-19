//
//  TFTableDataSourceManager.m
//  
//
//  Created by Melvin on 6/10/15.
//
//

#import "TFTableViewDataManager.h"

@interface TFTableViewDataManager() {
    
}


@end

@implementation TFTableViewDataManager

- (instancetype)initWithDataSource:(TFTableViewDataSource *)tableViewDataSource
                          listType:(NSInteger)listType {
    self = [super init];
    if (!self) {
        return nil;
    }
    _tableViewDataSource = tableViewDataSource;
    __weak __typeof(self)weakSelf = self;
    _cellViewClickHandler = ^ (id item ,NSInteger actionType) {
        if ([item isKindOfClass:[RETableViewItem class]]) {
            weakSelf.currentIndexPath = ((RETableViewItem*)item).indexPath;
            [((RETableViewItem*)item) deselectRowAnimated:YES];
        }
        if ([item isKindOfClass:[MYTableViewItem class]]) {
            weakSelf.currentIndexPath = ((MYTableViewItem*)item).indexPath;
            [((MYTableViewItem*)item) deselectRowAnimated:YES];
        }
        
        
        if ([weakSelf.tableViewDataSource.delegate respondsToSelector:@selector(actionOnView:actionType:)]) {
            [weakSelf.tableViewDataSource.delegate actionOnView:item actionType:actionType];
        }
        [weakSelf cellViewClickHandler:item actionType:actionType];
    };
    _selectionHandler = ^(id item) {
        if ([item isKindOfClass:[RETableViewItem class]]) {
            weakSelf.currentIndexPath = ((RETableViewItem*)item).indexPath;
            [((RETableViewItem*)item) deselectRowAnimated:YES];
        }
        if ([item isKindOfClass:[MYTableViewItem class]]) {
            weakSelf.currentIndexPath = ((MYTableViewItem*)item).indexPath;
            [((MYTableViewItem*)item) deselectRowAnimated:YES];
        }
        
        if ([weakSelf.tableViewDataSource.delegate respondsToSelector:@selector(actionItemClick:)]) {
            [weakSelf.tableViewDataSource.delegate actionItemClick:item];
            
        }
        [weakSelf selectionHandler:item];
    };
    
    _deleteHanlder = ^(RETableViewItem *item ,Completion completion) {
        [weakSelf deleteHanlder:item completion:completion];
    };
    
    return self;
}

- (void)reloadView:(NSDictionary *)result block:(TableViewReloadCompletionBlock)completionBlock {
    
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    
}

- (void)cellViewClickHandler:(id)item actionType:(NSInteger)actionType {
    
}
- (void)selectionHandler:(id)item {
    
}
- (void)deleteHanlder:(id)item completion:(void (^)(void))completion {
    
}

- (void)updateTableViewData:(id)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger sectionCount = 0;
        if (self.tableViewDataSource.manager) {
            sectionCount = [self.tableViewDataSource.manager.sections count];
            [self.tableViewDataSource.manager addSection:section];
        }
        else {
            sectionCount = [self.tableViewDataSource.mManager.sections count];
            [self.tableViewDataSource.mManager addSection:section];
        }
        if (sectionCount > 0) {
            [self.tableViewDataSource.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]
                                              withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            [self.tableViewDataSource.tableView reloadData];
        }
    });
}


@end
