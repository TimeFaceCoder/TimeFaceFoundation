//
//  TFPhotoToolbar.h
//  TimeFaceFoundation
//
//  Created by zguanyu on 9/16/15.
//  Copyright (c) 2015 timeface. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPhotoToolItem;

typedef void(^TFPhotoToolItemBlock)(TFPhotoToolItem *item);

@interface TFPhotoToolItem : NSObject

@property (nonatomic ,strong)   UIImage         *image;
@property (nonatomic, strong)   UIImage         *imageH;
@property (nonatomic ,copy)     NSString        *title;
@property (nonatomic, assign)   BOOL            selected;
@property (nonatomic, assign)   NSInteger       tag;
@property (nonatomic ,weak)     TFPhotoToolItemBlock  block;

+ (instancetype) actionItem:(NSString *)title
                      image:(UIImage *)image
              selectedImage:(UIImage*)imageH
                      state:(BOOL)selected
                        tag:(NSInteger)tag
                      block:(TFPhotoToolItemBlock)block;

@end


typedef NS_ENUM(NSInteger, TFPhotoToolAlignment){
    /**
     *  水平居左
     */
    TFPhotoToolAlignmentLeft   =   1,
    /**
     *  水平居中
     */
    TFPhotoToolAlignmentCenter   =  2,
    /**
     *  水平居右
     */
    TFPhotoToolAlignmentRight    =  3,
};


@interface TFPhotoToolbar : UIView


- (id)initWithItems:(NSArray*)items frame:(CGRect)frame;

- (void)refreshItemTitle:(NSString*)title state:(BOOL)state tag:(NSInteger)tag;

- (void)refreshNull;

@property (nonatomic, strong) UIColor    *toolBgColor;

@property (nonatomic, assign) TFPhotoToolAlignment alignment;





@end
