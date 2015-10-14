//
//  TFLibraryViewController.m
//  TimeFaceV2
//
//  Created by Melvin on 11/25/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "TFLibraryViewController.h"
#import "TFCameraCollectionViewCell.h"
#import "TFCameraViewCollectionViewCell.h"
#import "TFLibraryViewCollectionViewCell.h"
#import "TFCameraCollectionViewFlowLayout.h"

#import "TFLibraryGroupViewController.h"

#import "TFImagePickerController.h"

#import "DBLibraryManager.h"

#import "TFImageCropViewController.h"
#import "TNavigationViewController.h"

#import <pop/POP.h>

#import "ALAssetsLibrary+TFPhotoAlbum.h"

#import "TFPhotoBrowser.h"
#import "PhotoGroup.h"
#import "LibraryCollectionHeaderView.h"

#import <CoreLocation/CoreLocation.h>

@interface TFLibraryViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TFLibraryGroupDelegate,TFPhotoBrowserDelegate,TFCameraViewCollectionViewCellDelegate> {
    BOOL            _isEnumeratingGroups;
    UIButton        *_countButton;
    UIButton        *_libraryButton;
    UIButton        *_changeStyleButton;        //列表样式按钮
    BOOL            firstLoaded;
    NSMutableArray  *_infos;
}

@property (nonatomic, strong) ALAssetsGroup             *currentGroup;
@property (nonatomic, strong) UIView                    *footerView;
@property (nonatomic, strong) NSMutableArray            *removeAssets;
@property (nonatomic, strong) TFImageCropViewController *editorViewController;
@property (nonatomic, strong) UIImagePickerController   *imagePickerController;
@property (nonatomic, strong) TFPhotoBrowser            *photoBrowser;


@end
static NSString *CollectionIdentifier        = @"TFCollectionIdentifier";
static NSString *CollectionCameraIdentifier  = @"CollectionCameraIdentifier";
static NSString *CollectionLibraryIdentifier = @"CollectionLibraryIdentifier";


@implementation TFLibraryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allowsMultipleSelection = YES;
//        _maximumNumberOfSelection = DEFAULT_IMAGE_COUNT;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _items = [NSMutableArray arrayWithCapacity:1];
    _minimumNumberOfSelection = 1;

    [self.view setBackgroundColor:TFSTYLEVAR(viewBackgroundColor)];
    
    self.navigationItem.leftBarButtonItems = [[Utility sharedUtility] createBarButtonsWithImage:@"NavButtonDownClose.png" selectedImageName:@"NavButtonDownCloseH.png" delegate:self selector:@selector(onLeftNavClick:)];
    
    self.navigationItem.rightBarButtonItems = [[Utility sharedUtility] createBarButtonsWithTitle:NSLocalizedString(@"下一步", nil) delegate:self selector:@selector(onRightNavClick:)];
    
    [self.view addSubview:self.collectionView];
    
    if (_allowsMultipleSelection) {
        [self.view addSubview:self.footerView];
        _collectionView.tfHeight = _collectionView.tfHeight;
    }
    else {
        self.navigationItem.rightBarButtonItems = [[Utility sharedUtility] createBarButtonsWithTitle:NSLocalizedString(@"相册", nil) delegate:self selector:@selector(libraraySelected:)];
        
    }
    self.navigationItem.title = NSLocalizedString(@"正在加载", nil);
}

