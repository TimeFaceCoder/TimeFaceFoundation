//
//  TFPhotoToolbar.m
//  TimeFaceFoundation
//
//  Created by zguanyu on 9/16/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import "TFPhotoToolbar.h"

@implementation TFPhotoToolItem

+(instancetype)actionItem:(NSString *)title
                    image:(UIImage *)image
            selectedImage:(UIImage *)imageH
                    state:(BOOL)selected
                      tag:(NSInteger)tag
                    block:(TFPhotoToolItemBlock)block {
    return [[TFPhotoToolItem alloc]initWithTitle:title
                                           image:image
                                   selectedImage:imageH
                                           state:selected
                                             tag:tag
                                           block:block];
    
}


- (id)initWithTitle:(NSString*)title
              image:(UIImage *)image
      selectedImage:(UIImage*)imageH
              state:(BOOL)selected
                tag:(NSInteger)tag
              block:(TFPhotoToolItemBlock)block {
    NSParameterAssert(title.length || image);
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _imageH = imageH;
        _block = block;
        _tag = tag;
        _selected = selected;
    }
    return self;
}



@end


@interface TFPhotoToolbar ()

@property (nonatomic, copy) NSArray     *itemArray;

@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableArray  *viewArray;


@end


@implementation TFPhotoToolbar

- (id)initWithItems:(NSArray *)items frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _toolBgColor = RGBACOLOR(0, 0, 0, .8f);
        _alignment = TFPhotoToolAlignmentCenter;
        _itemArray = items;
        
        _viewArray = [[NSMutableArray alloc]init];
        _itemDic = [[NSMutableDictionary alloc] init];
        
        for (TFPhotoToolItem  *item  in _itemArray) {
            UIButton *button = [self createToolBtn:item];
            [_viewArray addObject:button];
            [_itemDic setObject:item forKey:[NSString stringWithFormat:@"%@",@(item.tag)]];
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_toolBgColor) {
        self.backgroundColor = _toolBgColor;
    }
    
    CGFloat width = self.tfWidth;
    CGFloat height = self.tfHeight;
    NSInteger count = self.viewArray.count;
    if (_alignment == TFPhotoToolAlignmentCenter) {
        CGFloat unitWidth = width / count;
        for (int i = 0; i < _viewArray.count; i++) {
            UIButton *button = [_viewArray objectAtIndex:i];
            button.tfWidth = unitWidth;
            button.tfHeight = height;
            button.tfLeft = unitWidth * i;
            [self addSubview:button];
            
            if (i > 0 && i < _viewArray.count - 1) {
                UILabel *lable = [self createLine];
                lable.tfLeft = button.tfRight;
                lable.tfCenterY = height / 2;
                [self addSubview:lable];
            }
        }
    }else if(_alignment == TFPhotoToolAlignmentLeft){
        CGFloat leftPadding = 30;
        for (int i = 0; i < _viewArray.count; i++) {
            UIButton *button = [_viewArray objectAtIndex:i];
            [button sizeToFit];
            button.tfLeft = leftPadding + button.tfWidth;
            button.tfCenterY = height / 2;
            [self addSubview:button];
            
            if (i > 0 && i < _viewArray.count - 1) {
                UILabel *lable = [self createLine];
                lable.tfLeft = button.tfRight;
                lable.tfCenterY = height / 2;
                [self addSubview:lable];
            }
        }
    }else if(_alignment == TFPhotoToolAlignmentRight){
        CGFloat rightPadding = 30;
        for (int i = _viewArray.count - 1; i >= 0; i--) {
            UIButton *button = [_viewArray objectAtIndex:i];
            [button sizeToFit];
            button.tfRight = width - rightPadding - (_viewArray.count - 1 - i) * button.tfWidth;
            button.tfCenterY = height / 2;
            
            if (i > 0 && i < _viewArray.count - 1) {
                UILabel *lable = [self createLine];
                lable.tfLeft = button.tfRight;
                lable.tfCenterY = height / 2;
                [self addSubview:lable];
            }
        }
    }
}

- (void)refreshItemTitle:(NSString *)title state:(BOOL)state tag:(NSInteger)tag {
    UIButton *button = (UIButton*)[self viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.selected = state;
    [self layoutIfNeeded];
}

- (void)refreshNull {
    for (UIView *view  in self.subviews) {
        view.hidden = YES;
    }
}

- (UIButton*)createToolBtn:(TFPhotoToolItem*)item {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    button.titleLabel.font = TFSTYLEVAR(font14);
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.imageH forState:UIControlStateSelected];
    [button setTitle:item.title forState:UIControlStateNormal];
    button.tag = item.tag;
    button.selected = item.selected;
    [button setTitleColor:TFSTYLEVAR(defaultWhiteColor) forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 8.0, 0.0, 0.0)];
    
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UILabel*)createLine{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = TFSTYLEVAR(defaultSplitLineColor);
    label.tfWidth = .5f;
    label.tfHeight = self.tfHeight - 16;
    return label;
}

- (void)itemClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag;
    TFPhotoToolItem *item = [_itemDic objectForKey:[NSString stringWithFormat:@"%@",tag]];
    if (item) {
        item.block(item);
    }
    
}




@end
