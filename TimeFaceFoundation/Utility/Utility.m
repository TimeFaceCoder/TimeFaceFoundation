//
//  Utility.m
//  TFProject
//
//  Created by boxwu on 5/26/15.
//  Copyright (c) 2014 TimeFace. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import "SSKeychain.h"
#import "TFDefaultStyle.h"
#import "System Services/SystemServices.h"
#import "UserModel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "KvStore.h"
#import "Pinyin.h"
#import "ZipArchive.h"
#import "RegionModel.h"

void TFAsyncRun(TFRun run) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        run();
    });
}

void TFMainRun(TFRun run) {
    dispatch_async(dispatch_get_main_queue(), ^{
        run();
    });
}

@implementation Utility

+ (instancetype)sharedUtility
{
    static Utility* utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!utility) {
            utility = [[self alloc] init];
        }
    });
    return utility;
}

#pragma  mark - NSString

- (NSString *)getMD5StringFromNSString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *result = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat: @"%02x", (int)(digest[i])];
    }
    return [result copy];
}
/**
 *  获取用户userID
 *
 *  @return
 */
- (NSString *)getUserId {
    UserModel *user = [[KvStore shared] getCurrentUserModel];
    if (!user) {
        return @"";
    }
    return user.userId;
    //    return user.userId;
}
-(NSString *)showUsername:(NSString *)name {
    NSString *username = @"";
    if ([self validateUserPhone:name]) {
        username = [NSString stringWithFormat:@"%@****%@",[name substringToIndex:3],[name substringFromIndex:(name.length - 4)]];
    } else {
        username = name;
    }
    return username;
}


- (NSString *)getDeviceId {
    NSString *idfv = [SSKeychain passwordForService:@"tf__ios" account:@"app_user"];
    if (!idfv) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:idfv forService:@"tf__ios" account:@"app_user"];
    }
    return idfv;
}