-(UICollectionView *) collectionView {
    if (!_collectionView) {
        TFCameraCollectionViewFlowLayout *flowLayout = [[TFCameraCollectionViewFlowLayout alloc] init];

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setAllowsMultipleSelection:self.allowsMultipleSelection];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        [_collectionView registerClass:[TFCameraCollectionViewCell class]
            forCellWithReuseIdentifier:CollectionIdentifier];
        [_collectionView registerClass:[TFCameraViewCollectionViewCell class]
            forCellWithReuseIdentifier:CollectionCameraIdentifier];
        [_collectionView registerClass:[TFLibraryViewCollectionViewCell class]
            forCellWithReuseIdentifier:CollectionLibraryIdentifier];
        [_collectionView registerClass:[LibraryCollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"SectionHeaderView"];
        
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.footerReferenceSize = CGSizeZero;
    }
    return _collectionView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if (!firstLoaded) {
        __weak typeof(self) blockSelf = self;
        __block ALAssetsGroup *blockGroup;
        ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group) {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                blockGroup = group;
                _currentGroup = group;
            }
            else {
                [blockSelf loadGroupsAsset:blockGroup];
                [blockSelf photosGroup:_photos];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            TFLog(@"error:%@",[error debugDescription]);
            
        };
        
        //Camera roll first
        [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                 usingBlock:resultsBlock
                                               failureBlock:failureBlock];
        firstLoaded= YES;
    }
    else {

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    UICollectionViewCell *visibleCell= [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (visibleCell && [visibleCell isKindOfClass:[TFCameraViewCollectionViewCell class]]) {
        TFCameraViewCollectionViewCell *cameraCell = (TFCameraViewCollectionViewCell *)visibleCell;
        [cameraCell startCamera];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UICollectionViewCell *visibleCell= [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (visibleCell && [visibleCell isKindOfClass:[TFCameraViewCollectionViewCell class]]) {
        TFCameraViewCollectionViewCell *cameraCell = (TFCameraViewCollectionViewCell *)visibleCell;
        [cameraCell removeCamera];
    }
}

- (void)onLeftNavClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

- (void)onRightNavClick:(id)sender {
    if ([_selectedAssets count] <=0) {
        return;
    }
    
    if (!_photoBrowser) {
        _photoBrowser = [[TFPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.view.alpha  = 0;
        if (_expandData) {
            [_photoBrowser setExpandData:_expandData];
        }
    }
    
    [UIView animateWithDuration:.35
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^
     {
         [self presentViewController:_photoBrowser animated:NO completion:nil];
         _photoBrowser.view.alpha  = 1;
     } completion:^(BOOL finished) {
         
     }];
    [_photoBrowser reloadData];
    
}

- (void)libraraySelected:(id)sender {
    TFLibraryGroupViewController *libraryGroupViewController = [[TFLibraryGroupViewController alloc] init];
    libraryGroupViewController.delegate = self;
    TNavigationViewController *navController = [[TNavigationViewController alloc] initWithRootViewController:libraryGroupViewController];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (void)librarayDidSelected:(id)sender {
    if ([_libraryControllerDelegate respondsToSelector:@selector(didSelectAssets:removeList:infos:)]) {
        [_libraryControllerDelegate didSelectAssets:_selectedAssets removeList:_removeAssets infos:_photoBrowser.tagInfos];
    }
}

- (void)dealloc {
    _libraryControllerDelegate = nil;
    _imagePickerController.delegate = nil;
    _imagePickerController = nil;
    _infos = nil;
}


- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.tfHeight - 44, self.view.tfWidth, 44)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _footerView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8f);
        
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.width, .5)];
//        view.backgroundColor = TFSTYLEVAR(boldLineColor);
//        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
//        [_footerView addSubview:view];
        
        _libraryButton = [UIButton createButtonWithTitle:NSLocalizedString(@"所有照片", nil)
                                                  target:self
                                                selector:@selector(libraraySelected:)];
        
        [_libraryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [[_libraryButton titleLabel] setFont:TFSTYLEVAR(font14)];

        [_libraryButton setBackgroundImage:[[Utility sharedUtility] createImageWithColor:TFSTYLEVAR(librarySelectedBgColor)]
                                  forState:UIControlStateNormal];
        [_libraryButton setBackgroundImage:[[Utility sharedUtility] createImageWithColor:TFSTYLEVAR(librarySelectedHBgColor)]
                                  forState:UIControlStateHighlighted];
        
        _libraryButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _libraryButton.layer.cornerRadius = 4;
        _libraryButton.layer.masksToBounds = YES;
        _libraryButton.tfSize = CGSizeMake(76, 28);
        _libraryButton.tfLeft = VIEW_LEFT_SPACE;
        _libraryButton.tfTop = (_footerView.tfHeight - _libraryButton.tfHeight) /2 ;
        
        [_footerView addSubview:_libraryButton];
        
        _changeStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeStyleButton.tfSize = CGSizeMake(44.f, 44.f);
        [_changeStyleButton setImage:[UIImage imageNamed:@"LibraryListShowIcon.png"] forState:UIControlStateNormal];
        [_changeStyleButton setImage:[UIImage imageNamed:@"LibraryTileShowIcon.png"] forState:UIControlStateSelected];
        [_changeStyleButton addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_changeStyleButton setTitle:@"" forState:UIControlStateNormal];
        _changeStyleButton.tfCenterX = _footerView.tfWidth/2;
        _changeStyleButton.tfCenterY = _footerView.tfHeight/2;;
//        [_footerView addSubview:_changeStyleButton];
        
        _countButton = [UIButton createButtonWithTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
                                                    target:self
                                                  selector:@selector(librarayDidSelected:)];
        [[_countButton titleLabel] setFont:TFSTYLEVAR(font14)];
        [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countButton setBackgroundColor:TFSTYLEVAR(defaultBlueColor)];
        _countButton.autoresizingMask =UIViewAutoresizingFlexibleWidth;
        _countButton.layer.cornerRadius = 4;
        _countButton.tfSize = CGSizeMake(76, 28);
        _countButton.tfLeft = _footerView.tfWidth - _countButton.tfWidth - VIEW_LEFT_SPACE;
        _countButton.tfTop = (_footerView.tfHeight - _countButton.tfHeight) /2 ;
        
        [_footerView addSubview:_countButton];
        
    }
    return _footerView;
}

-(void) changeStyle:(id)sender {
    _changeStyleButton.selected = !_changeStyleButton.selected;
    [self photosGroup:self.photos];
    [self.collectionView reloadData];
}

- (void) loadGroupsAsset:(ALAssetsGroup *)group
{
    if ( _isEnumeratingGroups )
        return;
    
    __weak typeof(self) blockSelf = self;
    
    __block BOOL isEnumeratingGroupsBlock = _isEnumeratingGroups;
    isEnumeratingGroupsBlock = YES;
    
    self.navigationItem.title = [group valueForProperty:ALAssetsGroupPropertyName];
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    [_photos removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset) {
            TFPhoto *photo = [[TFPhoto alloc] init];
            photo.thumbnail = [[asset defaultRepresentation] url];
            NSDate *date  = [asset valueForProperty:ALAssetPropertyDate];
            photo.datetime = date;
            photo.date = [[Utility sharedUtility] stringFromDate:date format:@"yyyy-MM-dd"];
            [self.photos addObject:photo];
            
//            NSDictionary *metadata = asset.defaultRepresentation.metadata;
//            TFLog(@"gps = %@",[metadata objectForKey:@"{GPS}"]);
//            CLLocation *loc = [asset valueForProperty:ALAssetPropertyLocation];
//            imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];
//            [self addEntriesFromDictionary:metadata];
        }
        else {
            [blockSelf photosGroup:self.photos];
            [blockSelf.collectionView reloadData];
            isEnumeratingGroupsBlock = NO;
        }
    };
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
}

