//
//  TFTableViewDataSource.m
//  TimeFaceFire
//
//  Created by zguanyu on 9/9/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TFTableViewDataSource.h"
#import "TFTableViewDataManager.h"
#import <EGOCache/EGOCache.h>
#import "CLClassList.h"
#import "URLHelper.h"
#import "UIScrollView+TFPullRefresh.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "TFTableViewItem.h"
#import "TFTableViewItemCell.h"

#import "TableViewLoadingItem.h"
#import "TableViewLoadingItemCell.h"

#import "TFListHeaderView.h"

#import "NetworkAssistant.h"
#import "TimeFaceFoundationConst.h"

#import <MYTableViewManager/MYTableViewLoadingItem.h>
#import <MYTableViewManager/MYTableViewLoadingItemCell.h>


@interface TFTableViewDataSource()<RETableViewManagerDelegate,MYTableViewManagerDelegate> {
    
}

/**
 *  正在加载
 */
@property (nonatomic ,assign) BOOL                           loading;
/**
 *  网络数据加载完成
 */
@property (nonatomic ,assign) BOOL                           finished;
/**
 *  总页数
 */
@property (nonatomic ,assign) NSUInteger                     totalPage;
/**
 *  当前页码
 */
@property (nonatomic ,assign) NSUInteger                     currentPage;
/**
 *  向上滚动阈值
 */
@property (nonatomic ,assign) CGFloat                        upThresholdY;
/**
 *  向下阈值
 */
@property (nonatomic ,assign) CGFloat                        downThresholdY;
/**
 *  当前滚动方向
 */
@property (nonatomic ,assign) NSInteger                previousScrollDirection;
/**
 *  Y轴偏移
 */
@property (nonatomic ,assign) CGFloat                        previousOffsetY;
/**
 *  Y积累总量
 */
@property (nonatomic ,assign) CGFloat                        accumulatedY;

/**
 *  当前列表 NSIndexPath
 */
@property (nonatomic ,strong) NSIndexPath                    *currentIndexPath;
/**
 *  当前列表缓存key
 */
@property (nonatomic ,copy  ) NSString                       *cacheKey;
/**
 *  YES 使用 MYTableViewManager
 */
@property (nonatomic ,assign) BOOL managerFlag;


@end

const static NSInteger kPageSize = 20;

@implementation TFTableViewDataSource

- (id)initWithTableView:(UITableView *)tableView
               listType:(NSInteger)listType
               delegate:(id /*<TFTableViewDataSourceDelegate>*/)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _delegate  = delegate;
    _listType  = listType;
    _tableView = tableView;
    _manager = [[RETableViewManager alloc] initWithTableView:tableView delegate:self];
    //列表模式
    _manager.style.defaultCellSelectionStyle = UITableViewCellSelectionStyleNone;
    [self setupDataSource];
    return self;
}



- (id)initWithASTableView:(ASTableView *)tableView
                 listType:(NSInteger)listType
                 delegate:(id /*<TFTableViewDataSourceDelegate>*/)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _managerFlag = YES;
    _delegate    = delegate;
    _listType    = listType;
    _tableView   = tableView;
    _mManager = [[MYTableViewManager alloc] initWithTableView:tableView
                                                     delegate:self];
    //列表模式
    [self setupDataSource];
    return self;
}


/**
 *  初始化方法
 */
- (void)setupDataSource {
    //注册Cell
    [self registerClass];
    
    if (self.listType && [self.delegate showPullRefresh]) {
        [self addPullRefresh];
    }
    _downThresholdY = 200.0;
    _upThresholdY = 25.0;
    NSString *className = [[URLHelper sharedHelper] classNameByListType:_listType];
    if (className) {
        Class class = NSClassFromString(className);
        _tableViewDataManager = [[class alloc] initWithDataSource:self listType:_listType];
        _tableViewDataManager.listType = _listType;
    }
    
}

- (void)reloadTableViewData:(BOOL)pullToRefresh {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
    }
    if (pullToRefresh) {
        [self.tableView triggerPullToRefresh];
    }
    else {
        [self load:DataLoadPolicyReload params:_params];
    }
}

- (void)startLoading:(BOOL)pullToRefresh params:(NSDictionary *)params {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
    }
    if (pullToRefresh) {
        _params = [NSMutableDictionary dictionaryWithDictionary:params];
        [self.tableView triggerPullToRefresh];
    }
    else {
        [self load:DataLoadPolicyNone params:params];
    }
}

- (void)load:(DataLoadPolicy)loadPolicy params:(NSDictionary *)params {
    [self load:loadPolicy params:params context:nil];
}
/**
 *  加载列表数据
 *
 *  @param loadPolicy
 *  @param params
 */
