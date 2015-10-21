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


//NSString* const kMJSONErrorDomain = @"com.press-mart.timeface.json";

//NSInteger const kMJSONErrorCodeInvalidJSON = 101;

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
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
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
    NSProgress *progress = nil;
    
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        [SVProgressHUD showWithStatus:@"正在检索"];
    //    });
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
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
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
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

- (void)handleByURL:(NSString *)interface
                   params:(NSDictionary *)params
                 fileData:(NSMutableArray *)fileData
                      hud:(NSString *)hud
                    start:(void (^)(id cacheResult))startBlock
                completed:(void (^)(id result,NSError *error))completedBlock
                 progress:(NetWorkProgressBlock)progressBlock {
    
    if (!interface) {
        completedBlock(nil,nil);
        return;
    }
    NSAssert(completedBlock,@"completedBlock is nil");
    
    if (hud.length) {
        [SVProgressHUD showWithStatus:hud];
    }
    
    NSString *url = nil;
    if (_urlBlock) {
        _urlBlock(interface,url);
    }
    
    if (IS_RUNNING_IOS9) {
        //https
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    
    
    
    NSString *cacheKey = [[TFCoreUtility sharedUtility] getMD5StringFromNSString:[url stringByAppendingString:params?[params description]:@""]];
    TFLog(@"cacheKey:%@",cacheKey);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    if (IS_RUNNING_IOS9) {
        //忽略证书校验
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        policy.validatesCertificateChain = NO;
        policy.allowInvalidCertificates  = YES;
        policy.validatesDomainName       = NO;
        manager.securityPolicy           = policy;
    }
    
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
        NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                             code:TFErrorCodeNetwork
                                         userInfo:nil];
        completedBlock(nil,error);
    }
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [manager.reachabilityManager startMonitoring];
    if (startBlock) {
//        id cacheObject = [[EGOCache globalCache] objectForKey:cacheKey];
        startBlock(nil);
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
    AFHTTPRequestOperation *operation = nil;
    if (fileData && [fileData count] > 0) {
        operation = [manager POST:url
                       parameters:dic
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                     }
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (hud.length) {
                             [SVProgressHUD dismiss];
                         }
                         [self postSuccess:operation
                            responseObject:responseObject
                                  cacheKey:cacheKey
                                 completed:completedBlock];
                         
                     }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (hud.length) {
                             [SVProgressHUD dismiss];
                         }
                         [self postFailure:operation error:error completed:completedBlock];
                     }];
        
    } else {
        if (_netWorkType == NetWorkActionTypeGet) {
            operation = [manager GET:url
                          parameters:dic
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if (hud.length) {
                                     [SVProgressHUD dismiss];
                                 }
                                 [self postSuccess:operation
                                    responseObject:responseObject
                                          cacheKey:cacheKey
                                         completed:completedBlock];
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                 if (hud.length) {
                                     [SVProgressHUD dismiss];
                                 }
                                 [self postFailure:operation error:error completed:completedBlock];
                             }];
        } else if (_netWorkType == NetWorkActionTypePost){
            operation = [manager POST:url
                           parameters:dic
                              success:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             if (hud.length) {
                                 [SVProgressHUD dismiss];
                             }
                             [self postSuccess:operation
                                responseObject:responseObject
                                      cacheKey:cacheKey
                                     completed:completedBlock];
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             if (hud.length) {
                                 [SVProgressHUD dismiss];
                             }
                             [self postFailure:operation error:error completed:completedBlock];
                         }];
        }
    }
    if (progressBlock) {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            progressBlock(percentDone,totalBytesWritten);
        }];
    }
    
}
//AFHTTPRequestOperation *operation, id responseObject
- (void)postSuccess:(AFHTTPRequestOperation *)operation
     responseObject:(id)responseObject
           cacheKey:(NSString *)cacheKey
          completed:(void (^)(id result,NSError *error))completedBlock {
    NSDictionary *headerData = [[operation response] allHeaderFields];
    if (!responseObject) {
        return completedBlock(nil,nil);
    }
    if ([headerData objectForKey:@"Data-Type"]) {
        //gzip 压缩 执行解压
        responseObject = [responseObject gunzippedData];
    }
    // JSON 解析
    NSError *error = nil;
    id rootObject = nil;
    
    @autoreleasepool {
        rootObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                     options:NSJSONReadingMutableContainers
                                                       error:&error];
        if (!responseObject) {
            //尝试GZIP
            responseObject = [responseObject gunzippedData];
            error = nil;
            rootObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
        }
        
        if (!rootObject) {
            error = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                        code:TFErrorCodeAPI
                                    userInfo:nil];
        } else {
            NSInteger status = [[rootObject objectForKey:@"status"] boolValue];
            TFLog(@"errorcode = %@",[rootObject objectForKey:@"errorCode"]);
            TFErrorCode code = [[rootObject objectForKey:@"errorCode"] integerValue];
            if (!status && code != TFErrorCodeUnknown) {
                error = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                            code:code
                                        userInfo:nil];
            }
            else {
                //数据正常,写入cache
                [[EGOCache globalCache] setObject:rootObject forKey:cacheKey];
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

//AFHTTPRequestOperation *operation, NSError *error
- (void)postFailure:(AFHTTPRequestOperation *)operation
              error:(NSError *)error
          completed:(void (^)(id result,NSError *error))completedBlock
{
    if (error.code == -1005) {
        
        NSError *error = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                             code:TFErrorCodeNetwork
                                         userInfo:nil];
        completedBlock(nil,error);
    }
    else {
        
        NSString *errorData = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"cn.timeface.response.error.data"]
                                                    encoding:NSUTF8StringEncoding];
        
        TFLog(@"error:%@",errorData);
        
        
        //整理错误信息
        error = [NSError errorWithDomain:APP_ERROR_DOMAIN
                                    code:TFErrorCodeAPI
                                userInfo:nil];
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
