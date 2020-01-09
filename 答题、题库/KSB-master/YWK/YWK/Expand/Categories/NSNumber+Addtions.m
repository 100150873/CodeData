//
//  NSNumber+Addtions.m
//  YunTShop
//
//  Created by sfgod on 16/6/20.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "NSNumber+Addtions.h"

@implementation NSNumber(Addtions)


/**
 *  获取时间字符串
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)getDateStringByFormat:(NSString *)format{
    
    if (format) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:format];
        NSDate *creat = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
        return [dateformatter stringFromDate:creat];
    }else{
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSInteger mis = now - self.integerValue;
        if (mis < 60) {
            return @"刚刚";
        }else if (mis < 3600) {
            return [NSString stringWithFormat:@"%li分钟前",mis/60];
        }else if (mis < 43200){
            return [NSString stringWithFormat:@"%li小时前",mis/3600];
        }else {
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *creat = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
            return [dateformatter stringFromDate:creat];
        }
    }
    
}

@end