- (NSString *)getTimeDescriptionStringByTimeInterval:(NSTimeInterval)timeInterval {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:date1 toDate:[NSDate date] options:0];
    if (components.year > 0) {
        //        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription years", nil),components.year];
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if(components.month >0){
        //        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription month", nil),components.month];
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if (components.day > 0) {
        if (components.day > 3) {
            return [self getTimeStringByTimeInterval2:timeInterval];
        }
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription day", nil),components.day];
    } else if(components.hour > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription hour", nil),components.hour];
    } else if(components.minute > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription minute", nil),components.minute];
    } else {
        return NSLocalizedString(@"TimeDescription moment", nil);
    }
}
- (NSString *)getTimeStringByTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [self getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}
- (NSString *)getScreen {
    NSInteger width = 2 * [[SystemServices sharedServices] screenWidth];
    NSInteger height = 2 * [[SystemServices sharedServices] screenHeight];
    NSString *screen = [NSString stringWithFormat:@"%ldX%ld",(long)width,(long)height];
    return screen;
}
- (NSString *)subString:(NSString *)str length:(NSInteger)length {
    
    if ([self charNumber:str] > length) {
        NSString* tmp;
        for (NSInteger i = str.length; i > 0; i--) {
            tmp = [str substringToIndex:i];
            if ([self charNumber:tmp] <= length) {
                return tmp;
                break;
            }
        }
    }
    return str;
}

/**
 *  将时间转为字符串
 *
 *  @param date   时间（NSDate）
 *  @param format 格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
/**
 *  将时间转为字符串
 *
 *  @param timeInterval 时间戳（NSTimeInterval）
 *  @param format       格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSDate *fromdate= [self getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *string = [dateFormat stringFromDate:fromdate];
    return string;
}

- (NSString*)getTimeDescriptionStringByTimeIntervalForTimeDetail:(NSTimeInterval)timeInterval {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:date1 toDate:[NSDate date] options:0];
    if (components.year > 0) {
        return [self getTimeStringByTimeInterval2:timeInterval];
    } else if(components.month >0){
        NSString *timeDescription = [self getTimeStringByTimeInterval2:timeInterval];
        return [timeDescription substringFromIndex:5];
    } else if (components.day > 0) {
        if (components.day > 3) {
            NSString *timeDescription = [self getTimeStringByTimeInterval2:timeInterval];
            return [timeDescription substringFromIndex:5];
        }
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription day", nil),components.day];
    } else if(components.hour > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription hour", nil),components.hour];
    } else if(components.minute > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"TimeDescription minute", nil),components.minute];
    } else {
        return NSLocalizedString(@"TimeDescription moment", nil);
    }
}
- (NSString *)getTimeStringByTimeInterval2:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [self getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}
- (NSString *)getStringFromUrl:(NSString *)url withKey:(NSString *)key{
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(^|&|\\?)%@=([^&]*)(&|$)",key] options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:url
                                                           options:0
                                                             range:NSMakeRange(0, [url length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[url substringWithRange:resultRange];
            NSRange rangeOne;
            rangeOne=[result rangeOfString:[key stringByAppendingString:@"="]];
            NSRange range = NSMakeRange(rangeOne.length+rangeOne.location, result.length-(rangeOne.length+rangeOne.location));
            //获取code值
            NSString *targetStr = [[result substringWithRange:range] stringByReplacingOccurrencesOfString:@"&" withString:@""];
            return targetStr;
        }
    }
    return nil;
}
- (NSString *)getCircleIdFromUrl:(NSString *)url withKey:(NSString *)key {
    NSArray *array = [url componentsSeparatedByString:@"/"];
    if (array.count < 2) {
        return nil;
    }
    
    NSString *circle = array[array.count - 2];
    if ([circle isEqualToString:key]) {
        return array[array.count - 1];
    }
    return nil;
}

/**
 *  获取地址
 *
 *  @param location
 *
 *  @return
 */
-(NSString *) getRegionName:(NSString *)location {
    NSMutableString *region = [[NSMutableString alloc] initWithString:@""];
    NSString *current = @"";
    NSArray *array = [location componentsSeparatedByString:@","];
    for (NSString *cityId in array) {
        NSString *cityName = [self getCityName:[cityId integerValue]];
        if (cityName.length) {
            if (![current isEqualToString:cityName]) {
                current = cityName;
                [region appendFormat:@",%@",cityName];
            }
        }
    }
    
    return (region.length?[region substringFromIndex:1]:@"");
}
/**
 *  获取地区名称
 *
 *  @param cityId
 *
 *  @return
 */
-(NSString *) getCityName:(NSInteger)cityId {
    if (!cityId) {
        return nil;
    }
    NSArray *results = [[KvStore shared] getRegion];
    NSString *cid = [NSString stringWithFormat:@"%ld",(long)cityId];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.locationId = %@", cid];
    NSArray *as = [results filteredArrayUsingPredicate: predicate];
    if (as.count) {
        NSError *error = nil;
        RegionModel *model = [[RegionModel alloc] initWithDictionary:[as objectAtIndex:0] error:&error];
        model.hasChild = [self checkRegionChild:model.locationId citys:results];
        return model.locationName;
    }
    return nil;
}
/**
 *  获取数据库存储路径
 */
- (NSString*)getDirectoryDBPath:(NSString *)dbName {
    NSArray *paths = nil;
#ifdef DEBUG
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#else
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
#endif
    NSString *path = [paths objectAtIndex:0];;
    
    return [path stringByAppendingPathComponent:dbName] ;
    
}

/**
 *  图片请求转换
 *
 *  @param url
 *  @param type
 *
 *  @return
 */
- (NSString *)handleImageUrl:(NSString *)url type:(NSString *)type {
    //    NSInteger markUpload = [[self getValueByKey:STORE_KEY_PICTUREQUALITYBROWSE] integerValue];
    //    //0自动 1高 2低
    //    if (markUpload == 0) {
    //        if ([[SystemServices sharedServices] connectedToWiFi]) {
    //            //使用高清图
    //            NSRange thumbnail = [url rangeOfString:@"thumbnail"];
    //            if (thumbnail.length > 0) {
    //                url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:type];
    //            }
    //        }
    //    }
    //    if (markUpload == 1) {
    //        //使用高清图
    //        NSRange thumbnail = [url rangeOfString:@"thumbnail"];
    //        if (thumbnail.length > 0) {
    //            url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:type];
    //        }
    //    }
    return url;
}
- (NSString *)tempFilePathForURL:(NSURL *)URL {
    NSAssert(URL,@"URL is nil");
    
    NSString *fileExtension = [URL pathExtension];
    NSString *hashedURLString = [self getMD5StringFromNSString:[URL absoluteString]];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"timeface_cache/"];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        BOOL isDirectoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                                            withIntermediateDirectories:YES
                                                                             attributes:nil
                                                                                  error:&error];
        if (!isDirectoryCreated) {
            NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException
                                                             reason:@"Failed to crate cache directory"
                                                           userInfo:@{ NSUnderlyingErrorKey : error }];
            @throw exception;
        }
    }
    NSString *temporaryFilePath = [[cacheDirectory stringByAppendingPathComponent:hashedURLString] stringByAppendingPathExtension:fileExtension];
    return temporaryFilePath;
    
}
- (NSString *)realFilePathForURL:(NSURL *)URL {
    NSAssert(URL,@"URL is nil");
    NSError *error = nil;
    NSString *hashedURLString = [self getMD5StringFromNSString:[URL absoluteString]];
    NSString *homeDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    homeDirectory = [homeDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/",[self getUserId],hashedURLString]];
    BOOL isDirectoryCreated = [[NSFileManager defaultManager] createDirectoryAtPath:homeDirectory
                                                        withIntermediateDirectories:YES
                                                                         attributes:nil
                                                                              error:&error];
    if (!isDirectoryCreated) {
        NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException
                                                         reason:@"Failed to crate cache directory"
                                                       userInfo:@{ NSUnderlyingErrorKey : error }];
        @throw exception;
    }
    return homeDirectory;
    
}

