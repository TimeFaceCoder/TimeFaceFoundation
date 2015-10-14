//
//  PhotoGroup.h
//  TimeFaceV2
//
//  Created by 吴寿 on 15/5/20.
//  Copyright (c) 2015年 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGroup : NSObject

/**
 *  分类
 */
@property (nonatomic, copy) NSString *category;
/**
 *  分类下的图片
 */
@property (nonatomic, copy) NSMutableArray *photos;

@end
