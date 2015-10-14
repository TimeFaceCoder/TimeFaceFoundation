// TFTabBar.m
// TFTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TFTabBar.h"
#import "TFTabBarItem.h"

#import "TimePostButtonView.h"

const static CGFloat kPadding = 22.0f;
const static CGFloat kActionWidth = 50.0f;

@interface TFTabBar ()

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) UIImageView       *backgroundView;
/**
 *  tabbar item 容器
 */
@property (nonatomic) UIView            *itemContainerView;
/**
 *  工具条操作按钮
 */
@property (nonatomic) UIButton          *postActionView;

//@property (nonatomic) TimePostButtonView    *postActionView;

@end

@implementation TFTabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.image = [[UIImage imageNamed:@"TabBarBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:49];
    [self insertSubview:_backgroundView atIndex:0];

    
    _itemContainerView = [[UIView alloc] init];
    [_itemContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
     UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|
     UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
//    _itemContainerView.layer.borderWidth = 1;
//    _itemContainerView.layer.borderColor = [[UIColor redColor] CGColor];
    [self addSubview:_itemContainerView];
    
    
    _postActionView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_postActionView setImage:[UIImage imageNamed:@"TabBarPost"] forState:UIControlStateNormal];
    [_postActionView setImage:[UIImage imageNamed:@"TabBarPostSelected"] forState:UIControlStateSelected|UIControlStateHighlighted];

    [_postActionView addTarget:self action:@selector(onViewClick:)
             forControlEvents:UIControlEventTouchUpInside];
    [_postActionView sizeToFit];
    
    [self addSubview:_postActionView];
    
//    _postActionView = [[TimePostButtonView alloc] initWithFrame:CGRectMake(0, 0, kActionWidth, kActionWidth)];
//    [self addSubview:_postActionView];
    
    [self setTranslucent:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];

    [_itemContainerView setFrame:CGRectMake(kPadding, 0, frameSize.width - kPadding*3 - kActionWidth, frameSize.height)];
    CGSize containerSize = _itemContainerView.tfSize;

    TFLog(@"containerSize:%@",NSStringFromCGSize(containerSize));
    
    [_postActionView setFrame:CGRectMake(_itemContainerView.tfRight + kPadding,  (frameSize.height - _postActionView.tfHeight), _postActionView.tfWidth, _postActionView.tfHeight)];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                            frameSize.width, frameSize.height)];
    
    [self setItemWidth:roundf((containerSize.width - [self contentEdgeInsets].left -
                               [self contentEdgeInsets].right) / [[self items] count])];
    
    NSInteger index = 0;
    
    // Layout items
    
    for (TFTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        [item setNeedsDisplay];
        
        index++;
    }
}

#pragma mark - Configuration

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (TFTabBarItem *item in items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    NSInteger index = 0;;
    for (TFTabBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:)
       forControlEvents:UIControlEventTouchUpInside];
        [_itemContainerView addSubview:item];
        index ++;
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (TFTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(TFTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

- (void)onViewClick:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(onViewClick:)]) {
        [[self delegate] onViewClick:sender];
    }
}

#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    
}

@end
