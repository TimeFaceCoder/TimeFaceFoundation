//
//  TFTableDataSourceManager.h
//  
//
//  Created by Melvin on 6/10/15.
//
//

#import <Foundation/Foundation.h>
#import "TFTableViewDataManagerProtocol.h"
#import "TFTableViewDataSource.h"
//
@interface TFTableViewDataManager : NSObject<TFTableViewDataManagerProtocol>

@property (nonatomic ,weak  ) TFTableViewDataSource *tableViewDataSource;
/**
 *  列表内点击事件 block
 */
@property (nonatomic ,strong) CellViewClickHandler   cellViewClickHandler;
/**
 *  列表行点击事件 block
 */
@property (nonatomic ,strong) SelectionHandler       selectionHandler;
/**
 *  列表删除事件 block
 */
@property (nonatomic ,strong) DeleteHanlder          deleteHanlder;
/**
 *  当前
 */
@property (nonatomic ,strong) NSIndexPath            *currentIndexPath;
/**
 *  列表类型
 */
@property (nonatomic ,assign) NSInteger                       listType;

@end
