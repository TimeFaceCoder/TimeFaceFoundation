//
//  TFCoreUtility.h
//  TimeFaceFoundation
//
//  Created by Melvin on 10/14/15.
//  Copyright © 2015 timeface. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageUtility.h"
#import "TFStringUtility.h"
#import "TFFileUtility.h"
#import "TFDeviceUtility.h"
#import "TFViewUtility.h"
#import "TFSecurityUtility.h"
#import "TFDataUtility.h"


static TFImageUtility *imageUtility = nil;
static TFStringUtility *stringUtility = nil;
static TFFileUtility *fileUtility = nil;
static TFDeviceUtility *deviceUtility = nil;
static TFViewUtility *viewUtility = nil;
static TFSecurityUtility *securityUtility = nil;
static TFDataUtility *dataUtility = nil;

typedef void (^TFRun)(void);

/**
 *  后台执行
 *
 *  @param run
 */
void TFAsyncRun(TFRun run);

/**
 *  主线程执行
 *
 *  @param run
 */
void TFMainRun(TFRun run);

@interface TFCoreUtility : NSObject

+ (instancetype)sharedUtility;

/**
 *  设置图片处理工具类
 *
 *  @param utility
 */
- (void)setImageUtility:(TFImageUtility*)utility;

/**
 *  设置字符串处理工具类
 *
 *  @param utility
 */
- (void)setStringUtility:(TFStringUtility*)utility;
/**
 *  设置文件相关处理工具类
 *
 *  @param utility
 */
- (void)setFileUtility:(TFFileUtility*)utility;
/**
 *  设置设备相关处理工具类
 *
 *  @param utility
 */
- (void)setDeviceUtility:(TFDeviceUtility*)utility;
/**
 *  设置视图处理工具类
 *
 *  @param utility
 */
- (void)setViewUtility:(TFViewUtility*)utility;
/**
 *  设置加密安全处理工具类
 *
 *  @param utility
 */
- (void)setSecurityUtility:(TFSecurityUtility*)utility;
/**
 *  设置数据处理相关工具类
 *
 *  @param utility 
 */
- (void)setDataUtility:(TFDataUtility*)utility;

#pragma mark String

- (NSString *)showUsername:(NSString *)name;




- (NSString *)getTimeDescriptionStringByTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)getTimeStringByTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)getScreen;

- (NSString *)subString:(NSString *)str length:(NSInteger)length;
- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
/**
 *  将时间转为字符串
 *
 *  @param timeInterval 时间戳（NSTimeInterval）
 *  @param format       格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;

- (NSString*)getTimeDescriptionStringByTimeIntervalForTimeDetail:(NSTimeInterval)timeInterval;

- (NSString *)getTimeStringByTimeInterval2:(NSTimeInterval)timeInterval;

- (NSString *)getStringFromUrl:(NSString *)url withKey:(NSString *)key;
- (NSString *)getCircleIdFromUrl:(NSString *)url withKey:(NSString *)key;




/**
 *  图片请求转换
 *
 *  @param url
 *  @param type
 *
 *  @return
 */
- (NSString *)handleImageUrl:(NSString *)url type:(NSString *)type;




-(NSString *)getPinyinName:(NSString *)name;
/**
 *  获取分享内容
 *
 *  @param string
 *  @param maxLength
 *
 *  @return
 */
-(NSString *) shareMessageWithString:(NSString *)string maxLength:(NSUInteger)maxLength;
/**
 *  按字节数截取指定长度字符串
 *
 *  @param index
 *  @param string
 *
 *  @return
 */
-(NSString *) substringToIndex:(NSInteger)index withString:(NSString *)string;



#pragma mark File

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



#pragma mark Image

