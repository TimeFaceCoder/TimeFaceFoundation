//
//  LibrarySelectedModel.m
//  TimeFaceV2
//
//  Created by Melvin on 12/1/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "LibrarySelectedModel.h"

@implementation LibrarySelectedModel


+ (LibrarySelectedModel *)modelWithImage:(UIImage *)image
                               imageName:(NSString *)imageName
                                   asset:(id)asset
                                     url:(NSURL *)url {
    LibrarySelectedModel *model = [[LibrarySelectedModel alloc] init];
    model.imageName = imageName;
    model.thumbnail = image;
    model.asset = asset;
    model.url = url;
    return model;
}




- (void)dealloc {
    _asset = nil;
    _thumbnail = nil;
    _imageName = nil;
}

@end