-(void) photosGroup:(NSMutableArray *)photos {
    if (!self.items) {
        self.items = [[NSMutableArray alloc] init];
    }
    [self.items removeAllObjects];
    NSArray *sorts = [photos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject <TFPhoto> *photo1 = obj1;
        NSObject <TFPhoto> *photo2 = obj2;
        return ![photo1.datetime compare:photo2.datetime];
    }];
    
    for (TFPhoto *photo in sorts) {
        PhotoGroup *group = ^PhotoGroup *{
            for (PhotoGroup *group in self.items) {
                if ([group.category isEqualToString:photo.date] || !_changeStyleButton.selected)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[PhotoGroup alloc] init];
            group.category = photo.date;
            [group.photos addObject:photo];
            [self.items addObject:group];
        } else {
            [group.photos addObject:photo];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _items                = nil;
    _photos               = nil;
    _photoBrowser         = nil;
    _editorViewController = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (!self.items.count) {
        return 1;
    }
    PhotoGroup *group = [self.items objectAtIndex:section];
    NSInteger count = group.photos.count;
    if (section == 0) {
        count++;
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!self.items.count) {
        return 1;
    }
    return self.items.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.items.count <= 1) {
        return CGSizeZero;
    }
    return CGSizeMake(self.view.tfWidth, 20.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView
            viewForSupplementaryElementOfKind:(NSString *)kind
                                  atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        LibraryCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
        PhotoGroup *group = [self.items objectAtIndex:indexPath.section];
        [headerView refreshTitle:group.category];
        headerView.backgroundColor = [UIColor clearColor];
        
        reusableview = headerView;
    }

    return reusableview;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        TFCameraViewCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCameraIdentifier forIndexPath:indexPath];
        [item startCamera];
        return item;
    } else {
        //相册内容
        TFCameraCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionIdentifier forIndexPath:indexPath];
        [item.itemImage setImage:nil];
        
        __weak TFCameraCollectionViewCell *blockItem = item;
        blockItem.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
        PhotoGroup *group = [self.items objectAtIndex:indexPath.section];
        if (group.photos.count > 0) {
            TFPhoto *photo = [group.photos objectAtIndex:(!indexPath.section?(indexPath.row - 1):indexPath.row)];
            if (photo.thumbnail) {
                if ([_selectedAssets containsObject:photo.thumbnail]) {
                    item.selected = YES;
                    [_collectionView selectItemAtIndexPath:indexPath
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
                }
                
                [[DBLibraryManager sharedInstance] fixAssetForURL:photo.thumbnail
                                                      resultBlock:^(ALAsset *asset)
                 {
                     if (asset) {
                         UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                         [blockItem updateItemImage:image];
                     }
                 } failureBlock:^(NSError *error) {
                     TFLog(@"read asset error:%@",[error debugDescription]);
                 }];
            }
        }
        
        return item;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate


- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:([self.selectedAssets count] + 1)];
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!_selectedAssets) {
            _selectedAssets = [NSMutableArray array];
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            
            [self presentViewController:imagePickerController
                               animated:YES
                             completion:^{
                                 TFCameraViewCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCameraIdentifier
                                                                                                                  forIndexPath:indexPath];
                                 [item removeCamera];
                             }];
        }
        else {
            [SVProgressHUD showImage:nil status:@"不支持相机"];
        }

        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        //ALAsset 转换成 NSURL 存储
        PhotoGroup *group = [self.items objectAtIndex:indexPath.section];
        if (group.photos.count > 0) {
            TFPhoto *photo = [group.photos objectAtIndex:(!indexPath.section?(indexPath.row - 1):indexPath.row)];
            if (!_selectedAssets) {
                _selectedAssets = [NSMutableArray array];
            }
            if (!_removeAssets) {
                _removeAssets = [NSMutableArray array];
            }
            if (self.allowsMultipleSelection) {
                //多选
                [_selectedAssets addObject:photo.thumbnail];
                [_removeAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isEqual:photo.thumbnail]) {
                        [_removeAssets removeObject:obj];
                    }
                }];
            } else {
                if ( _allowsImageCrop) {
                    [[DBLibraryManager sharedInstance] fixAssetForURL:photo.thumbnail
                                                          resultBlock:^(ALAsset *asset)
                     {
                         [self cropImageByALAsset:asset];
                     } failureBlock:^(NSError *error) {
                         
                     }];
                } else {
                    if ([_libraryControllerDelegate respondsToSelector:@selector(didSelectAssets:removeList:infos:)]) {
                        [[DBLibraryManager sharedInstance] fixAssetForURL:photo.thumbnail
                                                              resultBlock:^(ALAsset *asset)
                         {
                             [_libraryControllerDelegate didSelectAssets:@[asset] removeList:nil infos:_photoBrowser.tagInfos];
                         } failureBlock:^(NSError *error) {
                             
                         }];
                    }
                }
            }
            [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
                          forState:UIControlStateNormal];
        }
    }
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    PhotoGroup *group = [self.items objectAtIndex:indexPath.section];
    if (group.photos.count > 0) {
        TFPhoto *photo = [group.photos objectAtIndex:(!indexPath.section?(indexPath.row - 1):indexPath.row)];
        if ([_selectedAssets containsObject:photo.thumbnail]) {
            [_selectedAssets removeObject:photo.thumbnail];
        }
        if (!_removeAssets) {
            _removeAssets = [NSMutableArray array];
        }
        [_removeAssets addObject:photo.thumbnail];
        [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
                      forState:UIControlStateNormal];
    }
}

