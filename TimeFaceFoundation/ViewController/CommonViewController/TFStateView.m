//
//  TFStateView.m
//  TimeFaceV2
//
//  Created by Melvin on 1/13/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFStateView.h"
#import <objc/runtime.h>
#import "TFDefaultStyle.h"
#import "TimeFaceFoundationConst.h"

@interface StateView () {
    
}

/**
 *  主体
 */
@property (nonatomic ,strong ,readwrite) UIView      *contentView;
/**
 *  标题
 */
@property (nonatomic ,strong ,readwrite) UILabel     *titleLabel;
/**
 *  详细内容
 */
@property (nonatomic ,strong ,readwrite) UILabel     *detailLabel;
/**
 *  图片
 */
@property (nonatomic ,strong ,readwrite) FLAnimatedImageView *imageView;
/**
 *  按钮
 */
@property (nonatomic ,strong ,readwrite) UIButton    *button;

@end

@implementation StateView

- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.frame = self.superview.bounds;
    
    [UIView animateWithDuration:0.25
                     animations:^{_contentView.alpha = 1.0;}
                     completion:NULL];
}
#pragma mark StateView Getters
- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (FLAnimatedImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [FLAnimatedImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:27.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 2;
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:17.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor whiteColor];
        _button.titleLabel.textColor = TFSTYLEVAR(loadingTextColor);
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = TFSTYLEVAR(loadingLineColor).CGColor;
        _button.tfSize = CGSizeMake(236/2, 30);
        _button.layer.cornerRadius = _button.tfHeight / 2;
        _button.layer.masksToBounds = YES;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage {
    return ((_imageView.animationImages || _imageView.image) && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
    return ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 && _button.superview);
}


#pragma mark - Setters

- (void)setCustomView:(UIView *)view
{
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    if (!view) {
        return;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = !CGRectIsEmpty(view.frame);
    
    [_contentView addSubview:_customView];
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"state_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllSubviews
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
}


#pragma mark - UIView Constraints & Layout Methods

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    // Cleans up any constraints
    [self removeAllConstraints];
    
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    [views setObject:self forKey:@"self"];
    [views setObject:self.contentView forKey:@"contentView"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self]-(<=0)-[contentView]"
                                                                 options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-(<=0)-[contentView]"
                                                                 options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    // If a custom offset is available, we modify the contentView's constraints constants
    if (!CGPointEqualToPoint(self.offset, CGPointZero) && self.constraints.count == 4) {
        NSLayoutConstraint *vConstraint = self.constraints[1];
        NSLayoutConstraint *hConstraint = [self.constraints lastObject];
        
        // the values must be inverted to follow the up-bottom and left-right directions
        vConstraint.constant = self.offset.y*-1;
        hConstraint.constant = self.offset.x*-1;
    }
    
    if (_customView) {
        [views setObject:_customView forKey:@"customView"];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:views]];
        
        // Skips from any further configuration
        return [super updateConstraints];;
    }
    
    CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
    NSNumber *padding =  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @20 : @(roundf(width/16.0));
    
    NSNumber *imgWidth = @(roundf(_imageView.image.size.width));
    NSNumber *imgHeight = @(roundf(_imageView.image.size.height));
    if (_imageView.animatedImage) {
        //gif
        imgWidth = @(roundf(_imageView.animatedImage.size.width/2));
        imgHeight = @(roundf(_imageView.animatedImage.size.height/2));
    }
    if (_imageView.animationImages) {
        //png array
        imgWidth = @(roundf(_imageView.animationImages[0].size.width));
        imgHeight = @(roundf(_imageView.animationImages[0].size.height));
    }
    NSNumber *trailing = @(roundf((width-[imgWidth floatValue])/2.0));
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding,trailing,imgWidth,imgHeight);
    
    // Since any element could be missing from displaying, we need to create a dynamic string format
    NSMutableString *verticalFormat = [NSMutableString new];
    NSMutableArray *verticalSubviews = [NSMutableArray new];
    
    // Assign the image view's horizontal constraints
    if ([self canShowImage]) {
        [views setObject:_imageView forKey:@"imageView"];
        [verticalSubviews addObject:@"[imageView(imgHeight)]"];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-trailing-[imageView(imgWidth)]-trailing-|"
                                                                                 options:0 metrics:metrics views:views]];
    }
    
    // Assign the title label's horizontal constraints
    if ([self canShowTitle]) {
        [views setObject:_titleLabel forKey:@"titleLabel"];
        [verticalSubviews addObject:@"[titleLabel]"];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|"
                                                                                 options:0 metrics:metrics views:views]];
    }
    // or removes from its superview
    else {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    
    // Assign the detail label's horizontal constraints
    if ([self canShowDetail]) {
        [views setObject:_detailLabel forKey:@"detailLabel"];
        [verticalSubviews addObject:@"[detailLabel]"];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[detailLabel]-padding-|"
                                                                                 options:0 metrics:metrics views:views]];
    }
    // or removes from its superview
    else {
        [_detailLabel removeFromSuperview];
        _detailLabel = nil;
    }
    
    // Assign the button's horizontal constraints
    if (_button.superview && [self canShowButton]) {
        [views setObject:_button forKey:@"button"];
        [verticalSubviews addObject:@"[button]"];
        padding = @100;
        metrics = NSDictionaryOfVariableBindings(padding,trailing,imgWidth,imgHeight);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button]-padding-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
    }
    // or removes from its superview
    else {
        [_button removeFromSuperview];
        _button = nil;
    }
    
    
    // Build the string format for the vertical constraints, adding a margin between each element. Default is 11.
    [verticalSubviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // Adds the subview
        [verticalFormat appendString:obj];
        
        // Adds the margin
        if (idx < verticalSubviews.count-1) {
            if (self.verticalSpace > 0) [verticalFormat appendFormat:@"-%.f-", self.verticalSpace];
            else [verticalFormat appendString:@"-11-"];
        }
    }];
    
    // Assign the vertical constraints to the content view
    if (verticalFormat.length > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                 options:0 metrics:metrics views:views]];
    }
    
    [super updateConstraints];
}