- (void)load:(DataLoadPolicy)loadPolicy params:(NSDictionary *)params context:(ASBatchContext *)context {
    if (_loading) {
        return;
    }
    if (loadPolicy == DataLoadPolicyMore) {
        if (_currentPage == _totalPage) {
            _finished = YES;
            return;
        }
        _currentPage++;
    }
    else {
        _currentPage = 1;
        _totalPage = 1;
        _finished = NO;
        [self setLastedId:@""];
    }
    //处理网络数据
    if (!_params) {
        _params = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [_params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"currentPage"];
    [_params setValue:[NSNumber numberWithInteger:kPageSize] forKey:@"pageSize"];
    
    if (params) {
        [_params addEntriesFromDictionary:params];
    }
    if ([self getLastedId]) {
        [_params setValue:[self getLastedId] forKey:@"lastedId"];
    }
    
    __weak __typeof(self)weakSelf = self;
    void(^handleTableViewData)(id result,DataLoadPolicy dataLoadPolicy) = ^(id result,DataLoadPolicy dataLoadPolicy) {
        if (dataLoadPolicy == DataLoadPolicyReload ||
            dataLoadPolicy == DataLoadPolicyNone) {
            //重新加载
            if (_managerFlag) {
                [weakSelf.mManager removeAllSections];
            }
            else {
                [weakSelf.manager removeAllSections];
            }
        }
        
        [weakSelf setTotalPage:[[result objectForKey:@"totalPage"] integerValue]];
        if (_totalPage == 0) {
            _totalPage = 1;
            _currentPage = 1;
        }
        if (dataLoadPolicy == DataLoadPolicyMore) {
            //来自加载下一页,移除loading item
            NSInteger lastSectionIndex = 0;
            if (_managerFlag) {
                lastSectionIndex = [[weakSelf.mManager sections] count] - 1;
                [weakSelf.mManager removeLastSection];
            }
            else {
                lastSectionIndex = [[weakSelf.manager sections] count] - 1;
                [weakSelf.manager removeLastSection];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:lastSectionIndex]
                                  withRowAnimation:UITableViewRowAnimationFade];
            });
        }
        
        
        //read data use network
        [weakSelf.tableViewDataManager reloadView:result
                                            block:^(BOOL finished, id object,NSError *error,NSInteger currentItemCount)
         {
             if (finished) {
                 //加载列
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     _loading = NO;
                     if (_currentPage < _totalPage) {
                         NSInteger sectionCount = 0;
                         if (_managerFlag) {
                             sectionCount = [weakSelf.mManager.sections count];
                         }
                         else {
                             sectionCount = [weakSelf.manager.sections count];
                         }
                         
                         if (_managerFlag) {
                             MYTableViewSection *section = [MYTableViewSection section];
                             [section addItem:[MYTableViewLoadingItem itemWithTitle:NSLocalizedString(@"正在加载...", nil)]];
                             [weakSelf.mManager addSection:section];
                         }
                         else {
                             RETableViewSection *section = [RETableViewSection section];
                             [section addItem:[TableViewLoadingItem itemWithTitle:NSLocalizedString(@"正在加载...", nil)]];
                             [weakSelf.manager addSection:section];
                         }
                         [weakSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]
                                           withRowAnimation:UITableViewRowAnimationFade];
                     }
                     
                     //数据加载完成
                     if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didFinishLoad:error:)]) {
                         [weakSelf.delegate didFinishLoad:dataLoadPolicy error:error];
                         [weakSelf stopPullRefresh];
                     }
                     switch (dataLoadPolicy) {
                         case DataLoadPolicyNone:
                             break;
                         case DataLoadPolicyCache:
                             //开始下拉刷新
                             [weakSelf.tableView triggerPullToRefresh];
                             break;
                         case DataLoadPolicyMore:{
                             if (_managerFlag) {
                                 if (context) {
                                     [context completeBatchFetching:YES];
                                 }
                             }
                         }
                             break;
                         case DataLoadPolicyReload:
                             //结束下拉刷新动画
                             if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(stopPullRefresh)]){
                                 [weakSelf.delegate stopPullRefresh];
                             }
                             [weakSelf stopPullRefresh];
                             break;
                         default:
                             break;
                     }
                 });
             }
         }];
    };
    
    NSString *url = [[URLHelper sharedHelper] urlByListType:_listType];
    [[NetworkAssistant sharedAssistant] getDataByURL:url
                                              params:_params
                                            fileData:nil
                                                 hud:nil
                                               start:^(id cacheResult){
                                                   _loading = YES;
                                               }
                                           completed:^(id result, NSError *error)
     {
         if (error) {
             //处理出错且没有缓存的情况
             handleTableViewData(nil,loadPolicy);
             _loading = NO;
             [weakSelf.delegate didFinishLoad:loadPolicy error:error];
             [self stopPullRefresh];
             
         }
         else {
             handleTableViewData(result,loadPolicy);
         }
     }];
}

- (void)dealloc {
    _manager.delegate = nil;
    _tableView = nil;
    _manager = nil;
    
    _mManager.delegate = nil;
    _mManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    if (_tableViewDataManager) {
        [_tableViewDataManager refreshCell:actionType dataId:dataId];
    }
}

