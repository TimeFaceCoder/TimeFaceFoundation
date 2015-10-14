//
//  TFLibraryGroupCollectionViewCell.h
//  TimeFaceV2
//
//  Created by Melvin on 12/12/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFLibraryGroupCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel       *titleLabel;
@property (nonatomic ,strong) UILabel       *countLabel;
@property (nonatomic ,strong) UIImageView   *lasterImageView;

- (void)updateViews:(UIImage *)image title:(NSString *)title count:(NSInteger)count;


@end
