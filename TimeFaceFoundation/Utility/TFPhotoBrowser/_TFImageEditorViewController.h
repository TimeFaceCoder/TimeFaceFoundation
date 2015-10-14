//
//  _TFImageEditorViewController.h
//  TimeFaceV2
//
//  Created by Melvin on 3/13/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "CLImageEditor.h"
#import "TFPhoto.h"

@class _TFImageEditorViewController;

@protocol _TFImageEditorViewControllerDelete <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(_TFImageEditorViewController *)photoBrowser;
- (id <TFPhoto>)photoBrowser:(_TFImageEditorViewController *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (id <TFPhoto>)photoBrowser:(_TFImageEditorViewController *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;

- (NSString *)photoBrowser:(_TFImageEditorViewController *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(_TFImageEditorViewController *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(_TFImageEditorViewController *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(_TFImageEditorViewController *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(_TFImageEditorViewController *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(_TFImageEditorViewController *)photoBrowser;
- (void)photoBrowser:(_TFImageEditorViewController *)photoBrowser deletePhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(_TFImageEditorViewController *)photoBrowser photoAtIndex:(NSUInteger)index updateURL:(NSURL *)newURL;

@end


@interface _TFImageEditorViewController : CLImageEditor

@end
