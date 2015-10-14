//
//  TFImageToolBase.m
//  TimeFaceV2
//
//  Created by Melvin on 2/5/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFImageToolBase.h"

@implementation TFImageToolBase

- (id)initWithImageEditor:(UIViewController *)editor withToolInfo:(CLImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.editor   = (TFPhotoBrowser *)editor;
        self.toolInfo = info;
    }
    return self;
}

+ (NSString*)defaultIconImagePath
{
    CLImageEditorTheme *theme = [CLImageEditorTheme theme];
    return [NSString stringWithFormat:@"%@.bundle/%@/%@/icon.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class]), theme.toolIconColor];
}

+ (CGFloat)defaultDockedNumber
{
    NSArray *tools = @[@"CLStickerTool",
                       @"CLAdjustmentTool",
                       @"CLFilterTool",
                       @"CLRotateTool",
                       @"TFDeleteTool"];
    return [tools indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return nil;
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (void)setup
{
    
}

- (void)cleanup
{
    
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

- (void)executeOriginalImage:(NSURL *)URL completionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock {
    
}

- (void)executeOriginalImage {
    
}

- (UIImage*)imageForKey:(NSString*)key defaultImageName:(NSString*)defaultImageName
{
    NSString *iconName = self.toolInfo.optionalInfo[key];
    
    if(iconName.length>0){
        return [UIImage imageNamed:iconName];
    }
    else{
        return [CLImageEditorTheme imageNamed:[self class] image:defaultImageName];
    }
}

- (BOOL)handleSingleTap {
    return NO;
}


@end
