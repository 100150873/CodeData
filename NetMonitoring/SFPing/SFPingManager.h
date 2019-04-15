//
//  SFPingManager.h
//  SFPingDemo
//
//  Created by minihao on 2019/1/4.
//  Copyright © 2019 minihao. All rights reserved.
//

#import "SFSinglePinger.h"

@interface SFAddressItem : NSObject

@property (nonatomic, assign, readwrite) NSInteger totalPingCount;
@property (nonatomic, copy, readonly) NSString *hostName;
/// average delay time
@property (nonatomic, assign, readonly) double averageDelaySeconds;
@property (nonatomic, assign, readonly) double maxDelaySeconds;
@property (nonatomic, assign, readonly) double minDelaySeconds;
@property (nonatomic, assign, readonly) double lossPercent;
@property (nonatomic, copy, readonly) NSString *ipAddress;
@property (nonatomic, strong) NSMutableArray *delayTimes;

- (instancetype)initWithHostName:(NSString *)hostName ipAddress:(NSString *)ipAddress;

@end

typedef void(^CompletionHandler)(NSArray <SFAddressItem *>*successArray, NSArray <NSString *>*failArray);

NS_ASSUME_NONNULL_BEGIN

@interface SFPingManager : NSObject

- (void)getFatestAddress:(NSArray *)addressList
                   count:(NSInteger)count
       completionHandler:(CompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