- (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  使用颜色生成指定尺寸图片
 *
 *  @param color
 *  @param width
 *  @param height
 *
 *  @return
 */
- (UIImage *)createImageWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;

/**
 *  使用颜色值、透明度生成图片
 *
 *  @param color 颜色值
 *  @param alpha 透明度
 *
 *  @return 图片对象
 */
- (UIImage *)createImageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
/**
 *  当前屏幕截图
 *
 *  @return
 */
- (UIImage *)currentViewToImage;

/**
 *  将时间转为字符串
 *
 *  @param date   时间（NSDate）
 *  @param format 格式（yyyy-MM-dd HH:mm:ss zzz）
 *
 *  @return
 */
-(UIImage *)getImageFromView:(UIView *)orgView;


#pragma mark Device
/*
*  获取设备唯一编号
*
*  @return
*/
- (NSString *)getDeviceId;





#pragma mark Security
/**
 *  对一个string进行md5加密
 *
 *  @param string
 *
 *  @return
 */
- (NSString *)getMD5StringFromNSString:(NSString *)string;

#pragma mark View
- (NSArray *)createBarButtonsWithImage:(NSString *)imageName
                     selectedImageName:(NSString *)selectedImageName
                              delegate:(id)delegate
                              selector:(SEL)selector;

- (NSArray *)createBarButtonsWithImages:(NSArray *)imageNames
                     selectedImageNames:(NSArray *)selectedImageNames
                               delegate:(id)delegate
                               selector:(SEL)selector;

- (NSArray *)createBarButtonsWithTitle:(NSString *)title
                              delegate:(id)delegate
                              selector:(SEL)selector;

- (NSArray *)createBarButtonsWithButton:(UIButton *)button;

- (NSArray *)createBarButtonsWithView:(UIView *)view
                             delegate:(id)delegate
                             selector:(SEL)selector;

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
- (UIBarButtonItem *)createBarButtonWithImage:(NSString *)imageName
                            selectedImageName:(NSString *)selectedImageName
                                     delegate:(id)delegate
                                     selector:(SEL)selector;

- (UIBarButtonItem *)createBarButtonWithTitle:(NSString *)title
                                     delegate:(id)delegate
                                     selector:(SEL)selector;


#pragma mark Data

/**
 *  保存string到NSUserDefaults
 *
 *  @param key
 *  @param value
 */
- (void)saveValueByKey:(NSString *)key value:(id)value;

/**
 *  删除NSUserDefaults对应值
 *
 *  @param key
 *
 */
- (void)removeValueByKey:(NSString *)key ;
/**
 *  保存BOOL到NSUserDefaults
 *
 *  @param key
 *  @param value
 */
- (void)setBoolByKey:(NSString *)key value:(BOOL)value;

/**
 *  获取NSUserDefaults对应值
 *
 *  @param key
 *
 *  @return
 */
- (id)getValueByKey:(NSString *)key;

- (BOOL)getBoolByKey:(NSString *)key;

#pragma mark Validate or tool
/**
 *  添加书签
 *
 *  @param dataId
 *  @param index
 *  @param isMark
 */
- (void)addBookMark:(NSString *)dataId index:(NSUInteger)index isMark:(BOOL)isMark;

//- (void)unZipFile:(NSString *)zipFile
//       targetPath:(NSString *)targetPath
//        completed:(void (^)(bool result,NSError *error))completedBlock;



/**
 *  校验对象是否为空
 *
 *  @param object
 *
 *  @return
 */
- (BOOL)isNUll:(id)object;
- (BOOL)isBlankOrNull:(id)object;
- (BOOL)isWebUrl:(NSString *)str;
/**
 *  手机号码校验
 *
 *  @param mobileNum
 *
 *  @return
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  短信验证码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL)validateVerifyCode:(NSString *)str;
/**
 *  用户名校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserName:(NSString *)str;
/**
 *  密码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserPassword:(NSString *) str;
/**
 *  生日日期校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserBirthday:(NSString *)str;
/**
 *  手机号码校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserPhone:(NSString *)str;
/**
 *  邮箱校验
 *
 *  @param str
 *
 *  @return
 */
- (BOOL) validateUserEmail:(NSString *)str;


- (BOOL)isCurrentMonth:(NSTimeInterval)time;
- (BOOL)stringContainsEmoji:(NSString *)string;
/**
 *  时光UID反解为ID
 *
 *  @param timeid
 *
 *  @return
 */


#pragma mark -NSUInteger and CGFloat


/**
 *  计算带行间距的文本高度
 *
 *  @param text
 *  @param font
 *  @param width
 *  @param lineSpace
 *
 *  @return
 */
- (CGFloat)getHeightOfLabel:(NSString*)text
                       font:(UIFont*)font
                 labelWidth:(CGFloat)width
                  lineSpace:(CGFloat)lineSpace
                      lines:(NSInteger)lines;


/**
 *  获取书签
 *
 *  @param dataId
 *
 *  @return
 */
- (NSUInteger)getBookMark:(NSString *)dataId;

- (NSInteger)getStrLineNum:(NSString *)str lineNum:(int)lineNum;

- (NSInteger)charNumber:(NSString*)strtemp;


/**
 *  获取图片质量限制
 *
 *  @return
 */
- (CGFloat)getPhotoQuality;

/**
 *  计算字符串的字节数
 *
 *  @param string
 *
 *  @return
 */
-(NSUInteger) unicodeLengthOfString:(NSString *)string;

- (NSInteger)decodeTimeUID:(NSString *)timeid;

- (NSDate *)getDateByTimeInterval:(NSTimeInterval)timeInterval;


@end