- (BOOL)hasContainUrl:(NSURL*)url {
    NSString *tourl_str = [NSString stringWithFormat:@"%@",url];
    BOOL has = NO;
    for (NSURL *imgUrl in _selectedAssets) {
        NSString *url_str = [NSString stringWithFormat:@"%@",imgUrl];
        if ([url_str isEqualToString:tourl_str]) {
            has = YES;
            break;
        }
    }
    return has;
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) blockSelf = self;

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[[DBLibraryManager sharedInstance] defaultAssetsLibrary] saveImage:image
                                                                toAlbum:NSLocalizedString(@"时光流影", nil)
                                                    withCompletionBlock:^(id assetURL, NSError *error)
    {
        if ([assetURL isKindOfClass:[NSURL class]]) {
            [blockSelf singleImageDidSelected:assetURL];
        }
        if ([assetURL isKindOfClass:[ALAsset class]]) {
            [blockSelf singleImageDidSelected:[[assetURL defaultRepresentation] url]];
        }
    }];
}

/**
 *  拍照后照片处理
 *
 *  @param asset
 */
- (void)singleImageDidSelected:(NSURL *)URL {
    __weak typeof(self) blockSelf = self;
    if (blockSelf.allowsMultipleSelection) {
        //多选
        [blockSelf.selectedAssets addObject:URL];
        if ([blockSelf.removeAssets containsObject:URL]) {
            [blockSelf.removeAssets removeObject:URL];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            TFPhoto *photo = [TFPhoto alloc];
            photo.thumbnail = URL;
            photo.datetime = [NSDate date];
            photo.date = [[Utility sharedUtility] stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
            [self.photos insertObject:photo atIndex:0];
            [self photosGroup:self.photos];

            [blockSelf.navigationController dismissViewControllerAnimated:YES
                                                               completion:^
             {
                 [blockSelf.collectionView reloadData];
                 [blockSelf.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1
                                                                                     inSection:0]
                                                        animated:YES
                                                  scrollPosition:UICollectionViewScrollPositionNone];
             }];
        });
        
        [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),
                                [blockSelf.selectedAssets count],_maximumNumberOfSelection]
                      forState:UIControlStateNormal];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:NULL];
        if ( _allowsImageCrop) {
            [[DBLibraryManager sharedInstance] fixAssetForURL:URL
                                                                      resultBlock:^(ALAsset *asset)
             {
                 [blockSelf cropImageByALAsset:asset];
                 
             } failureBlock:^(NSError *error) {
             }];
        }
        else {
            if ([blockSelf.libraryControllerDelegate respondsToSelector:@selector(didSelectAssets:removeList:infos:)])
            {
                [[DBLibraryManager sharedInstance] fixAssetForURL:URL
                                                                          resultBlock:^(ALAsset *asset)
                 {
                     [blockSelf.libraryControllerDelegate didSelectAssets:@[asset] removeList:nil infos:_photoBrowser.tagInfos];
                 } failureBlock:^(NSError *error) {
                
                 }];
                
            }
        }
    }
    
}

