//
//  NSNumber+Addtions.h
//  YunTShop
//
//  Created by sfgod on 16/6/20.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(Addtions)


/**
 *  获取时间字符串
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)getDateStringByFormat:(NSString *)format;

@end
