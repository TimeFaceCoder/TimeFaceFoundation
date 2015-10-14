//
//  TFImageEditorViewController.h
//  TimeFaceV2
//
//  Created by Melvin on 1/28/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TFImageEditorViewControllerDelegate;

@interface TFImageEditorViewController : UIViewController

@property (nonatomic, weak) id<TFImageEditorViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIScrollView   *menuView;
@property (nonatomic, weak) IBOutlet UIScrollView   *toolView;
@property (nonatomic, strong) UIImageView           *imageView;
@property (nonatomic, readonly) UIScrollView        *scrollView;


- (id)initWithImage:(UIImage*)image delegate:(id<TFImageEditorViewControllerDelegate>)delegate;
- (id)initWithURL:(NSURL*)url delegate:(id<TFImageEditorViewControllerDelegate>)delegate;

@end

@protocol TFImageEditorViewControllerDelegate <NSObject>
@optional
- (void)imageEditor:(TFImageEditorViewController*)editor didFinishEdittingWithImage:(UIImage*)image;
- (void)imageEditor:(TFImageEditorViewController*)editor didFinishEdittingWithURL:(NSURL*)URL;
- (void)imageEditorDidCancel:(TFImageEditorViewController*)editor;

@end
