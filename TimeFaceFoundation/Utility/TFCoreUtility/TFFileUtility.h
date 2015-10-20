//
//  TFFileUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFFileUtility : NSObject


+ (instancetype)shared;


/**
 *  获取数据库存储路径
 */
- (NSString*)getDirectoryDBPath:(NSString *)dbName;

/**
 *  获取本地cache文件
 *
 *  @param URL
 *
 *  @return
 */
- (NSString *)tempFilePathForURL:(NSURL *)URL;
///**
// *  获取缓存文件路径
// *
// *  @param URL
// *
// *  @return
// */
//- (NSString *)realFilePathForURL:(NSURL *)URL;




@end
