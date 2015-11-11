//
//  TableViewLoadingItemCell.m
//  TimeFaceFire
//
//  Created by zguanyu on 9/10/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TableViewLoadingItemCell.h"
#import "FLAnimatedImage.h"
#import "TFDefaultStyle.h"
#import "TimeFaceFoundationConst.h"
#import "UIAdditions.h"

@implementation TableViewLoadingItemCell

@dynamic item;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
#pragma mark 列表生命周期
+ (CGFloat)heightWithItem:(NSObject *)item tableViewManager:(RETableViewManager *)tableViewManager {
    //列表高度
    return 60;
}


- (void)cellDidLoad {
    [super cellDidLoad];
    //创建控件
    //    self.loadingImageView = [[FLAnimatedImageView alloc] init];
    //    self.loadingImageView.frame = CGRectMake(10, 0, 60, 60);
    //    [self addSubview:self.loadingImageView];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.loadingView];
    
    self.textLabel.textColor = TFSTYLEVAR(loadingTextColor);
    self.textLabel.font = TFSTYLEVAR(font14);
}
- (void)cellWillAppear {
    [super cellWillAppear];
    //页面元素赋值
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"PullupLoading" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.loadingImageView.animatedImage = image;
    
    [self.loadingView startAnimating];
    
}
- (void)cellDidDisappear {
    [super cellDidDisappear];
    //页面重用准备
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //页面布局调整
    self.loadingImageView.tfSize = CGSizeMake(60, 60);
    self.loadingImageView.center = self.contentView.center;
    
    self.loadingView.center = self.contentView.center;
    
    [self.textLabel sizeToFit];
    self.textLabel.tfCenterY = self.loadingView.tfCenterY;
    CGFloat left = (self.tfWidth - (self.loadingView.tfWidth + self.textLabel.tfWidth) ) / 2;
    self.loadingView.tfLeft = left;
    self.textLabel.tfLeft = self.loadingView.tfRight + 6;
    
}

#pragma mark - Private
- (void)onViewClick:(id)sender {
    
}


@end