@end



#pragma mark - TFStateView

static char const * const kStateViewSource      = "stateViewSource";
static char const * const kStateViewDelegate    = "stateViewDelegate";
static char const * const kStateView            = "stateView";


@interface TFStateView()<UIGestureRecognizerDelegate> {
    
}
@property (nonatomic, readonly) StateView *stateView;

@end

@implementation TFStateView

- (id<ViewStateDataSource>)stateDataSource
{
    return objc_getAssociatedObject(self, kStateViewSource);
}

- (id<ViewStateDelegate>)stateDelegate
{
    return objc_getAssociatedObject(self, kStateViewDelegate);
}

- (BOOL)isStateVisible
{
    UIView *view = objc_getAssociatedObject(self, kStateView);
    return view ? !view.hidden : NO;
}


#pragma mark - Getters (Private)

- (StateView *)stateView
{
    StateView *view = objc_getAssociatedObject(self, kStateView);
    
    if (!view)
    {
        view = [StateView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.userInteractionEnabled = YES;
        view.hidden = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(state_didTapContentView:)];
        gesture.delegate = self;
        [view addGestureRecognizer:gesture];
        
        [self setStateView:view];
    }
    return view;
}


#pragma mark - Data Source Getters

- (NSAttributedString *)state_titleLabelText
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(titleForStateView:)]) {
        NSAttributedString *string = [self.stateDataSource titleForStateView:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object -titleForEmptyDataSet:");
        return string;
    }
    return nil;
}

- (NSAttributedString *)state_detailLabelText
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(descriptionForStateView:)]) {
        NSAttributedString *string = [self.stateDataSource descriptionForStateView:self];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object -descriptionForEmptyDataSet:");
        return string;
    }
    return nil;
}

- (UIImage *)state_image
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(imageForStateView:)]) {
        UIImage *image = [self.stateDataSource imageForStateView:self];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -imageForEmptyDataSet:");
        return image;
    }
    return nil;
}

- (FLAnimatedImage *)state_animationImage {
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(animationImageForStateView:)]) {
        FLAnimatedImage *image = [self.stateDataSource animationImageForStateView:self];
        if (image) NSAssert([image isKindOfClass:[FLAnimatedImage class]], @"必须是FLAnimatedImage GIF图片");
        return image;
    }
    return nil;
}

- (NSArray *)state_images {
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(imagesForStateView:)]) {
        NSArray *images = [self.stateDataSource imagesForStateView:self];
        return images;
    }
    return nil;
}

- (NSAttributedString *)state_buttonTitleForState:(UIControlState)state
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(buttonTitleForStateView:forState:)]) {
        NSAttributedString *string = [self.stateDataSource buttonTitleForStateView:self forState:state];
        if (string) NSAssert([string isKindOfClass:[NSAttributedString class]], @"You must return a valid NSAttributedString object for -buttonTitleForEmptyDataSet:forState:");
        return string;
    }
    return nil;
}

