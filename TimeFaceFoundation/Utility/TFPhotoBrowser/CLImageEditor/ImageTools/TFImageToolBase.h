//
//  TFImageToolBase.h
//  TimeFaceV2
//
//  Created by Melvin on 2/5/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFPhotoBrowser.h"
#import "CLImageToolSettings.h"
#import "DBLibraryManager.h"
//#import "UIImage+fixOrientation.h"


static const CGFloat kCLImageToolAnimationDuration = 0.3;
static const CGFloat kCLImageToolFadeoutDuration   = 0.2;

@interface TFImageToolBase : NSObject<CLImageToolProtocol>

@property (nonatomic, weak) TFPhotoBrowser *editor;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;

- (id)initWithImageEditor:(UIViewController *)editor withToolInfo:(CLImageToolInfo*)info;
- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;
- (void)executeOriginalImage:(NSURL *)URL completionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock;

- (BOOL)handleSingleTap;

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName;

@end
