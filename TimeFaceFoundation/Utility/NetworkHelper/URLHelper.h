//
//  URLHelper.h
//  TFProject
//
//  Created by Melvin on 10/21/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString   *kInterfaceKey = @"interface";
const static NSString   *kClassKey = @"class";

@interface URLHelper : NSObject

+ (instancetype)sharedHelper;
/**
 *  根据列表类型获取接口相对URL
 *
 *  @param listType 
 *
 *  @return
 */
- (NSString *)interfaceByListType:(NSInteger)listType;
/**
 *  根据列表类型获取接口绝对URL
 *
 *  @param listType
 *
 *  @return
 */
- (NSString *)urlByListType:(NSInteger)listType;
/**
 *  根据列表类型获取数据处理类
 *
 *  @param listType
 *
 *  @return
 */
- (NSString *)classNameByListType:(NSInteger)listType;
/**
 *  设置url、dataManager、listType映射关系字典
 *
 *  @param dict
 */
- (void)setUrlDictionary:(NSDictionary*)dict;
@end
