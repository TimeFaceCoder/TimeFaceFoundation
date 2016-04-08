//
//  GuideHelpView.m
//  TimeFaceV2
//
//  Created by 吴寿 on 15/4/20.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import "GuideHelpView.h"
#import "TFDataHelper.h"
#import "JMHoledView.h"
#import "ViewGuideModel.h"
#import "UIAdditions.h"

@interface GuideHelpView()<JMHoledViewDelegate>

@property (nonatomic ,strong) JMHoledView      *holedView;
@property (nonatomic ,strong) ViewGuideModel   *guideModel;
@property (nonatomic ,strong) UIViewController *viewController;

@end

@implementation GuideHelpView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _holeIndex = NSNotFound;
    }
    return self;
}

-(void) refreshGuide:(ViewGuideModel *)model inview:(id)sender {
    _guideModel = model;
    _viewController = sender;
    if (_guideModel.index >= _guideModel.guides.count) {
        [self removeFromSuperview];
        return ;
    }
    [self showGuide:_guideModel index:_guideModel.index];
}

-(void)showGuide:(ViewGuideModel *)guideModel index:(NSInteger)index {
    [self addSubview:self.holedView];
    switch (guideModel.category) {
        case 0:     //手动
            [self doManualHelp:[guideModel.guides objectAtIndex:index]];
            _holeIndex = index;
            break;
        case 1:     //全自动
        
            break;
        case 2:     //混合
        
            break;
        case 3:     //全屏显示单个
        [self doShowAllHelp:guideModel];
            break;
        case 4:   //显示所有
            [self doShowAllGuide:guideModel];
            break;
        
        default:
            break;
    }
}
/**
 *  手动处理
 *
 *  @param guide
 */
-(void) doManualHelp:(GuideModel *)guide {
    UIView *guideView = [_viewController.view viewWithTag:guide.tag];
    if (!guideView) {
        guideView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:guide.tag];
    }

    if (!guideView || guideView.hidden) {
        [self removeFromSuperview];
        return ;
    }
    CGPoint point = [[guideView superview] convertPoint:guideView.center toView:_viewController.view];
    if (point.y >= [UIScreen mainScreen].bounds.size.height) {
        [self removeFromSuperview];
        return ;
    }
    
    CGSize size = [self drawGuidePoint:guide withPoint:point byView:guideView];
    if (guide.point) {
        [self drawGuidePathSummary:guide.show point:point size:size];
    }
    
}

- (void)doShowAllGuide:(ViewGuideModel*)guideModel {
    for (int i = 0; i < guideModel.guides.count; i++) {
        GuideModel *guide = [guideModel.guides objectAtIndex:i];
        [self doManualHelp:guide];
        _guideModel.index++;
        [[TFDataHelper shared] save:_guideModel objId:_guideModel.viewId];
    }
}

/**
 *
 *
 *  @param guideModel
 */
-(void) doShowAllHelp:(ViewGuideModel *)guideModel {
    UIView *guideView = nil;
    UIView *viewHelp = [[UIView alloc] initWithFrame:CGRectZero];
    viewHelp.tfWidth = self.tfWidth;
    CGFloat top = 0;
    for (GuideModel *guide in guideModel.guides) {
        if (!guideView) {
            guideView = [_viewController.view viewWithTag:guide.tag];
        }


        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:guide.show]];
        [viewHelp addSubview:imageView];

        imageView.tfCenterX = viewHelp.tfWidth / 2;
        imageView.tfTop = top;
        
        top += imageView.tfHeight + 12.f;
        
        guideModel.index++;
    }
    viewHelp.tfHeight = top;
    if (!guideView || guideView.hidden) {
        return ;
    }
    CGPoint point = [[guideView superview] convertPoint:guideView.center toView:_viewController.view];
    point.x = self.tfWidth / 2;
    [self.holedView addHCustomView:viewHelp onCenter:point];
}



-(CGSize) drawGuidePoint:(GuideModel *)model withPoint:(CGPoint)point byView:(UIView *)guideView {
    CGSize size = guideView.tfSize;
    switch (model.shape) {
        case 0:    //圆形
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"GuideCircle.%@.png",@(random() % 2 + 1)]];
            UIImageView *imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, guideView.tfWidth + 12.f, guideView.tfHeight + 12.f)];
            imageBack.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
            [self.holedView addHCustomView:imageBack onCenter:point];
            [self.holedView addHoleCircleCenteredOnPosition:point andDiameter:(guideView.tfWidth + 5.f)];
            break;
        }
        case 1:    //矩形
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"GuideRect.%@.png",@(random() % 2 + 1)]];
            UIImageView *imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, guideView.tfWidth + 12.f, guideView.tfHeight + 12.f)];
            imageBack.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
            [self.holedView addHCustomView:imageBack onCenter:point];
            [self.holedView addHoleRoundedRectOnRect:CGRectMake(point.x - (guideView.tfWidth + 5.f)/2,
                                                                point.y - (guideView.tfHeight + 5.f)/2,
                                                                guideView.tfWidth + 5.f,
                                                                guideView.tfHeight + 5.f)
                                    withCornerRadius:5.f];
            break;
        }
        case 2:    //自定义 圆形
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GuideCircle01.png"]];
            [self.holedView addHCustomView:imageView onCenter:point];
            break;
        }
        case 3:    //自定义 矩形
        {
            UIImage *image = [UIImage imageNamed:@"GuideRect01.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                   guideView.tfWidth + 5.f,
                                                                                   guideView.tfHeight + 5.f)];
            imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
            [self.holedView addHCustomView:imageView onCenter:point];
            break;
        }
        default:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.shapeImage]];
            size = imageView.tfSize;
            [self.holedView addHCustomView:imageView onCenter:point];
            break;
        }
    }
    
    
    if (model.remarkImage.length) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:model.remarkImage]];
        CGSize size = [[UIApplication sharedApplication] keyWindow].frame.size;
        CGPoint point = CGPointMake(model.remarkPointX * size.width, model.remarkPointY * size.height);
        [self.holedView addHCustomView:imageView onCenter:point];
    }
    
    return size;
}

