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

@property (nonatomic ,assign) BOOL buildingView;

@property (nonatomic ,assign) BOOL loadCacheData;


@end

const static NSInteger kPageSize = 60;

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

- (void)addPullRefresh {
    __weak typeof(self) weakSelf =self;
    NSMutableArray *progress =[NSMutableArray array];
    for (int i=1;i<=20;i++)
    {
        NSString *fname = [NSString stringWithFormat:@"Loading%02d",i];
        [progress addObject:[UIImage imageNamed:fname]];
    }
    
    [self.tableView addPullToRefreshActionHandler:^{
        typeof(self) strongSelf = weakSelf;
        [strongSelf load:DataLoadPolicyReload params:_params];
        
    }
                                   ProgressImages:progress
                                    LoadingImages:progress
                          ProgressScrollThreshold:60
                           LoadingImagesFrameRate:60];
}

- (void)stopPullRefresh {
    [self.tableView stopPullToRefreshAnimation];
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
        //        //第一次从缓存中加载
        //        [self load:DataLoadPolicyCache params:params];
        
        //第一次从缓存中加载
        if (_useCacheData) {
            [self load:DataLoadPolicyCache params:params];
            
        }//不缓存
        else{
            [self load:DataLoadPolicyNone params:params];
            
        }
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
    TFLog(@"------------------------------load _loading = %@ dataLoadPolicy = %@",@(_loading),@(loadPolicy));
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
    void(^handleTableViewData)(id result,DataLoadPolicy dataLoadPolicy,NSError *hanldeError) = ^(id result,DataLoadPolicy dataLoadPolicy,NSError *hanldeError) {
        TFLog(@"----------------------------------handleTableViewData  loadPolicy = %@",@(dataLoadPolicy));
        typeof(self) strongSelf = weakSelf;
        strongSelf.buildingView = YES;
        if (dataLoadPolicy == DataLoadPolicyReload ||
            dataLoadPolicy == DataLoadPolicyNone) {
            //重新加载
            if (_managerFlag) {
                [strongSelf.mManager removeAllSections];
            }
            else {
                [strongSelf.manager removeAllSections];
            }
        }
        
        if (!result && dataLoadPolicy == DataLoadPolicyCache) {
            //缓存数据为空，触发下拉刷新操作
            [strongSelf.tableView triggerPullToRefresh];
            return;
        }
        
        [strongSelf setTotalPage:[[result objectForKey:@"totalPage"] integerValue]];
        if (_totalPage == 0) {
            _totalPage = 1;
            _currentPage = 1;
        }
        if (dataLoadPolicy == DataLoadPolicyMore) {
            //来自加载下一页,移除loading item
            NSInteger lastSectionIndex = 0;
            if (_managerFlag) {
                lastSectionIndex = [[strongSelf.mManager sections] count] - 1;
                [strongSelf.mManager removeLastSection];
            }
            else {
                lastSectionIndex = [[strongSelf.manager sections] count] - 1;
                [strongSelf.manager removeLastSection];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:lastSectionIndex]
                                    withRowAnimation:UITableViewRowAnimationFade];
            });
        }
        
        
        //read data use network
        [strongSelf.tableViewDataManager reloadView:result
                                              block:^(BOOL finished, id object,NSError *error,NSInteger currentItemCount)
         {
             if (finished) {
                 //加载列
                 strongSelf.buildingView = NO;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //                     _loading = NO;
                     if (_currentPage < _totalPage) {
                         NSInteger sectionCount = 0;
                         if (_managerFlag) {
                             sectionCount = [strongSelf.mManager.sections count];
                         }
                         else {
                             sectionCount = [strongSelf.manager.sections count];
                         }
                         
                         if (_managerFlag) {
                             MYTableViewSection *section = [MYTableViewSection section];
                             [section addItem:[MYTableViewLoadingItem itemWithTitle:NSLocalizedString(@"正在加载...", nil)]];
                             [strongSelf.mManager addSection:section];
                         }
                         else {
                             RETableViewSection *section = [RETableViewSection section];
                             [section addItem:[TableViewLoadingItem itemWithTitle:NSLocalizedString(@"正在加载...", nil)]];
                             [strongSelf.manager addSection:section];
                         }
                         [strongSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]
                                             withRowAnimation:UITableViewRowAnimationFade];
                     }
                     
                     //数据加载完成
                     if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didFinishLoad:error:)]) {
                         [strongSelf.delegate didFinishLoad:dataLoadPolicy error:error?error:hanldeError];
                         [strongSelf stopPullRefresh];
                     }
                     if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didFinishLoad:object:error:)]) {
                         [strongSelf.delegate didFinishLoad:dataLoadPolicy object:object error:error?error:hanldeError];
                         [strongSelf stopPullRefresh];
                     }
                     switch (dataLoadPolicy) {
                         case DataLoadPolicyNone:
                             break;
                         case DataLoadPolicyCache:
                             //开始下拉刷新
                             [strongSelf.tableView triggerPullToRefresh];
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
                             //                             if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(stopPullRefresh)]){
                             //                                 [strongSelf.delegate stopPullRefresh];
                             //                             }
                             //                             [strongSelf stopPullRefresh];
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
                                                   if (!_buildingView) {
                                                       if (loadPolicy == DataLoadPolicyCache && _useCacheData) {                                                       TFLog(@"show cache data===============");
                                                           handleTableViewData(cacheResult,DataLoadPolicyCache,nil);
                                                           [self stopPullRefresh];
                                                           _loading = NO;
                                                           _loadCacheData = YES;
                                                           [weakSelf.delegate didFinishLoad:loadPolicy error:nil];
                                                       }
                                                   }
                                               }
                                           completed:^(id result, NSError *error)
     {
         if (loadPolicy != DataLoadPolicyCache) {
             handleTableViewData(result,loadPolicy,error);
             _loading = NO;
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
    TFLog(@"shouldBatchFetchForTableView");
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
        [self.tableView stopPullToRefreshAnimation];
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


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
    }
    return ret;
}

@end
