//
//  GuideHelpView.h
//  TimeFaceV2
//
//  Created by 吴寿 on 15/4/20.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMHoledView.h"
#import "ViewGuideModel.h"

@interface GuideHelpView : UIView<JMHoledViewDelegate>

@property (nonatomic ,strong           ) JMHoledView *holedView;
@property (nonatomic ,strong           ) ViewGuideModel *guideModel;
@property (nonatomic ,strong           ) UIViewController *viewController;

-(void) refreshGuide:(ViewGuideModel *)model inview:(id)sender;

@end
