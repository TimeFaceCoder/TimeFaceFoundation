//
//  NetworkAssistant.m
//  TFProject
//
//  Created by Melvin on 8/20/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "NetworkAssistant.h"
#import <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "TFCoreUtility.h"
#import "GZIP.h"
#import <EGOCache/EGOCache.h>
#import "TimeFaceFoundationConst.h"
#import "MessagePack.h"


#define NSNullObjects               @[@"",@0,@{},@[]]

@interface NetworkAssistant()

@property (nonatomic ,assign) BOOL     enforce;
@property (nonatomic ,assign) BOOL     cache;

@property (nonatomic ,copy  ) NSString *cacheKeyFile;

@property (nonatomic ,assign) NetWorkActionType netWorkType;

@end

@implementation NetworkAssistant

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}




#pragma mark -
#pragma mark Public
+ (instancetype)sharedAssistant {
    static NetworkAssistant* network = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!network) {
            network = [[self alloc] init];
        }
    });
    return network;
}

- (void)getDataByURL:(NSString *)url
              params:(NSDictionary *)params
            fileData:(NSMutableArray *)fileData
                 hud:(NSString *)hud
               start:(void (^)(id cacheResult))startBlock
           completed:(void (^)(id result,NSError *error))completedBlock {
    
    _netWorkType = NetWorkActionTypeGet;
    [self handleByURL:url
               params:params
             fileData:fileData
                  hud:hud
                start:startBlock
            completed:completedBlock
             progress:nil];
    
}

- (void)postDataByURL:(NSString *)url
               params:(NSDictionary *)params
             fileData:(NSMutableArray *)fileData
                  hud:(NSString *)hud
                start:(void (^)(id cacheResult))startBlock
            completed:(void (^)(id result,NSError *error))completedBlock
             progress:(NetWorkProgressBlock)progressBlock {
    _netWorkType = NetWorkActionTypePost;
    [self handleByURL:url
               params:params
             fileData:fileData
                  hud:hud
                start:startBlock
            completed:completedBlock
             progress:progressBlock];
    
}

- (void)putImageData:(UIImage *)image hashID:(NSUInteger)hashID  {
    if (!image) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://220.178.51.183:4388/index/images/%@",@(hashID)];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    if (image) {
        TFLog(@"url:%@",url);
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:imageData];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer = responseSerializer;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                           
                                                                       }
                                                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                  if (!error) {
                                                                      [self saveImageIndex];
                                                                  }
                                                              }];
    
    [uploadTask resume];
}

- (void)saveImageIndex {
    NSString *url = @"http://220.178.51.183:4388/index/io";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSDictionary *dic = @{@"type":@"WRITE",
                          @"index_path":@"test.dat"};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&error];
    
    [request setHTTPBody:jsonData];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer = responseSerializer;
    
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        [SVProgressHUD showWithStatus:@"正在检索"];
    //    });
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                           
                                                                       }
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                          {
                                              TFLog(@"responseObject:%@",responseObject);
                                          }];
    
    [uploadTask resume];
}

- (void)searchImageData:(UIImage *)image {
    NSString *url = [NSString stringWithFormat:@"http://220.178.51.183:4388/index/searcher"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:imageData];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer = responseSerializer;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                           
                                                                       }
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  if (error) {
                                                                      //            NSLog(@"Error: %@", error);
                                                                  } else {
                                                                      NSLog(@"responseObject %@", responseObject);
                                                                  }
                                                              }];
    
    [uploadTask resume];
}


#pragma mark - 基础公用网络部分

