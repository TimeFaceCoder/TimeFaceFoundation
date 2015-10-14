//
//  TFLibraryGroupViewController.m
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFLibraryGroupViewController.h"
#import "TFLibraryGroupFlowLayout.h"
#import "TFLibraryGroupCollectionViewCell.h"
#import "DBLibraryManager.h"

#if __IPHONE_8_0
@import Photos;
#endif


@interface TFLibraryGroupViewController()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
}

@property (nonatomic ,strong) NSMutableArray    *itemArray;
@property (strong) PHFetchResult    *fetchResult;
@end

static NSString *TFLibraryGroupCollectionIdentifier = @"TFLibraryGroupCollectionIdentifier";


@implementation TFLibraryGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = [[Utility sharedUtility] createBarButtonsWithImage:@"NavButtonBack.png"
                                                                              selectedImageName:@"NavButtonBackH.png"
                                                                                       delegate:self
                                                                                       selector:@selector(onLeftNavClick:)];    [self.view setBackgroundColor:TFSTYLEVAR(viewBackgroundColor)];
    self.navigationItem.title = NSLocalizedString(@"相册", nil);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                         collectionViewLayout:[[TFLibraryGroupFlowLayout alloc] init]];
    
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:self.view.backgroundColor];
    [_collectionView registerClass:[TFLibraryGroupCollectionViewCell class]
        forCellWithReuseIdentifier:TFLibraryGroupCollectionIdentifier];
    
    
    [self.view addSubview:_collectionView];
    
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    __weak typeof(self) weakSelf = self;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if ([group numberOfAssets] > 0) {
                [weakSelf.itemArray addObject:group];
            }
        }
        else {
            [weakSelf.collectionView reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        weakSelf.collectionView.accessibilityLabel = weakSelf.collectionView.backgroundView.accessibilityLabel;
        weakSelf.collectionView.isAccessibilityElement = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.collectionView);
    };
    
    // Camera roll first
    [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                             usingBlock:resultsBlock
                                           failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] enumerateGroupsWithTypes:type
                                             usingBlock:resultsBlock
                                           failureBlock:failureBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    int author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied) {
        //没有访问权限
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"打开相册隐私设置", nil);
        label.textColor = RGBCOLOR(51, 51, 51);
        label.font = TFSTYLEVAR(font18B);
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.tfLeft = (self.view.tfWidth - label.tfWidth) / 2;
        label.tfTop = (self.view.tfHeight - label.tfHeight)/ 2;
        [self.view addSubview:label];
        self.navigationItem.title = NSLocalizedString(@"请求相册权限", nil);
        return;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)onLeftNavClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRightNavClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_itemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFLibraryGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TFLibraryGroupCollectionIdentifier forIndexPath:indexPath];

    ALAssetsGroup *group = [_itemArray objectAtIndex:indexPath.item];
    if (group) {
        UIImage *image = [UIImage imageWithCGImage:group.posterImage];
        [cell updateViews:image
                         title:[group valueForProperty:ALAssetsGroupPropertyName]
                         count:[group numberOfAssets]];
    }
    
   
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFLog(@"indexPath:%@",indexPath);
    if ([self.delegate respondsToSelector:@selector(didSelectedLibraryGroup:)]) {
        ALAssetsGroup *group = [_itemArray objectAtIndex:indexPath.item];
        //ALAssetsGroupPropertyPersistentID
        [self.delegate didSelectedLibraryGroup:group];
    }
}

@end
