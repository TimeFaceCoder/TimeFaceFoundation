//
//  TFTableRefreshView2.h
//  TimeFaceV2
//
//  Created by Melvin on 8/12/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTableRefreshView2 : UIView

@property (nonatomic ,strong) UIView  *controlPoint;
@property (nonatomic ,assign) CGFloat controlPointOffset;
@property (nonatomic ,assign) CGFloat yOffset;
@property (nonatomic ,assign) CGRect  userFrame;
@property (nonatomic ,assign) BOOL    isLoading;

@end
