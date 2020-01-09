//
//  NSString+Addtions.h
//  YHFoundation
//
//  Created by Yhoon on 16/1/21.
//  Copyright © 2016年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, MD5EncryptType) {
    MD5EncryptType_16BitLower = 0,
    MD5EncryptType_16BitUpper,
    MD5EncryptType_32BitLower,
    MD5EncryptType_32BitUpper
};

@interface NSString (Addtions)

// 判断字符串是否为纯整数
+ (BOOL)isPureFloat:(NSString*)string;
// 判断字符串是否为纯整数
+ (BOOL)isPureInteger:(NSString*)string;

//得到json
+ (id)getJsonByString:(NSString *)string;

/**
 *  获取显示的价格 两位小数
 *
 *  @param price 价格
 *
 *  @return 两位小数的价格字段
 */
+ (NSString *)getPriceByPrice:(NSInteger)price;

/** 给七牛key添加七牛的头*/
- (NSURL *)getURLfromQiniuKey;

/** 根据行间距创建特性字符串*/
- (NSMutableAttributedString *)getAttributedStringWithLineSpacing:(CGFloat)space;

//- (NSMutableAttributedString *)getAttributedStringWith

/**
 *  MD5加密字符串
 *
 *  @param input 加密前输入字符串
 *  @param type  可选MD5加密方式
 *
 *  @return 加密后输入字符串
 */

+ (NSString *)getMD5Encrypt:(NSString *)input encryptType:(MD5EncryptType)type;

- (NSString *)getMD5With32BitUpperType;

/**
 *  时间戳转成字符串时间
 */
+ (NSString *)timeIntervalFromSamp:(NSTimeInterval)samp
                     timeFormatter:(NSString *)formater;

@end