- (void)handleByURL:(NSString *)url
             params:(NSDictionary *)params
           fileData:(NSMutableArray *)fileData
                hud:(NSString *)hud
              start:(void (^)(id cacheResult))startBlock
          completed:(void (^)(id result,NSError *error))completedBlock
           progress:(NetWorkProgressBlock)progressBlock {
    
    if (!url) {
        completedBlock(nil,nil);
        return;
    }
    NSAssert(completedBlock,@"completedBlock is nil");
    
    if (hud.length) {
        [SVProgressHUD showWithStatus:hud];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    if (![url hasPrefix:@"http"]) {
        if (_urlBlock) {
            url = _urlBlock(url);
        }
    }
    
    
    NSString *cacheKey = [[TFCoreUtility sharedUtility] getMD5StringFromNSString:[url stringByAppendingString:params?[params description]:@""]];
    TFLog(@"cacheKey:%@",cacheKey);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    if (IS_RUNNING_IOS9) {
    //        //忽略证书校验
    //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //        policy.allowInvalidCertificates  = YES;
    //        policy.validatesDomainName       = NO;
    //        manager.securityPolicy           = policy;
    //    }
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (_headerDic && _headerDic.count) {
        for (NSString *key in _headerDic.allKeys) {
            [manager.requestSerializer setValue:[_headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    
    TFLog(@"request header = %@ url = %@",manager.requestSerializer.HTTPRequestHeaders,url);
    TFLog(@"params = %@",params);
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    //检测网络是否正常
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        //网络异常
        NSError *error = [NSError errorWithDomain:TF_APP_ERROR_DOMAIN
                                             code:kTFErrorCodeNetwork
                                         userInfo:nil];
        completedBlock(nil,error);
    }
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [manager.reachabilityManager startMonitoring];
    if (startBlock) {
        id cacheObject = [[EGOCache globalCache] objectForKey:cacheKey];
        startBlock(cacheObject);
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:params];
    for (NSString *key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if (value) {
            [dic setObject:value forKey:key];
        }
    }
    if (_netWorkType == NetWorkActionTypeGet) {
        [manager GET:url
          parameters:params
            progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progressBlock) {
                    //                    progressBlock(percentDone,totalBytesWritten);
                }
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 if (hud.length) {
                     [SVProgressHUD dismiss];
                 }
                 [self postSuccess:task
                    responseObject:responseObject
                          cacheKey:cacheKey
                         completed:completedBlock];
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 if (hud.length) {
                     [SVProgressHUD dismiss];
                 }
                 [self postFailureWithError:error completed:completedBlock];
             }];
    } else if (_netWorkType == NetWorkActionTypePost){
        [manager POST:url
           parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
               if (fileData) {
                   for (NSDictionary *entry in fileData) {
                       if ([entry isKindOfClass:[NSDictionary class]]) {
                           if ([entry objectForKey:@"path"]) {
                               NSError *error = nil;
                               NSData *tempData = [NSData dataWithContentsOfFile:[entry objectForKey:@"path"]
                                                                         options:NSDataReadingMappedIfSafe
                                                                           error:&error];
                               [formData appendPartWithFileData:tempData
                                                           name:[entry objectForKey:@"name"]
                                                       fileName:[entry objectForKey:@"fileName"]
                                                       mimeType:[entry objectForKey:@"mimeType"]];
                           }
                           else {
                               //循环添加post文件
                               [formData appendPartWithFileData:[entry objectForKey:@"data"]
                                                           name:[entry objectForKey:@"name"]
                                                       fileName:[entry objectForKey:@"fileName"]
                                                       mimeType:[entry objectForKey:@"mimeType"]];
                           }
                       }
                   }
               }
           } progress:^(NSProgress * _Nonnull uploadProgress) {
               
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               if (hud.length) {
                   [SVProgressHUD dismiss];
               }
               [self postSuccess:task
                  responseObject:responseObject
                        cacheKey:cacheKey
                       completed:completedBlock];
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               if (hud.length) {
                   [SVProgressHUD dismiss];
               }
               [self postFailureWithError:error completed:completedBlock];
           }];
    }
    
    //    if (progressBlock) {
    //        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    //            double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    //            progressBlock(percentDone,totalBytesWritten);
    //        }];
    //    }
    
}
- (void)postSuccess:(NSURLSessionTask *)task
     responseObject:(id)responseObject
           cacheKey:(NSString *)cacheKey
          completed:(void (^)(id result,NSError *error))completedBlock {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *headerData = [response allHeaderFields];
    if (!responseObject) {
        return completedBlock(nil,nil);
    }
    if ([headerData objectForKey:@"Data-Type"]) {
        //gzip 压缩 执行解压
        responseObject = [responseObject gunzippedData];
    }
    NSError *error = nil;
    id rootObject = nil;
    if ([[headerData objectForKey:@"OUTFLAG"] isEqualToString:@"MSGPACK"]) {
        //使用MSGPACK进行解析
        rootObject = [responseObject messagePackParse];
        if (!rootObject) {
            //尝试GZIP
            responseObject = [responseObject gunzippedData];
            error = nil;
            rootObject = [responseObject messagePackParse];
        }
    }
    else {
        //使用JSON进行解析
        rootObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
        if (!rootObject) {
            //尝试GZIP
            responseObject = [responseObject gunzippedData];
            error = nil;
            rootObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
        }
        
    }
    @autoreleasepool {
        if (!rootObject) {
            error = [NSError errorWithDomain:TF_APP_ERROR_DOMAIN
                                        code:kTFErrorCodeAPI
                                    userInfo:@{@"info":@"数据解析错误"}];
        } else {
            NSInteger status = [[rootObject objectForKey:@"status"] boolValue];
            TFLog(@"errorcode = %@",[rootObject objectForKey:@"errorCode"]);
            NSInteger code = [[rootObject objectForKey:@"errorCode"] integerValue];
            if (!status && code != kTFErrorCodeUnknown) {
                error = [NSError errorWithDomain:TF_APP_ERROR_DOMAIN
                                            code:code
                                        userInfo:nil];
            }
            else {
                //数据正常,写入cache
                if (cacheKey) {
                    [[EGOCache globalCache] setObject:rootObject forKey:cacheKey];
                }
            }
            if (_errorCodeBlock) {
                self.errorCodeBlock(error.code);
            }
        }
        
    }
    if (completedBlock) {
        completedBlock(rootObject,error);
    }
}

- (void)postFailureWithError:(NSError *)error
                   completed:(void (^)(id result,NSError *error))completedBlock
{
    if (error.code == -1005) {
        error = [NSError errorWithDomain:TF_APP_ERROR_DOMAIN
                                    code:kTFErrorCodeNetwork
                                userInfo:error.userInfo];
        completedBlock(nil,error);
    }
    else {
        //整理错误信息
        error = [NSError errorWithDomain:TF_APP_ERROR_DOMAIN
                                    code:kTFErrorCodeAPI
                                userInfo:error.userInfo];
        TFLog(@"error:%@",error.userInfo);
        completedBlock(nil,error);
    }
}

/**
 *  当前缓存大小
 *
 *  @return long long
 */
- (NSUInteger)totalCacheSize; {
    return 0;
}


@end

@interface NSNull (InternalNullExtention)

@end

@implementation NSNull (InternalNullExtention)

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:selector];
            if (signature) {
                break;
            }
        }
        
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}
@end
