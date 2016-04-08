//
//  GuideHelpView.h
//  TimeFaceV2
//
//  Created by 吴寿 on 15/4/20.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMHoledView.h"

@class ViewGuideModel;

@protocol GuideHelpViewDelegate <NSObject>

@optional

- (void)holedView:(JMHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index;

@end

@interface GuideHelpView : UIView

@property (nonatomic, weak) id<GuideHelpViewDelegate> delegate;
@property (nonatomic, assign) NSInteger holeIndex;

-(void) refreshGuide:(ViewGuideModel *)model inview:(id)sender;

@end
