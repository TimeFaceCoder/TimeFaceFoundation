//
//  CLFilterBase.m
//
//  Created by sho yakushiji on 2013/11/26.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLFilterBase.h"
#import <GPUImage/GPUImage.h>

@implementation CLFilterBase

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return @"CLFilterBase";
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

+ (UIImage*)applyFilter:(UIImage*)image
{
    return image;
}

@end




#pragma mark- Default Filters


@interface CLDefaultEmptyFilter : CLFilterBase {
    
}

@end

@implementation CLDefaultEmptyFilter

+ (NSDictionary*)defaultFilterInfo
{
    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        
        defaultFilterInfo = @{
                              @"CLDefaultEmptyFilter":@{
                                      @"filterName":@"",
                                      @"title":@"原图",
                                      @"dockedNum":@(0.0)
                                      },
                              @"TFFilterLomo":@{
                                      @"filterName":@"lomo",
                                      @"title":@"lomo",
                                      @"dockedNum":@(1.0)
                                      },
                              @"TFFilterFresh":@{
                                      @"filterName":@"小清新",
                                      @"title":@"小清新",
                                      @"dockedNum":@(2.0)
                                      },
                              @"TFFilterRetro":@{
                                      @"filterName":@"怀旧",
                                      @"title":@"怀旧",
                                      @"dockedNum":@(3.0)
                                      },
                              @"TFFilterWarm":@{
                                      @"filterName":@"暖色系",
                                      @"title":@"暖色系",
                                      @"dockedNum":@(4.0)
                                      },
                              @"TFFilterHazy":@{
                                      @"filterName":@"朦胧",
                                      @"title":@"朦胧",
                                      @"dockedNum":@(5.0)
                                      },
                              @"TFFilterDream":@{
                                      @"filterName":@"梦幻",
                                      @"title":@"梦幻",
                                      @"dockedNum":@(6.0)
                                      },
                              @"TFFilterElegant":@{
                                      @"filterName":@"淡雅",
                                      @"title":@"淡雅",
                                      @"dockedNum":@(7.0)
                                      },
                              @"TFFilterFilm":@{
                                      @"filterName":@"胶片",
                                      @"title":@"胶片",
                                      @"dockedNum":@(8.0)
                                      },
                              @"TFFilterSensation":@{
                                      @"filterName":@"迷情",
                                      @"title":@"迷情",
                                      @"dockedNum":@(9.0)
                                      },
                              @"TFFilterYouth":@{
                                      @"filterName":@"青春",
                                      @"title":@"青春",
                                      @"dockedNum":@(10.0)
                                      },
                              };
    }
    return defaultFilterInfo;
}

+ (id)defaultInfoForKey:(NSString*)key
{
    return self.defaultFilterInfo[NSStringFromClass(self)][key];
}

+ (NSString*)filterName
{
    return [self defaultInfoForKey:@"filterName"];
}

#pragma mark- 

+ (NSString*)defaultTitle
{
    return [self defaultInfoForKey:@"title"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return [[self defaultInfoForKey:@"dockedNum"] floatValue];
}

#pragma mark- 

+ (UIImage*)applyFilter:(UIImage *)image
{
    return [self filteredImage:image withFilterName:self.filterName];
}


+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName
{
    if([filterName isEqualToString:@""]){
        return image;
    }
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageToneCurveFilter *stillImageFilter = [[GPUImageToneCurveFilter alloc] initWithACV:filterName];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *resultImage = [stillImageFilter imageFromCurrentFramebufferWithOrientation:[image imageOrientation]];
    return resultImage;
    
}

@end

/**
 *  Lomo
 */
@interface TFFilterLomo : CLDefaultEmptyFilter
@end
@implementation TFFilterLomo
@end
/**
 *  小清新
 */
@interface TFFilterFresh : CLDefaultEmptyFilter
@end
@implementation TFFilterFresh
@end
/**
 *  怀旧
 */
@interface TFFilterRetro : CLDefaultEmptyFilter
@end
@implementation TFFilterRetro
@end
/**
 *  暖色系
 */
@interface TFFilterWarm : CLDefaultEmptyFilter
@end
@implementation TFFilterWarm
@end

/**
 *  朦胧
 */
@interface TFFilterHazy : CLDefaultEmptyFilter
@end
@implementation TFFilterHazy
@end

/**
 *  梦幻
 */
@interface TFFilterDream : CLDefaultEmptyFilter
@end
@implementation TFFilterDream
@end

/**
 *  淡雅
 */
@interface TFFilterElegant : CLDefaultEmptyFilter
@end
@implementation TFFilterElegant
@end

/**
 *  胶片
 */
@interface TFFilterFilm : CLDefaultEmptyFilter
@end
@implementation TFFilterFilm
@end

/**
 *  胶片
 */
@interface TFFilterSensation : CLDefaultEmptyFilter
@end
@implementation TFFilterSensation
@end

/**
 *  青春
 */
@interface TFFilterYouth : CLDefaultEmptyFilter
@end
@implementation TFFilterYouth
@end


