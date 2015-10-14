//
//  LibrarySelectedModel.h
//  TimeFaceV2
//
//  Created by Melvin on 12/1/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LibrarySelectedModel : NSObject

@property (nonatomic ,copy) NSString    *imageName;
@property (nonatomic ,strong) UIImage   *thumbnail;
@property (nonatomic ,strong) NSURL     *url;
@property (nonatomic ,copy) id          asset;


+ (LibrarySelectedModel *)modelWithImage:(UIImage *)image
                               imageName:(NSString *)imageName
                                   asset:(id)asset
                                     url:(NSURL *)url;

@end
