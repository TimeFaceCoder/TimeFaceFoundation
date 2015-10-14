//
//  AESTools.h
//  AesDemo
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014年 TNMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface AESTools : NSObject


/**
 *  加密方法
 *
 *  @param plain
 *
 *  @return
 */
+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain;        /*加密方法,参数需要加密的内容*/
/**
 *  解密方法
 *
 *  @param ciphertexts
 *
 *  @return
 */
+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts; /*解密方法，参数数密文*/

@end
