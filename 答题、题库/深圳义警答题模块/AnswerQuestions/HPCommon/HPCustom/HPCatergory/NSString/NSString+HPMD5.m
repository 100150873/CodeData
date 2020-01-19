//
//  NSString+MD5.m
//  PKWSevers
//
//  Created by peikua on 16/4/27.
//  Copyright © 2016年 peikua. All rights reserved.
//

#import "NSString+HPMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HPMD5)

- (NSString *) md5WithString
{
    if (self==nil || [self length]==0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count=0; count<CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

@end
