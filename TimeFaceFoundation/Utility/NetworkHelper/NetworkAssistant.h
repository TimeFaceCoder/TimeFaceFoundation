//
//  NetworkAssistant.h
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetWorkActionType)
{
    NetWorkActionTypeGet  = 0,
    NetWorkActionTypePost = 1,
    NetWorkActionTypePut  = 2
};

typedef void(^NetWrokProgressBlock)(double percentDone,long long totalBytesWritten);

typedef NSString *(^NetWorkUrlBlock)(NSString *urlStr) ;

typedef void (^NetWorkErrorCodeBlock)(NSInteger errorCode);


@interface NetworkAssistant : NSObject

+ (instancetype)sharedAssistant;

@property (nonatomic ,assign) double progress;
/**
 *  请求头信息字典
 */
@property (nonatomic, copy) NSDictionary *headerDic;

//@property (nonatomic, copy) NSString  *APP_ERROR_DOMAIN;

@property (nonatomic, strong) NetWorkErrorCodeBlock errorCodeBlock;

- (void)getDataByInterFace:(NSString *)interface
                    params:(NSDictionary *)params
                  fileData:(NSMutableArray *)fileData
                       hud:(NSString *)hud
                     start:(void (^)(id cacheResult))startBlock
                 completed:(void (^)(id result,NSError *error))completedBlock;

/**
 *  POST
 *
 *  @param interface      接口
 *  @param params         参数
 *  @param fileData       post文件字典 基本形式 [{@"data":data,@"name":name,@"fileName":fileName,@"mimeType":mimeType}]
 *  @param hud            提示信息
 *  @param startBlock
 *  @param completedBlock
 *  @param progressBlock
 */
- (void)postDataByInterFace:(NSString *)interface
                     params:(NSDictionary *)params
                   fileData:(NSMutableArray *)fileData
                        hud:(NSString *)hud
                      start:(void (^)(id cacheResult))startBlock
                  completed:(void (^)(id result,NSError *error))completedBlock
                   progress:(NetWrokProgressBlock)progressBlock;


- (void)putImageData:(UIImage *)image hashID:(NSUInteger)hashID  ;

- (void)searchImageData:(UIImage *)image;

- (NSString *)getUrl:(NetWorkUrlBlock)progress;

@end
