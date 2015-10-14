//
//  UserModel.m
//  TimeFaceV2
//
//  Created by Melvin on 10/29/14.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "UserModel.h"
#import "Pinyin.h"





@implementation UserModel

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    if (!_pinyinName.length) {
        //生成拼音码
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSString *pinYinResult=[NSString string];
                for(int j=0;j < _nickName.length;j++){
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([_nickName characterAtIndex:j])] uppercaseString];
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                _pinyinName = pinYinResult;
            }
        });
    }
}

@end
