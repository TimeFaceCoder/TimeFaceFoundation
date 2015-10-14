//
//  TFTableViewDataSource.h
//  TimeFaceFire
//
//  Created by zguanyu on 9/9/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RETableViewManager/RETableViewManager.h>

typedef NS_ENUM(NSInteger, DataLoadPolicy) {
    /**
     *  正常加载
     */
    DataLoadPolicyNone      = 0,
    /**
     *  加载下一页
     */
    DataLoadPolicyMore      = 1,
    /**
     *  重新加载
     */
    DataLoadPolicyReload    = 2,
    /**
     *  从缓存加载
     */
    DataLoadPolicyCache     = 3,
};

@protocol TFTableViewDataSourceDelegate <NSObject>

@required

- (void)actionOnView:(RETableViewItem *)item actionType:(NSInteger)actionType;

- (void)actionItemClick:(RETableViewItem*)item;

- (void)didStartLoad;

- (void)didFinishLoad:(DataLoadPolicy)loadPolicy;

- (void)didFailLoadWithError:(NSError*)error;

@optional
- (BOOL)showPullRefresh;

- (void)stopPullRefresh;

- (CGFloat)topInsetY;

- (void)actionWithPullRefresh;

- (void)tableViewExpandData:(id)expandData success:(BOOL)success;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidScrollUp:(CGFloat)deltaY;

- (void)scrollViewDidScrollDown:(CGFloat)deltaY;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TFTableViewDataSource : NSObject
/**
 *  列表代理
 */
@property (nonatomic ,weak  ) id<TFTableViewDataSourceDelegate> delegate;
/**
 *  tableview
 */
@property (nonatomic ,weak  ) UITableView                    *tableView;
/**
 *  tableview 管理器
 */
@property (nonatomic ,strong) RETableViewManager             *manager;

@property (nonatomic ,copy  ) NSString                       *lastedId;

@property (nonatomic, strong) NSString  *addressId;

/**
 *  参数字典
 */
@property (nonatomic ,strong) NSMutableDictionary            *params;
/**
 *  item的数量
 */
@property (nonatomic ,assign) NSInteger           itemCount;

- (id)initWithTableView:(UITableView *)tableView
               listType:(NSInteger)listType
               delegate:(id /*<NewTableViewDataSourceDelegate>*/)delegate;
/**
 *  加载列表数据
 *
 *  @param loadPolicy
 *  @param params
 */
- (void)load:(DataLoadPolicy)loadPolicy params:(NSDictionary *)params;
/**
 *  刷新列表数据
 *
 *  @param pullToRefresh 是否使用下拉刷新模式
 */
- (void)reloadTableViewData:(BOOL)pullToRefresh;

/**
 *  停止加载
 */
- (void)stopLoading;

/**
 *  刷新指定Cell
 *
 *  @param actionType
 *  @param dataId
 */
- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId;

//返回item
- (RETableViewItem *)tableViewItemByIndexPath:(NSIndexPath *)indexPath;

/**
 *  添加下拉刷新组件，子类或者category可重写
 */
- (void)addPullRefresh;
/**
 *  停止下拉刷新，子类或者category可重写
 */
- (void)stopPullRefresh;

@end
