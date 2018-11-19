//
//  NSString+Extension.h
//  PJCLitterCost
//
//  Created by yixin on 17/4/8.
//  Copyright © 2017年 ham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


/**
 *  判断字符串是否为空
 *
 *  @return  nil, @"", @"  ", @"\n"返回NO；其余的返回YES
 */
- (BOOL)noEmpty;

/**
 *  判断是否为整型
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isInteger;

/**
 *  判断是否为浮点型
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isFloat;

/**
 *  判断是否有特殊字符
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isHasSpecialcharacters;

/**
 *  判断是否含有数字
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isHasNumder;

/**
 根据字体大小获得对应的宽度
 @param font 字体大小
 @return 获取相应字符串的宽度
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
  根据字体大小获得对应的高度

 @param font 字体大小
 @param width 固定区域的宽度
 @return 对应的高度
 */
- (CGFloat)heightForFont:(UIFont *)font
                width:(CGFloat)width;

- (CGSize)getNSStringSizeWithLimitSize:(CGSize)limitSize
                              fontSize:(UIFont *)font;

/**
 网络参数的加密

 @return 加密后的字符串
 */
- (NSString *)base64EncodedString;

/**
 银行卡号有效性
 */
- (BOOL)jk_bankCardluhmCheck;

//精确的身份证号码有效性检测
+ (BOOL)jk_accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  手机号有效性
 */
- (BOOL)jk_isMobileNumber;

/**
 *  @brief  JSON字符串转成NSDictionary
 *
 *  @return NSDictionary
 */
-(NSDictionary *)jk_dictionaryValue;

#pragma mark - 时间字符串处理
///=============================================================================
/// @name NSDate
///=============================================================================

/**
 *  秒级时间戳转日期
 *
 *  @return 日期
 */
- (NSDate *)dateValueWithTimeIntervalSince1970;

/**
 *  毫秒级时间戳转日期
 *
 *  @return 日期
 */
- (NSDate *)dateValueWithMillisecondsSince1970;

/**
 *  时间戳转格式化的时间字符串
 *
 *  @param formatString 时间格式
 *
 *  @return 格式化的时间字符串
 */
- (instancetype)timestampToTimeStringWithFormatString:(NSString *)formatString;
@end
