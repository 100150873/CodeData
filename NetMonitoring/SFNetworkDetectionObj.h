//
//  SFNetworkDetectionObj.h
//  NIM
//
//  Created by gzc on 2019/4/9.
//  Copyright © 2019 YzChina. All rights reserved.
//  网络检测上传自定义消息对象

#import <Foundation/Foundation.h>

@interface SFNetworkDetectionObj : NSObject<NIMCustomAttachment>

@property (nonatomic, copy) NSString *detectionfile;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *consumingtime;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