-(NSString *)getPinyinName:(NSString *)name {
    NSString *pinYinResult=[NSString string];
    for(int j=0;j < name.length;j++){
        NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([name characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}
/**
 *  获取分享内容
 *
 *  @param string
 *  @param maxLength
 *
 *  @return
 */
-(NSString *) shareMessageWithString:(NSString *)string maxLength:(NSUInteger)maxLength {
    NSUInteger len = [self unicodeLengthOfString:string];
    if (len > maxLength) {
        string = [NSString stringWithFormat:@"%@...",[self substringToIndex:maxLength withString:string]];
    }
    return string;
}
/**
 *  按字节数截取指定长度字符串
 *
 *  @param index
 *  @param string
 *
 *  @return
 */
-(NSString *) substringToIndex:(NSInteger)index withString:(NSString *)string {
    NSString *newstr = @"";
    NSUInteger length = 0;
    NSInteger charlen = 0;
    NSUInteger iloop = 0;
    
    while (iloop < string.length) {
        unichar uc = [string characterAtIndex:iloop];
        charlen = isascii(uc) ? 1 : 2;
        length += charlen;
        
        if (length > index) {
            break;
        }
        newstr = [NSString stringWithFormat:@"%@%@",newstr,[[string substringFromIndex:iloop] substringToIndex:1]];
        iloop++;
    }
    return newstr;
}


- (NSString *)getTimeStringByTimeInterval3:(NSTimeInterval)timeInterval {
    NSDate *fromdate= [self getDateByTimeInterval:timeInterval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}


//- (NSString *)getScreen {
//    NSInteger width = 2 * [[SystemServices sharedServices] screenWidth];
//    NSInteger height = 2 * [[SystemServices sharedServices] screenHeight];
//    NSString *screen = [NSString stringWithFormat:@"%ldX%ld",(long)width,(long)height];
//    return screen;
//}
//- (NSString*)getLastDialogId:(NSString *)userId friendId:(NSString *)friendId {
//    DialogDatabaseManager *manager = [[DialogDatabaseManager alloc]init];
//    NSString *dialogId = @"0";
//    if ([manager isTableDataExist]) {
//        DialogModel *model  = [manager getLastDialogInfoByUserId:userId friendId:friendId];
//        if (model) {
//            dialogId = model.dialogId;
//        }
//
//    }
//    return dialogId;
//}
#pragma mark - UIImage
/**
 *  使用颜色生成1*1图片
 *
 *  @param color
 *
 *  @return
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  使用颜色生成指定尺寸图片
 *
 *  @param color
 *  @param width
 *  @param height
 *
 *  @return
 */
- (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  使用颜色值、透明度生成图片
 *
 *  @param color 颜色值
 *  @param alpha 透明度
 *
 *  @return 图片对象
 */
- (UIImage *)createImageWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)currentViewToImage {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedScreen;
}
-(UIImage *)getImageFromView:(UIView *)orgView {
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - NSArray

/**
 *  创建导航条按纽
 *
 *  @param imageName
 *  @param selectedImageName
 *  @param delegate
 *  @param selector
 *
 *  @return
 */
- (NSArray *)createBarButtonsWithImage:(NSString *)imageName
                     selectedImageName:(NSString *)selectedImageName
                              delegate:(id)delegate
                              selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttomImage = [UIImage imageNamed:imageName];
    UIImage *buttomImageH = [UIImage imageNamed:selectedImageName];
    [button setTfSize:buttomImage.size];
    [button setImage:buttomImage forState:UIControlStateNormal];
    [button setImage:buttomImageH forState:UIControlStateHighlighted];
    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithImages:(NSArray *)imageNames
                     selectedImageNames:(NSArray *)selectedImageNames
                               delegate:(id)delegate
                               selector:(SEL)selector {
    
    NSMutableArray *barButtons = [NSMutableArray arrayWithCapacity:1];
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    [barButtons addObject:barButtonSpacer];
    NSInteger index = 0;
    for (NSString *imageName in imageNames) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttomImage = [UIImage imageNamed:imageName];
        UIImage *buttomImageH = [UIImage imageNamed:[selectedImageNames objectAtIndex:index]];
        [button setTfSize:buttomImage.size];
        [button setImage:buttomImage forState:UIControlStateNormal];
        [button setImage:buttomImageH forState:UIControlStateHighlighted];
        [button setImage:buttomImageH forState:UIControlStateSelected];
        [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [barButtons addObject:barButtonItem];
        [barButtons addObject:barButtonSpacer];

        index ++;
    }
    [barButtons removeLastObject];

    return barButtons;
}


- (NSArray *)createBarButtonsWithTitle:(NSString *)title
                              delegate:(id)delegate
                              selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TFSTYLEVAR(navBarTitleColor) forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithButton:(UIButton *)button {
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return @[barButtonSpacer,barButtonItem];
}

- (NSArray *)createBarButtonsWithView:(UIView *)view
                             delegate:(id)delegate
                             selector:(SEL)selector {
    
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:NAV_BUTTON_SPACE];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    return @[barButtonSpacer,barButtonItem];
}
/**
 *  根据Pid获取地区
 *
 *  @param pid
 *
 *  @return
 */
-(NSMutableArray *) getCitysWithPid:(NSInteger)pid {
    NSMutableArray *citys = [NSMutableArray array];
    
    NSArray *results = [[KvStore shared] getRegion];
    NSString *cid = [NSString stringWithFormat:@"%ld",(long)pid];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.locationPid = %@", cid];
    NSArray *as = [results filteredArrayUsingPredicate: predicate];
    
    for (NSDictionary *dic in as) {
        NSError *error = nil;
        RegionModel *model = [[RegionModel alloc] initWithDictionary:dic error:&error];
        model.hasChild = [self checkRegionChild:model.locationId citys:results];
        [citys addObject:model];
    }
    return citys;
}
#pragma mark - UIBarButtonItem
- (UIBarButtonItem *)createBarButtonWithImage:(NSString *)imageName
                     selectedImageName:(NSString *)selectedImageName
                              delegate:(id)delegate
                              selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttomImage = [UIImage imageNamed:imageName];
    UIImage *buttomImageH = [UIImage imageNamed:selectedImageName];
    [button setTfSize:buttomImage.size];
    [button setImage:buttomImage forState:UIControlStateNormal];
    [button setImage:buttomImageH forState:UIControlStateHighlighted];
    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

- (UIBarButtonItem *)createBarButtonWithTitle:(NSString *)title
                              delegate:(id)delegate
                              selector:(SEL)selector {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TFSTYLEVAR(navBarTitleColor) forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

#pragma mark - Void
- (void)saveValueByKey:(NSString *)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeValueByKey:(NSString *)key {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
}

- (void)setBoolByKey:(NSString *)key value:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  添加书签
 *
 *  @param dataId
 *  @param index
 *  @param isMark
 */
- (void)addBookMark:(NSString *)dataId index:(NSUInteger)index isMark:(BOOL)isMark {
    [SSKeychain setPassword:[NSString stringWithFormat:@"%lu",(unsigned long)(isMark?index:0)]
                 forService:[NSString stringWithFormat:@"timeface_ios_book_mark_%@",dataId]
                    account:@"app_user"];
    
}
- (void)unZipFile:(NSString *)zipFile
       targetPath:(NSString *)targetPath
        completed:(void (^)(bool result,NSError *error))completedBlock {
    
    NSAssert(completedBlock,@"completedBlock is nil");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL result = [zip UnzipOpenFile:zipFile];
        NSError *error = nil;
        if (result) {
            result = [zip UnzipFileTo:targetPath overWrite:YES];
            [zip CloseZipFile2];
            if (result) {
                //删除原始文件
                [[NSFileManager defaultManager] removeItemAtPath:zipFile error:&error];
                if (error) {
                    TFLog(@"delete file error:%@",[error debugDescription]);
                }
                //移动文件
                NSArray *contentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:&error];
                
                for (NSString *path in contentArray) {
                    BOOL isDirectory;
                    NSString *currentPath = [NSString stringWithFormat:@"%@/%@/",targetPath,path];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:currentPath
                                                             isDirectory:&isDirectory]) {
                        for (NSString *entry in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentPath
                                                                                                    error:&error]) {
                            TFLog(@"entry:%@",entry);
                            //是目录,移动当前目录所有文件到上层
                            [[NSFileManager defaultManager] moveItemAtPath:[currentPath stringByAppendingPathComponent:entry]
                                                                    toPath:[targetPath stringByAppendingPathComponent:entry]
                                                                     error:&error];
                        }
                        if (!error) {
                            //删除当前目录内容
                            [[NSFileManager defaultManager] removeItemAtPath:currentPath error:&error];
                        }
                    }
                }
            }
        }
        
        completedBlock(result ,error);
        
    });
    
    
    
}



