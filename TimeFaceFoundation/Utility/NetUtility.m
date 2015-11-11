//
//  NetUtility.m
//  TimeFaceFoundation
//
//  Created by luochao on 15/9/25.
//  Copyright © 2015年 timeface. All rights reserved.
//

#import "NetUtility.h"
#import "TimeFaceFoundationConst.h"

#define TFPHOTOURLIMAGE  @"";
@implementation NetUtility

//单例
+(instancetype)shareNetUtility{
    static NetUtility *netUtility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!netUtility) {
            netUtility = [[self alloc] init];
        }
    });
    return netUtility;
}

//写入url
-(void)seturlImageData:(NSString *)url1{
    urlImageData = url1;
}
//写入url
-(void)seturlImageSave:(NSString *)url2{
    urlImageSave = url2;
}
//写入url
-(void)setUrlImageSearch:(NSString *)url3{
    urlImageSearch = url3;
}
- (void)putImageData:(UIImage *)image hashID:(NSUInteger)hashID {
    if (!image) {
        return;
    }
    //    NSString *url = [NSString stringWithFormat:@"http://220.178.51.183:4388/index/images/%@",@(hashID)];
    NSString *url = [NSString stringWithFormat:@"%@/%@",urlImageData,@(hashID)];
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
//    NSString *url = @"http://220.178.51.183:4388/index/io";
    NSString *url = urlImageSave;
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
//    NSString *url = [NSString stringWithFormat:@"http://220.178.51.183:4388/index/searcher"];
    NSString *url = urlImageSearch;
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
@end
