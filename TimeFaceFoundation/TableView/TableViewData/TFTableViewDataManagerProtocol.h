//
//  TableViewDataToolProtocol.h
//  TimeFaceV2
//
//  Created by Melvin on 6/10/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//
#import <RETableViewManager/RETableViewManager.h>
#import "TFTableViewDataSource.h"

//列表内View事件
typedef void (^CellViewClickHandler)(RETableViewItem *item ,NSInteger actionType);
//列表点击事件
typedef void (^SelectionHandler)(RETableViewItem *item);
//删除block
typedef void (^DeleteHanlder)(RETableViewItem *item);
//列表Cell load 完成block
typedef void(^TableViewReloadCompletionBlock)(BOOL finished,id object,NSError *error);

@protocol TFTableViewDataManagerProtocol <NSObject>

@required
/**
 *  列表业务类初始化
 *
 *  @param tableViewDataSource 列表数据源
 *  @param listType            列表类型
 *
 *  @return TFTableDataSourceManager
 */
- (instancetype)initWithDataSource:(TFTableViewDataSource *)tableViewDataSource
                          listType:(NSInteger)listType;

/**
 *  显示列表数据
 *
 *  @param result          数据字典
 *  @param completionBlock 回调block
 */
- (void)reloadView:(NSDictionary *)result block:(TableViewReloadCompletionBlock)completionBlock;
/**
 *  列表内View事件处理
 *
 *  @param item
 *  @param actionType
 */
- (void)cellViewClickHandler:(RETableViewItem *)item actionType:(NSInteger)actionType;
/**
 *  列表点击事件处理
 *
 *  @param item
 */
- (void)selectionHandler:(RETableViewItem *)item;
/**
 *  列表删除事件处理
 *
 *  @param item 
 */
- (void)deleteHanlder:(RETableViewItem *)item;

/**
 *  刷新指定Cell
 *
 *  @param actionType
 *  @param dataId
 */
- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId;



@optional

@end