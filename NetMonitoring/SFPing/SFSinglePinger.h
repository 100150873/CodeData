//
//  SFSinglePinger.h
//  SFPingDemo
//
//  Created by minihao on 2019/1/4.
//  Copyright © 2019 minihao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFPingItem;
typedef void(^PingCallBack)(SFPingItem *pingitem);

typedef NS_ENUM(NSUInteger, SFSinglePingStatus) {
    SFSinglePingStatusDidStart,
    SFSinglePingStatusDidFailToSendPacket,
    SFSinglePingStatusDidReceivePacket,
    SFSinglePingStatusDidReceiveUnexpectedPacket,
    SFSinglePingStatusDidTimeOut,
    SFSinglePingStatusDidError,
    SFSinglePingStatusDidFinished,
};

@interface SFPingItem : NSObject
/// 主机名
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *ipAddress;
/// 单次耗时
@property (nonatomic, assign) double millSecondsDelay;
/// 当前ping状态
@property (nonatomic, assign) SFSinglePingStatus status;

@end

@interface SFSinglePinger : NSObject

+ (instancetype)startWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

@end