- (void)cropImageByALAsset:(ALAsset *)asset {
    //使用图片剪裁功能
    __weak typeof(self) blockSelf = self;
    UIImage *previewImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    UIImage *sourceImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
    
//    [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]
//                        scale:[asset.defaultRepresentation scale]
//                  orientation:(UIImageOrientation)[asset.defaultRepresentation orientation]]
    
    
    
    //裁图控件
    if (!_editorViewController) {
        _editorViewController = [[TFImageCropViewController alloc] init];
        _editorViewController.checkBounds = YES;
        _editorViewController.rotateEnabled = YES;
        if ([self.libraryControllerDelegate respondsToSelector:@selector(sizeOfImageCrop)]) {
            CGSize size = [self.libraryControllerDelegate sizeOfImageCrop];
            [_editorViewController setCropSize:size];
        }
        _editorViewController.minimumScale = 0.2;
        _editorViewController.maximumScale = 10;
    }
    _editorViewController.sourceImage = sourceImage;
    _editorViewController.previewImage = previewImage;
    [_editorViewController reset:NO];

    
    _editorViewController.doneCallback = ^(UIImage *image ,BOOL canceled) {
        if ([blockSelf.libraryControllerDelegate respondsToSelector:@selector(didSelectImage:)]) {
            [blockSelf.libraryControllerDelegate didSelectImage:image];
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:_editorViewController
                                                animated:YES
                                              completion:^{
                                                  if ([self.libraryControllerDelegate respondsToSelector:@selector(sizeOfImageCrop)])
                                                  {
                                                      CGSize size = [self.libraryControllerDelegate sizeOfImageCrop];
                                                      [_editorViewController setCropSize:size];
                                                  }
                                                  [_editorViewController reset:YES];
                                              }];
    });
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    TFLog(@"%s contextInfo:%@",__func__,contextInfo);
}

