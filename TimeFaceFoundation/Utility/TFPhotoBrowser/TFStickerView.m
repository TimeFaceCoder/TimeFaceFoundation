//
//  TFStickerView.m
//  TimeFaceV2
//
//  Created by Melvin on 3/16/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFStickerView.h"
#import "TFDefaultStyle.h"

#import "TFStickerFlowLayout.h"
#import "TFStickerCollectionViewCell.h"

@interface TFStickerView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
}
@property (nonatomic ,strong) NSMutableArray *stickerData;
@end

static NSString *StickerCollectionViewIdentifier  = @"StickerCollectionViewIdentifier";


@implementation TFStickerView {
    UICollectionView    *_collectionView;
    UIImageView         *_bgImageView;
    UIButton            *_topArrowButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(!_stickerData){
            NSString *path = [self stickerFilePath];
            NSArray *tempArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                     error:nil];
            _stickerData = [NSMutableArray array];
            for (NSString *fileName in tempArray) {
                NSString *imagePath = [[self stickerFilePath] stringByAppendingPathComponent:fileName];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                [_stickerData addObject:@{@"image":image,
                                          @"size":NSStringFromCGSize(image.size),
                                          @"path":imagePath}];
            }
        }

        
        [self configureViews];
    }
    return self;
}


-(NSString *) stickerFilePath{
    return [[NSBundle mainBundle] pathForResource:@"StickerImages" ofType:@"bundle"];
}

- (void)configureViews {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    
    TFStickerFlowLayout *layout = [[TFStickerFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4;
    layout.maxCellSpace = 4;
    layout.singleCellWidth = 70;
    layout.forceCellWidthForMinimumInteritemSpacing = YES;

    
    CGRect frame = self.bounds;
    frame.origin.y = 40;
    frame.size.height = CGRectGetHeight(self.bounds) - 40;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:layout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[TFStickerCollectionViewCell class]
        forCellWithReuseIdentifier:StickerCollectionViewIdentifier];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    [self addSubview:_collectionView];
    
    
    _topArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topArrowButton setImage:[UIImage imageNamed:@"StickerViewClose"] forState:UIControlStateNormal];
    [_topArrowButton setImage:[UIImage imageNamed:@"StickerViewOpen"] forState:UIControlStateSelected];
    [_topArrowButton addTarget:self action:@selector(topArrowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topArrowButton sizeToFit];
    _topArrowButton.tfTop = 5;
    _topArrowButton.tfCenterX = _collectionView.tfCenterX;
    [self addSubview:_topArrowButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _stickerData.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFStickerCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:StickerCollectionViewIdentifier
                                                                                 forIndexPath:indexPath];
    item.imageView.image = [[_stickerData objectAtIndex:indexPath.item] objectForKey:@"image"];
    return item;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_stickerData objectAtIndex:indexPath.item];
    if (dic) {
        return CGSizeFromString([dic objectForKey:@"size"]);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.stickerData objectAtIndex:indexPath.item];
    if (dic) {
        if ([_delegate respondsToSelector:@selector(didStickerSelected:)]) {
            [_delegate didStickerSelected:[dic objectForKey:@"path"]];
        }
    }
}

- (void)topArrowClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(didStickerClose:)]) {
        BOOL close = (self.tfTop >= CGRectGetHeight(TTScreenBounds()) - 40);
        [_delegate didStickerClose:close];
        button.selected = !close;
    }
}

- (void)updateArrowState:(BOOL)selected {
    _topArrowButton.selected = selected;
}


@end
