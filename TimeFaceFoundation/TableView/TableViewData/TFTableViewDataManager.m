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
    _cellViewClickHandler = ^ (RETableViewItem *item ,NSInteger actionType) {
        weakSelf.currentIndexPath = item.indexPath;
        [item deselectRowAnimated:YES];
        if ([weakSelf.tableViewDataSource.delegate respondsToSelector:@selector(actionOnView:actionType:)]) {
            [weakSelf.tableViewDataSource.delegate actionOnView:item actionType:actionType];
        }
        [weakSelf cellViewClickHandler:item actionType:actionType];
    };
    _selectionHandler = ^(RETableViewItem *item) {
        weakSelf.currentIndexPath = item.indexPath;
        [item deselectRowAnimated:YES];

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

- (void)cellViewClickHandler:(RETableViewItem *)item actionType:(NSInteger)actionType {
    
}
- (void)selectionHandler:(RETableViewItem *)item {
    
}
- (void)deleteHanlder:(RETableViewItem *)item completion:(void (^)(void))completion {
    
}

@end
