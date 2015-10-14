//
//  TFPhotoTagView.h
//  TimeFaceV2
//
//  Created by Melvin on 3/25/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPhotoTagViewDataSource <NSObject>
- (CGPoint)normalizedPosition;

@optional
- (NSAttributedString *)attributedTagText;
- (NSString *)tagText;
- (NSDictionary *)metaInfo;


@end

@class TFPhotoTagView;
@protocol TFPhotoTagViewDelegate <NSObject>

- (void)tagDidAppear:(TFPhotoTagView *)tagPopover;
- (void)tagPopoverDidEndEditing:(TFPhotoTagView *)tagPopover;
- (void)tagPopover:(TFPhotoTagView *)tagPopover didReceiveSingleTap:(UITapGestureRecognizer *)singleTap;
- (void)tagPopover:(TFPhotoTagView *)tagPopover didReceiveLongTap:(UITapGestureRecognizer *)longTap;


@end

typedef void(^TFPhotoTagViewVDisplayCallback)(TFPhotoTagView *tagView);


@interface TFPhotoTagView : UIView<UITextFieldDelegate>

@property (nonatomic,copy    ) TFPhotoTagViewVDisplayCallback   doneCallback;
@property (nonatomic, strong ) id <TFPhotoTagViewDataSource>    dataSource;
@property (nonatomic, weak   ) id <TFPhotoTagViewDelegate>      delegate;
@property (nonatomic, assign ) CGPoint                          normalizedArrowPoint;
@property (nonatomic, assign ) CGPoint                          tagLocation;
@property (nonatomic, assign ) CGPoint                          pointOnImage;
@property (nonatomic, assign ) CGSize                           sizeOnImage;
@property (nonatomic, assign ) CGPoint                          normalizedArrowOffset;
@property (nonatomic, assign ) CGSize                           minimumTextFieldSize;
@property (nonatomic, assign ) CGSize                           minimumTextFieldSizeWhileEditing;
@property (nonatomic, assign ) NSInteger                        maximumTextLength;

- (id)initWithDelegate:(id<TFPhotoTagViewDelegate>)delegate;
- (id)initWithTag:(id<TFPhotoTagViewDataSource>)aTag;

- (NSString *)text;
- (void)setText:(NSString *)text;

- (void)startEdit;

- (void)presentPopoverFromPoint:(CGPoint)point
                         inView:(UIView *)view
                       animated:(BOOL)animated;

- (void)presentPopoverFromPoint:(CGPoint)point
                         inView:(UIView *)view
       permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                       animated:(BOOL)animated;

- (void)presentPopoverFromPoint:(CGPoint)point
                         inRect:(CGRect)rect
                         inView:(UIView *)view
       permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                       animated:(BOOL)animated;

- (void)repositionInRect:(CGRect)rect;

@end
