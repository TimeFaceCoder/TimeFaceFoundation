//
//  CLFilterTool.m
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLFilterTool.h"

#import "CLFilterBase.h"

#import "ALAssetsLibrary+TFPhotoAlbum.h"


@interface CLFilterTool()<UIGestureRecognizerDelegate> {
    CLImageToolInfo *_cacheToolInfo;
}

@end



@implementation CLFilterTool
{
    UIView          *_workingView;
    UIImage         *_originalImage;
    UIScrollView    *_menuScroll;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLFilterBase class]];
}

+ (NSString*)defaultTitle
{
    return nil;
    return [CLImageEditorTheme localizedString:@"CLFilterTool_DefaultTitle" withDefault:@"Filter"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 2;
}

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame
                                                                      fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    UITapGestureRecognizer *viewTapClick = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(viewTapClick:)];
    [_workingView addGestureRecognizer:viewTapClick];
    viewTapClick.delegate = self;
    for (UIView *view in self.editor.view.subviews) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            [self.editor.view insertSubview:_workingView belowSubview:view];
        }
    }
    
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setFilterMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}


- (void)viewTapClick:(UITapGestureRecognizer *)gestureRecognizer {
    [self.editor toggleControls];
}


- (void)cleanup
{
    [_workingView removeFromSuperview];

    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

- (void)executeOriginalImage:(NSURL *)URL completionBlock:(void (^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock {
    
    @autoreleasepool {
        [[DBLibraryManager sharedInstance] fixAssetForURL:URL
                                              resultBlock:^(ALAsset *asset){
            //获取原图并进行滤镜处理
            if (asset) {
                static BOOL inProgress = NO;
                if(inProgress){ return; }
                inProgress = YES;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                    UIImage *result = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]
                                                          scale:[assetRepresentation scale]
                                                    orientation:(UIImageOrientation)[assetRepresentation orientation]];
                    
                    
                    UIImage *image = [self filteredImage:result
                                            withToolInfo:_cacheToolInfo];
                    
                    //保存文件到timeface相册
                    [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] saveImage:image
                                                   toAlbum:NSLocalizedString(@"时光流影", nil)
                                       withCompletionBlock:^(id assetURL, NSError *error) {
                                           if ([assetURL isKindOfClass:[NSURL class]]) {
                                               //暂不返回URL
                                           }
                                           if ([assetURL isKindOfClass:[ALAsset class]]) {
                                               ALAssetRepresentation *assetRepresentation = [assetURL defaultRepresentation];
                                               UIImage *fullImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                                               [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:fullImage waitUntilDone:NO];
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   completionBlock(fullImage, nil, @{@"URL":[assetRepresentation url]});
                                               });
                                           }
                    }];
                    inProgress = NO;
                });
                
            }
            else {
                completionBlock(self.editor.imageView.image, nil, nil);
            }
        } failureBlock:^(NSError *error) {
            completionBlock(self.editor.imageView.image, nil, nil);
        }];
        
    }
}



#pragma mark- 

- (void)setFilterMenu
{
    CGFloat W = 70;
    CGFloat x = 0;
    
    UIImage *iconThumbnail = [_originalImage aspectFill:CGSizeMake(46, 46)];
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools) {
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, _menuScroll.height)
                                                                 target:self
                                                                 action:@selector(tappedFilterPanel:)
                                                               toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
        if(view.iconImage==nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *iconImage = [self filteredImage:iconThumbnail withToolInfo:info];
                [view performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:NO];
            });
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedFilterPanel:(UITapGestureRecognizer*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    for (UIView *tempView in _menuScroll.subviews) {
        if ([tempView isKindOfClass:[CLToolbarMenuItem class]]) {
            [(CLToolbarMenuItem *)tempView setSelected:NO];
        }
    }
    
    CLToolbarMenuItem *view = (CLToolbarMenuItem *)sender.view;
    view.alpha = 0.2;
    view.selected = YES;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    _cacheToolInfo = view.toolInfo;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage withToolInfo:view.toolInfo];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class filterClass = NSClassFromString(info.toolName);
        if([(Class)filterClass conformsToProtocol:@protocol(CLFilterBaseProtocol)]){
            return [filterClass applyFilter:image];
        }
        return nil;
    }
}

@end