#pragma mark - TFLibraryGroupDelegate
- (void)didSelectedLibraryGroup:(ALAssetsGroup *)group {
    [self dismissViewControllerAnimated:YES completion:nil];
    _currentGroup = group;
    [self loadGroupsAsset:group];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark - TFPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(TFPhotoBrowser *)photoBrowser {
    return [_selectedAssets count];
}

- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    TFPhoto *photo = [TFPhoto photoWithURL:[_selectedAssets objectAtIndex:index]];
    return photo;
}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser deletePhotoAtIndex:(NSUInteger)index {
    [_selectedAssets removeObjectAtIndex:index];
    [_collectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:YES];
    [_collectionView reloadData];
    
    [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
                  forState:UIControlStateNormal];
    
}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index updateURL:(NSURL *)newURL {
    
    [_selectedAssets replaceObjectAtIndex:index withObject:newURL];
    [_collectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:YES];
    
    TFPhoto *photo = [TFPhoto alloc];
    photo.thumbnail = newURL;
    photo.datetime = [NSDate date];
    photo.date = [[Utility sharedUtility] stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
    [self.photos insertObject:photo atIndex:0];
    [self photosGroup:self.photos];

    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                           animated:YES
                                     scrollPosition:UICollectionViewScrollPositionNone];
    [_collectionView reloadData];
}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didFinishSavingWithError:(NSError *)error {
    if (error) {
        return;
    }
    [self librarayDidSelected:nil];
}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser updateTagInfo:(NSDictionary *)info index:(NSUInteger)index {
    TFLog(@"INFO:%@",info);
}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser infos:(NSMutableArray *)infos {
    _infos = infos;
    
}

- (void)nextAction {
    [self librarayDidSelected:nil];
        
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
