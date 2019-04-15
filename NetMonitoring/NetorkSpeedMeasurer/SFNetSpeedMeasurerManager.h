//
//  SFNetSpeedMeasurerManager.h
//  NIM
//
//  Created by gzc on 2019/4/10.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNetSpeedMeasurer.h"

@interface SFNetSpeedMeasurerManager : NSObject

/**
 下载URL文件测速

 @param url 文件地址
 @param time 测速时间
 @param measurerBlock 实时测速的回调
 @param endBlock 测速结束的回调
 */
- (void)measurerNetSpeedWithUrl:(NSString *)url
                           time:(NSInteger)time
                  measurerBlock:(void (^)(SFNetMeasurerResult *result))measurerBlock
                       endBlock:(dispatch_block_t)endBlock;

/**
 停止测速
 */
- (void)stopMeasurer;

@end
