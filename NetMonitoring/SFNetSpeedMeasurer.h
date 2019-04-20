//
//  SFNetSpeedMeasurer.h
//  NIM
//
//  Created by gzc on 2019/4/10.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EndBlock)(int64_t minSpeed,int64_t maxSpeed,int64_t avgSpeed);

@interface SFNetSpeedMeasurer : NSObject

/**
 下载URL文件测速

 @param url 文件地址
 @param time 测速时间
 @param endBlock 测速结束的回调
 */
- (void)measurerNetSpeedWithUrl:(NSString *)url
                           time:(NSInteger)time
                       endBlock:(EndBlock)endBlock;

/**
 停止测速
 */
- (void)stopMeasurer;

@end