- (id)tableViewItemByIndexPath:(NSIndexPath *)indexPath {
    if (_managerFlag) {
        MYTableViewSection *section = [[self.mManager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            MYTableViewItem *item = (MYTableViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }        }
    }
    else {
        RETableViewSection * section = [[self.manager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            RETableViewItem *item = (RETableViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }
        }
    }
    return nil;
}
#pragma mark - Private

/**
 *  注册列表Cell类型
 */
- (void)registerClass {
    NSArray *tableViewItemlist = [CLClassList subclassesOfClass:[TFTableViewItem class]];
    if (_managerFlag) {
        tableViewItemlist = [CLClassList subclassesOfClass:[MYTableViewItem class]];
    }
    for (Class itemClass in tableViewItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        if (_managerFlag) {
            self.mManager[itemName] = [itemName stringByAppendingString:@"Cell"];
        }
        else {
            self.manager[itemName]   = [itemName stringByAppendingString:@"Cell"];
        }
    }
}

/**
 *  滚动方向判断
 *
 *  @param currentOffsetY
 *  @param previousOffsetY
 *
 *  @return ScrollDirection
 */
- (NSInteger)detectScrollDirection:(CGFloat)currentOffsetY previousOffsetY:(CGFloat)previousOffsetY {
    return currentOffsetY > previousOffsetY ? kTFScrollDirectionUp   :
    currentOffsetY < previousOffsetY ? kTFScrollDirectionDown :
    kTFScrollDirectionNone;
}

- (NSString *)getLastedId {
    NSString *lastedId = @"";
    lastedId = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"ListLastedId_%@",@(_listType)]];
    return lastedId;
}

- (void)setLastedId:(NSString *)lastedId {
    [[NSUserDefaults standardUserDefaults] setValue:lastedId
                                             forKey:[NSString stringWithFormat:@"ListLastedId_%@",@(_listType)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadMore {
    if (_currentPage < _totalPage) {
        [self load:DataLoadPolicyMore params:_params];
    }
}

#pragma mark - Delegate

#pragma mark - MYTableViewManagerDelegate
/**
 *  列表是否需要加载更多数据
 *
 *  @param tableView
 *
 *  @return
 */
- (BOOL)shouldBatchFetchForTableView:(ASTableView *)tableView {
    return _currentPage < _totalPage;
}
/**
 *  列表开始加载更多数据
 *
 *  @param tableView
 *  @param context
 */
- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    TFLog(@"willBeginBatchFetchWithContext");
    [self load:DataLoadPolicyMore params:_params context:context];
}

- (void)my_tableView:(UITableView *)tableView willLoadCell:(MYTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[MYTableViewLoadingItemCell class]]) {
        //        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)stopLoading {
    if (_listType || [self.delegate showPullRefresh]) {
        [self.tableView stopPullToRefresh];
    }
}

- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}
- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}

- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"删除", nil);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray
                                           arrayWithObjects:indexPath,nil]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath; {
    if ([cell isKindOfClass:[TableViewLoadingItemCell class]]) {
        [self performSelector:@selector(loadMore) withObject:nil afterDelay:0.3];
    }
    
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:_tableView];
    }
    
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    NSInteger currentScrollDirection = [self detectScrollDirection:currentOffsetY previousOffsetY:_previousOffsetY];
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
    BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
    
    BOOL isBouncing = (isOverTopBoundary && currentScrollDirection != kTFScrollDirectionDown) || (isOverBottomBoundary && currentScrollDirection != kTFScrollDirectionUp);
    if (isBouncing || !scrollView.isDragging) {
        return;
    }
    
    CGFloat deltaY = _previousOffsetY - currentOffsetY;
    _accumulatedY += deltaY;
    
    if (currentScrollDirection == kTFScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        
        if (isOverThreshold || isOverBottomBoundary)  {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollUp:)]) {
                [_delegate scrollViewDidScrollUp:deltaY];
            }
        }
    }
    else if (currentScrollDirection == kTFScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        
        if (isOverThreshold || isOverTopBoundary) {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollDown:)]) {
                [_delegate scrollViewDidScrollDown:deltaY];
            }
        }
    }
    else {
        
    }
    
    
    // reset acuumulated y when move opposite direction
    if (!isOverTopBoundary && !isOverBottomBoundary && _previousScrollDirection != currentScrollDirection) {
        _accumulatedY = 0;
    }
    
    _previousScrollDirection = currentScrollDirection;
    _previousOffsetY = currentOffsetY;
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (_previousScrollDirection == kTFScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
        
        if (isOverThreshold || isOverBottomBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp];
            }
        }
    }
    else if (_previousScrollDirection == kTFScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
        
        if (isOverThreshold || isOverTopBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
                [self setLastedId:@""];
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
            }
        }
        
    }
    else {
        
    }
}

- (void)addPullRefresh {
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self load:DataLoadPolicyReload params:_params];
    }];
}

- (void)stopPullRefresh {
    [self.tableView stopPullToRefresh];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
    }
    return ret;
}

@end
