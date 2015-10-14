//
//  LibraryCollectionHeaderView.h
//  TimeFaceV2
//
//  Created by 吴寿 on 15/6/1.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *lblTitle;

-(void) refreshTitle:(NSString *)title;

@end