-(void) drawGuidePathSummary:(NSString *)image point:(CGPoint)center size:(CGSize)size {
    UIImageView *imageSummary = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    
    CGFloat w = self.holedView.tfWidth/2;
    CGFloat h = self.holedView.tfHeight/2;
    UIImageView *imagePoint = nil;
    CGPoint point = center;
    CGPoint pointTemp = point;
    CGFloat minPadding = 20.f;
    CGPoint pointShow = CGPointMake(w, h);
    
    if (center.x <= w && center.y <= h) {
        imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"GuidePoint.0.1.%@.png",@(1)]]];
        point.y = center.y + size.height/2 + 3.f;
        pointTemp.x = point.x + imagePoint.tfWidth;
        pointTemp.y = point.y + imagePoint.tfHeight;
        
        pointShow.y = pointTemp.y;
        
    } else if (center.x <= w && center.y > h) {
        imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"GuidePoint.1.1.%@.png",@(1)]]];
        point.y = center.y - size.height / 2 - 3.f - imagePoint.tfHeight;
        pointTemp.x = point.x + imagePoint.tfWidth;
        pointTemp.y = point.y;
        
        pointShow.y = pointTemp.y - imageSummary.tfHeight;
    } else if (center.x > w && center.y <= h) {
        imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"GuidePoint.0.0.%@.png",@(1)]]];
        point.x = center.x - imagePoint.tfWidth;
        point.y = center.y + size.height/2 + 3.f;
        pointTemp.x = point.x;
        pointTemp.y = point.y + imagePoint.tfHeight;
        
        pointShow.y = pointTemp.y;
    } else if (center.x > w && center.y > h) {
        imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"GuidePoint.1.0.%@.png",@(1)]]];
        point.x = center.x - imagePoint.tfWidth;
        point.y = center.y - size.height / 2 - 3.f - imagePoint.tfHeight;
        pointTemp = point;
        
        pointShow.y = pointTemp.y - imageSummary.tfHeight;
    }
    if (w > pointTemp.x && (w - imageSummary.tfWidth/2) > pointTemp.x) {
        pointShow.x = minPadding;
    } else if (w < pointTemp.x && (w + imageSummary.tfWidth/2) < pointTemp.x) {
        pointShow.x = w * 2 - minPadding - imageSummary.tfWidth;
    } else {
        pointShow.x = w - imageSummary.tfWidth/2;
    }
    
    [self.holedView addHCustomView:imageSummary onRect:CGRectMake(pointShow.x, pointShow.y, imageSummary.tfWidth, imageSummary.tfHeight)];
    [self.holedView addHCustomView:imagePoint onRect:CGRectMake(point.x, point.y, imagePoint.tfWidth, imagePoint.tfHeight)];
    
    
}

-(JMHoledView *) holedView {
    if(!_holedView) {
        _holedView = [[JMHoledView alloc] initWithFrame:self.frame];
        _holedView.holeViewDelegate = self;
        _holedView.layer.borderWidth = 1;
    }
    return _holedView;
}

- (void)holedView:(JMHoledView *)holedView didSelectHoleAtIndex:(NSUInteger)index {
    [holedView removeHoles];
    [self.holedView removeFromSuperview];
    self.holedView = nil;
    _guideModel.index++;
    [[TFDataHelper shared] save:_guideModel objId:_guideModel.viewId];

    if (_delegate && [_delegate respondsToSelector:@selector(holedView:didSelectHoleAtIndex:)]) {
        if (index == NSNotFound) {
            [_delegate holedView:holedView didSelectHoleAtIndex:_holeIndex];
        }else {
            [_delegate holedView:holedView didSelectHoleAtIndex:_holeIndex];
        }
        
    }
    
    if (_guideModel.index < _guideModel.guides.count) {
        [self showGuide:_guideModel index:_guideModel.index];
    } else {
        [self removeFromSuperview];
    }
}

@end
