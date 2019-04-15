//
//  SFDetectNetworkManager.h
//  NIM
//
//  Created by gzc on 2019/4/1.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFDetectNetworkManager : NSObject

/**
 手动检测网络环境

 @param finishCallBack 检测完成的回调
 */
+ (void)manualDetectNetworkWithFinishCallBack:(dispatch_block_t)finishCallBack;


/**
 消息指令检测网络环境

 @param downloadUrl 下载地址
 @param downloadTime 下载时间
 @param finishCallBack 检测完成的回调
 */
+ (void)orderDetectNetworkWithDownloadUrl:(NSString *)downloadUrl
                             downloadTime:(NSInteger)downloadTime
                           finishCallBack:(dispatch_block_t)finishCallBack;

@end
