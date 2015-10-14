//
//  NetUtility.h
//  TimeFaceFoundation
//
//  Created by luochao on 15/9/25.
//  Copyright © 2015年 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


static NSString *urlImageData;
static NSString *urlImageSave;
static NSString *urlImageSearch;
@interface NetUtility : NSObject

+(instancetype)shareNetUtility;


- (void)putImageData:(UIImage *)image hashID:(NSUInteger)hashID ;
- (void)searchImageData:(UIImage *)image;

-(void)seturlImageData:(NSString *)url1;
-(void)seturlImageSave:(NSString *)url2;
-(void)setUrlImageSearch:(NSString *)url3;
@end
