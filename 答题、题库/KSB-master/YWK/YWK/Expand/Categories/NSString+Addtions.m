//
//  NSString+Addtions.m
//  YHFoundation
//
//  Created by Yhoon on 16/1/21.
//  Copyright © 2016年 yhoon. All rights reserved.
//

#import "NSString+Addtions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Addtions)

// 判断字符串是否为纯浮点数
+ (BOOL)isPureFloat:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

// 判断字符串是否为纯整数
+ (BOOL)isPureInteger:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}

//得到json
+ (id)getJsonByString:(NSString *)string{
    NSData *resData = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    id  resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    return resultDic;
}


/**
 *  获取显示的价格 两位小数
 *
 *  @param price 价格
 *
 *  @return 两位小数的价格字段
 */
+ (NSString *)getPriceByPrice:(NSInteger)price{
    CGFloat i = price/100.0;
    
    return [NSString stringWithFormat:@"¥%.2f",i];
}


- (NSURL *)getURLfromQiniuKey{
    if ([self hasPrefix:@"http://"]) {
        return [NSURL URLWithString:self];
    }
    return [NSURL URLWithString:[kImageHead stringByAppendingString:self]];
}

/** 根据行间距创建特性字符串*/
- (NSMutableAttributedString *)getAttributedStringWithLineSpacing:(CGFloat)space{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return str;
}

// MD5加密
+ (NSString *)getMD5Encrypt:(NSString *)input encryptType:(MD5EncryptType)type {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    NSString *output;
    switch (type) {
        case MD5EncryptType_16BitLower: {
            output = [[[result substringToIndex:24] substringFromIndex:8] copy];
            break;
        }
        case MD5EncryptType_16BitUpper: {
            output = [[[result substringToIndex:24] substringFromIndex:8] copy];
            output = [output uppercaseString];
            break;
        }
        case MD5EncryptType_32BitLower: {
            output = [result copy];
            break;
        }
        case MD5EncryptType_32BitUpper: {
            output = [[result copy] uppercaseString];
            break;
        }
    }
    return output;
    
}

- (NSString *)getMD5With32BitUpperType{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    NSString *output = [[result copy] uppercaseString];
    return output;
}

+ (NSString *)timeIntervalFromSamp:(NSTimeInterval)samp timeFormatter:(NSString *)formater {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formater;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:samp];
    return [dateFormatter stringFromDate:date];
}

@end