- (UIImage *)state_buttonBackgroundImageForState:(UIControlState)state
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(buttonBackgroundImageForStateView:forState:)]) {
        UIImage *image = [self.stateDataSource buttonBackgroundImageForStateView:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonBackgroundImageForEmptyDataSet:forState:");
        return image;
    }
    return nil;
}

- (UIColor *)state_dataSetBackgroundColor
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(backgroundColorForStateView:)]) {
        UIColor *color = [self.stateDataSource backgroundColorForStateView:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object -backgroundColorForEmptyDataSet:");
        return color;
    }
    return [UIColor clearColor];
}

- (UIView *)state_customView
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(customViewForStateView:)]) {
        UIView *view = [self.stateDataSource customViewForStateView:self];
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -customViewForEmptyDataSet:");
        return view;
    }
    return nil;
}

- (CGPoint)state_offset
{
    CGPoint offset = CGPointZero;
    
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(offsetForStateView:)]) {
        offset = [self.stateDataSource offsetForStateView:self];
    }
    return offset;
}

- (CGRect)state_frame
{
    CGRect frame = self.superview.bounds;
    
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(frameForStateView:)]) {
        frame = [self.stateDataSource frameForStateView:self];
    }
    return frame;
}

- (CGFloat)state_verticalSpace
{
    if (self.stateDataSource && [self.stateDataSource respondsToSelector:@selector(spaceHeightForStateView:)]) {
        return [self.stateDataSource spaceHeightForStateView:self];
    }
    return 0.0;
}


#pragma mark - Delegate Getters & Events (Private)

- (BOOL)state_shouldDisplay
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewShouldDisplay:)]) {
        return [self.stateDelegate stateViewShouldDisplay:self];
    }
    return YES;
}

- (BOOL)state_isTouchAllowed
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewShouldAllowTouch:)]) {
        return [self.stateDelegate stateViewShouldAllowTouch:self];
    }
    return YES;
}


- (void)state_willWillAppear
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewWillAppear:)]) {
        [self.stateDelegate stateViewWillAppear:self];
    }
}

- (void)state_willDisappear
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewWillDisappear:)]) {
        [self.stateDelegate stateViewWillDisappear:self];
    }
}

- (void)state_didTapContentView:(id)sender
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewDidTapView:)]) {
        [self.stateDelegate stateViewDidTapView:self];
    }
}

- (void)state_didTapDataButton:(id)sender
{
    if (self.stateDelegate && [self.stateDelegate respondsToSelector:@selector(stateViewDidTapButton:)]) {
        [self.stateDelegate stateViewDidTapButton:self];
    }
}


#pragma mark - Setters (Public)

- (void)setStateDataSource:(id<ViewStateDataSource>)stateDataSource
{
    // Registers for device orientation changes
    //    if (stateDataSource && !self.stateDataSource) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidChangeOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //    }
    //    else if (!stateDataSource && self.stateDataSource) {
    //        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    //    }
    
    objc_setAssociatedObject(self, kStateViewSource, stateDataSource, OBJC_ASSOCIATION_ASSIGN);
    
    
    
    // We add method sizzling for injecting -state_reloadData implementation to the native -reloadData implementation
    [self swizzle:@selector(reloadData)];
    
    
}