#pragma mark -id
- (NSDate *)getDateByTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return date;
}


- (id)getValueByKey:(NSString *)key {
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (temp) {
        return temp;
    }
    return nil;
}


#pragma  mark - BOOL

- (BOOL)getBoolByKey:(NSString *)key {
    BOOL temp = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return temp;
}
- (BOOL)isNUll:(id)object{
    if (!object || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isBlankOrNull:(id)object {
    if (!object || [object isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",object] isEqualToString:@"<null>"] ||[[NSString stringWithFormat:@"%@",object] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWebUrl:(NSString *)str {
    NSRange range = [str rangeOfString:@"http://"];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

/**
 *  手机号码校验
 *
 *  @param mobileNum
 *
 *  @return
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[01349])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**
 *  短信验证码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL)validateVerifyCode:(NSString *)str {
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[0-9]{6}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

/**
 *  用户名校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserName:(NSString *)str {
    NSString *patternStr = [NSString stringWithFormat:@"^.{0,4}$|.{21,}|^[^A-Za-z0-9\u4E00-\u9FA5]|[^\\w\u4E00-\u9FA5.-]|([_.-])\1"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];

    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

/**
 *  密码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserPassword:(NSString *) str {
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z0-9_\\W]{6,16}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

/**
 *  生日日期校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserBirthday:(NSString *)str {
    NSString *patternStr = @"^((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

/**
 *  手机号码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserPhone:(NSString *)str {
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}

/**
 *  邮箱校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserEmail:(NSString *)str {
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0) {
        return YES;
    }
    return NO;
}
-(BOOL)checkRegionChild:(NSInteger)pid citys:(NSArray *)citys {
    NSString *cid = [NSString stringWithFormat:@"%ld",(long)pid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.locationPid = %@", cid];
    NSArray *as = [citys filteredArrayUsingPredicate: predicate];
    if (as.count) {
        return YES;
    }
    return NO;
}


-(BOOL)isCurrentMonth:(NSTimeInterval)time {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSString *month = [self stringFromTimeInterval:currentTime format:@"yyyyMM"];
    NSString *timeMonth = [self stringFromTimeInterval:time format:@"yyyyMM"];
    if ([month isEqualToString:timeMonth]) {
        return YES;
    }
    return NO;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}


#pragma mark -NSUInteger and CGFloat
- (CGFloat)getHeightOfLabel:(NSString*)text
                       font:(UIFont*)font
                 labelWidth:(CGFloat)width
                  lineSpace:(CGFloat)lineSpace
                      lines:(NSInteger)lines {
    if (text.length == 1) {
        text = [NSString stringWithFormat:@"%@ ",text];
    }
    if (!lines) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]
                                              initWithString:text];
        
        
        //创建字体以及字体大小
        CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), font.pointSize, NULL);
        [content addAttribute:(id)kCTFontAttributeName
                        value:(__bridge id)helvetica
                        range:NSMakeRange(0, [content length])];
        //设置字体区域行间距
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value=&lineSpace;
        
        //创建样式数组
        CTParagraphStyleSetting settings[]={
            lineSpaceStyle
        };
        //设置样式
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
        
        [content addAttribute:(id)kCTParagraphStyleAttributeName
                        value:(__bridge id)paragraphStyle
                        range:NSMakeRange(0, [content length])];
        
        // layout master
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
        
        //计算文本绘制size
        CGSize tmpSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, MAXFLOAT), NULL);
        
        CFRelease(helvetica);
        CFRelease(paragraphStyle);
        CFRelease(framesetter);
        return tmpSize.height;
    } else {
        CGFloat lineHeight = font.lineHeight + lineSpace;
        CGSize size = CGSizeMake(width, lineHeight * lines);

        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        CGSize labelHeight = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
//        CGSize labelHeight = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        
        return labelHeight.height + 3;
    }
}

/**
 *  获取书签
 *
 *  @param dataId
 *
 *  @return
 */
- (NSUInteger)getBookMark:(NSString *)dataId {
    NSString *index = [SSKeychain passwordForService:[NSString stringWithFormat:@"timeface_ios_book_mark_%@",dataId]
                                             account:@"app_user"];
    if (index) {
        return [index integerValue];
    }
    return 0;
}

- (NSInteger)getStrLineNum:(NSString *)str lineNum:(int)lineNum {
    NSInteger charNum = 0;
    NSInteger retNum = 0;
    
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    for(NSString *item in array){
        NSInteger len = [item length];
        charNum = 0;
        for (int i=0; i<len; i++) {
            unichar c = [item characterAtIndex:i];
            if(c < 127){
                charNum++;
            }else{
                charNum += 2;
            }
        }
        retNum += (charNum-1) / lineNum;
        if(charNum % lineNum >= 0)
            retNum++;
    }
    return retNum;
    
}

- (NSInteger)charNumber:(NSString*)strtemp
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}


#pragma mark - PhotoQuality
/**
 *  获取图片质量限制
 *
 *  @return
 */
- (CGFloat)getPhotoQuality {
    // 0 自动 1 高 2 低
//    PictureQualityType type = [[[Utility sharedUtility] getValueByKey:STORE_KEY_PICTUREQUALITYUPLOAD] integerValue];
    CGFloat zoom = 1.0;
    
//    switch (type) {
//        case PictureQualityTypeDefault:
//            if ([[SystemServices sharedServices] connectedToWiFi]) {
//                zoom = .7f;
//            } else {
//                zoom = .6f;
//            }
//            
//            break;
//        case PictureQualityTypeHigh:
//            zoom = .7f;
//            break;
//        case PictureQualityTypeLow:
//            zoom = .6f;
//            break;
//            
//        default:
//            break;
//    }
    return zoom;
}


/**
 *  计算字符串的字节数
 *
 *  @param string
 *
 *  @return
 */
-(NSUInteger) unicodeLengthOfString:(NSString *)string {
    NSUInteger length = 0;
    NSInteger charlen = 0;
    NSUInteger iloop = 0;
    
    while (iloop < string.length) {
        unichar uc = [string characterAtIndex:iloop];
        charlen = isascii(uc) ? 1 : 2;
        
        length += charlen;
        iloop++;
    }
    
    return length;
}

- (NSInteger)decodeTimeUID:(NSString *)timeid {
    if (!timeid.length) {
        return 0;
    }
    NSString *tempTimeID = [timeid mutableCopy];
    int idLen = [[tempTimeID substringWithRange:NSMakeRange(0, 1)] intValue];
    int random = [[tempTimeID substringWithRange:NSMakeRange(1, 1)] intValue];
    NSInteger startPoint = 12 - idLen;
    tempTimeID = [tempTimeID substringWithRange:NSMakeRange(startPoint, 12 - startPoint)];
    char idChar[100];
    
    memcpy(idChar, [tempTimeID cStringUsingEncoding:NSASCIIStringEncoding], 2*[tempTimeID length]);
    
    size_t length= strlen(idChar);
    
    for (int i = 0; i < length; i++)
    {
        int tmp = (int) idChar[i] - random;
        if (tmp < 48)
        {
            tmp = tmp + 10;
        }
        idChar[i] = (char)tmp;
        
    }
    NSString *newTimeID = [NSString stringWithCString:idChar encoding:NSASCIIStringEncoding];
    //    free(idChar);
    return [newTimeID integerValue];
}
@end