- (void)setStateDelegate:(id<ViewStateDelegate>)stateDelegate
{
    objc_setAssociatedObject(self, kStateViewDelegate, stateDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    if (!stateDelegate) {
        [self state_invalidate];
    }
}


#pragma mark - Setters (Private)
- (void)setStateView:(StateView *)stateView {
    objc_setAssociatedObject(self, kStateView, stateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Reload APIs (Public)


/**
 *  显示 StateView
 */
- (void)showStateView {
    [self state_reloadStateView];
    
}
/**
 *  移除 StateView
 */
- (void)removeStateView {
    [self state_invalidate];
}




#pragma mark - Reload APIs (Private)

- (void)state_reloadStateView {
    // Notifies that the empty dataset view will appear
    [self state_willWillAppear];
    
    StateView *view = self.stateView;
    
    UIView *customView = [self state_customView];
    
    if (!view.superview) {
        [self addSubview:view];
    }
    
    // Moves all its subviews
    [view removeAllSubviews];
    
    // If a non-nil custom view is available, let's configure it instead
    if (customView) {
        view.customView = customView;
    }
    else {
        // Configure labels
        view.detailLabel.attributedText = [self state_detailLabelText];
        view.titleLabel.attributedText = [self state_titleLabelText];
        
        // Configure imageview
        if ([self state_image]) {
            view.imageView.image = [self state_image];
        }
        //GIF
        if ([self state_animationImage]) {
            view.imageView.animatedImage = [self state_animationImage];
        }
        //images
        if ([self state_images]) {
            view.imageView.animationImages = [self state_images];
            view.imageView.animationDuration = (CGFloat)[self state_images].count/12.0;
            [view.imageView startAnimating];
        }
        
        // Configure button
        [view.button setAttributedTitle:[self state_buttonTitleForState:0] forState:0];
        [view.button setAttributedTitle:[self state_buttonTitleForState:1] forState:1];
        [view.button setBackgroundImage:[self state_buttonBackgroundImageForState:0] forState:0];
        [view.button setBackgroundImage:[self state_buttonBackgroundImageForState:1] forState:1];
        [view.button setUserInteractionEnabled:[self state_isTouchAllowed]];
        
        // Configure spacing
        view.verticalSpace = [self state_verticalSpace];
    }
    
    // Configure Offset
    view.offset = [self state_offset];
    // Configure frame
    self.frame = [self state_frame];
    view.frame = self.frame;
    view.tfTop = 0;
//    self.tfTop += 30.0f;
    
    // Configure the empty dataset view
    view.backgroundColor = [self state_dataSetBackgroundColor];
    view.hidden = NO;
    
    [view updateConstraints];
    [view layoutIfNeeded];
    
}

- (void)state_invalidate
{
    // Notifies that the empty dataset view will disappear
    [self state_willDisappear];
    
    if (self.stateView) {
        [self.stateView removeAllSubviews];
        [self.stateView removeFromSuperview];
        
        [self setStateView:nil];
    }
}



#pragma mark - Notification Events

- (void)deviceDidChangeOrientation:(NSNotification *)notification
{
    if (self.isStateVisible) {
        [self.stateView updateConstraints];
        [self.stateView layoutIfNeeded];
    }
}


#pragma mark - Method Swizzling

static NSMutableDictionary *_impLookupTable;
static NSString *const DZNSwizzleInfoPointerKey = @"pointer";
static NSString *const DZNSwizzleInfoOwnerKey = @"owner";
static NSString *const DZNSwizzleInfoSelectorKey = @"selector";

// Based on Bryce Buchanan's swizzling technique http://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
// And Juzzin's ideas https://github.com/juzzin/JUSEmptyViewController

void state_original_implementation(id self, SEL _cmd)
{
    // Fetch original implementation from lookup table
    NSString *key = state_implementationKey(self, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:DZNSwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // We then inject the additional implementation for reloading the empty dataset
    // Doing it before calling the original implementation does update the 'isEmptyDataSetVisible' flag on time.
    [self state_reloadStateView];
    
    // If found, call original implementation
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}

NSString *state_implementationKey(id target, SEL selector)
{
    if (!target || !selector) {
        return nil;
    }
    
    Class baseClass;
    if ([target isKindOfClass:[UITableView class]]) baseClass = [UITableView class];
    else if ([target isKindOfClass:[UICollectionView class]]) baseClass = [UICollectionView class];
    else return nil;
    
    NSString *className = NSStringFromClass([baseClass class]);
    
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}


- (void)swizzle:(SEL)selector
{
    // Check if the target responds to selector
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    // Create the lookup table
    if (!_impLookupTable) {
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    
    // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:DZNSwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:DZNSwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    NSString *key = state_implementationKey(self, selector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:DZNSwizzleInfoPointerKey];
    
    // If the implementation for this class already exist, skip!!
    if (impValue) {
        return;
    }
    
    // Swizzle by injecting additional implementation
    Method method = class_getInstanceMethod([self class], selector);
    IMP state_newImplementation = method_setImplementation(method, (IMP)state_original_implementation);
    
    // Store the new implementation in the lookup table
    NSDictionary *swizzledInfo = @{DZNSwizzleInfoOwnerKey: [self class],
                                   DZNSwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   DZNSwizzleInfoPointerKey: [NSValue valueWithPointer:state_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.stateView]) {
        return [self state_isTouchAllowed];
    }
    return YES;
    //    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
