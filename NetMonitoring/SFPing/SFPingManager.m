//
//  SFPingManager.m
//  SFPingDemo
//
//  Created by minihao on 2019/1/4.
//  Copyright © 2019 minihao. All rights reserved.
//

#import "SFPingManager.h"

@interface SFAddressItem ()
@property (nonatomic, copy, readwrite) NSString *hostName;
@property (nonatomic, copy, readwrite) NSString *ipAddress;
@property (nonatomic, assign, readwrite) double averageDelaySeconds;
@property (nonatomic, assign, readwrite) double maxDelaySeconds;
@property (nonatomic, assign, readwrite) double minDelaySeconds;
@property (nonatomic, assign, readwrite) double lossPercent;
@end

@implementation SFAddressItem

- (instancetype)initWithHostName:(NSString *)hostName ipAddress:(NSString *)ipAddress
{
    if (self = [super init]) {
        self.hostName = hostName;
        self.delayTimes = [NSMutableArray array];
        self.ipAddress = ipAddress;
    }
    return self;
}

- (double)maxDelaySeconds
{
    double maxTime = 0;
    if (self.delayTimes.count) {
        for (NSNumber *delayTime in self.delayTimes) {
            if (delayTime.doubleValue) {
                maxTime = MAX(maxTime, delayTime.doubleValue);
            }
        }
    }
    return maxTime;
}

- (double)minDelaySeconds
{
    double minTime = 0;
    if (self.delayTimes.count) {
        minTime = [self.delayTimes.firstObject doubleValue];
        for (NSNumber *delayTime in self.delayTimes) {
            if (delayTime.doubleValue) {
                minTime = MIN(minTime, delayTime.doubleValue);
            }
        }
    }
    return minTime;
}

- (double)averageDelaySeconds
{
    if (self.delayTimes.count) {
        double allDelayTime = 0;
        for (NSNumber *delayTime in self.delayTimes) {
            allDelayTime += delayTime.doubleValue;
        }
        return allDelayTime / self.delayTimes.count;
    }
    return 1000.0;
}

- (double)lossPercent
{
    if (self.delayTimes.count) {
        return (self.totalPingCount - self.delayTimes.count) / MAX(1.0, self.totalPingCount) * 100;
    }
    return 1;
}

@end

@interface SFPingManager ()
@property (nonatomic, strong) NSMutableArray *singlePingerArray;
@end

@implementation SFPingManager

- (void)getFatestAddress:(NSArray *)addressList count:(NSInteger)count completionHandler:(CompletionHandler)completionHandler
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (addressList.count == 0) {
            NSLog(@"addressList can't be empty");
            return;
        }
        NSMutableArray *singlePingerArray = [NSMutableArray array];
        self.singlePingerArray = singlePingerArray;
        NSMutableArray *needRemoveAddressArray = [NSMutableArray array];
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        for (NSString *address in addressList) {
            [resultDict setObject:[NSNull null] forKey:address];
        }
        dispatch_group_t group = dispatch_group_create();
        
        for (NSString *address in addressList) {
            dispatch_group_enter(group);
            SFSinglePinger *singlePinger = [SFSinglePinger startWithHostName:address count:count pingCallBack:^(SFPingItem *pingitem) {
                switch (pingitem.status) {
                    case SFSinglePingStatusDidStart:
                        break;
                    case SFSinglePingStatusDidFailToSendPacket:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        break;
                    }
                    case SFSinglePingStatusDidReceivePacket:
                    {
                        SFAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        
                        if ([item isEqual:[NSNull null]]) {
                            item = [[SFAddressItem alloc] initWithHostName:pingitem.hostName ipAddress:pingitem.ipAddress];
                        }
                        item.totalPingCount = count;
                        item.ipAddress = pingitem.ipAddress;
                        [item.delayTimes addObject:@(pingitem.millSecondsDelay)];
                        [resultDict setObject:item forKey:pingitem.hostName];
                        if (![resultArray containsObject:item]) {
                            [resultArray addObject:item];
                        }
                        break;
                    }
                    case SFSinglePingStatusDidReceiveUnexpectedPacket:
                        break;
                    case SFSinglePingStatusDidTimeOut:
                    {//丢包了
                        // 超时按1s计算
                        SFAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        if ([item isEqual:[NSNull null]]) {
                            item = [[SFAddressItem alloc] initWithHostName:pingitem.hostName ipAddress:pingitem.ipAddress];
                        }
                        NSLog(@"超时了");
//                        item.ipAddress = pingitem.ipAddress;
//                        [item.delayTimes addObject:@(1000.0)];
//                        [resultDict setObject:item forKey:pingitem.hostName];
//                        if (![resultArray containsObject:item]) {
//                            [resultArray addObject:item];
//                        }
                        break;
                    }
                    case SFSinglePingStatusDidError:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        dispatch_group_leave(group);
                        break;
                    }
                    case SFSinglePingStatusDidFinished:
                    {
                        NSLog(@"%@ 完成",pingitem.hostName);
                        dispatch_group_leave(group);
                        break;
                    }
                    default:
                        break;
                }
            }];
            [singlePingerArray addObject:singlePinger];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"计算延迟");
            for (SFAddressItem *item in resultArray) {//更保险
                if ( (item.delayTimes.count == 0 && ![needRemoveAddressArray containsObject:item.hostName]) ||
                    item.averageDelaySeconds == 0) {
                    [needRemoveAddressArray addObject:item.hostName];
                }
            }
            
            for (NSString *removeHostName in needRemoveAddressArray) {
                [resultArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.hostName != %@",removeHostName]];
            }
            
            if (resultArray.count == 0) {
                completionHandler(nil,needRemoveAddressArray);
                return;
            }
            
//            [resultArray sortUsingComparator:^NSComparisonResult(SFAddressItem * item1, SFAddressItem * item2) {
//                return item1.averageDelaySeconds > item2.averageDelaySeconds;
//            }];
            
            NSMutableArray *array = [NSMutableArray array];
            for (SFAddressItem *item in resultArray) {
                [array addObject:item.hostName];
                NSLog(@"\nIP地址  %@ %@  \n最大时间  %.2fms 最小%.2fms 平均%.2fms \n丢包率 : %.3f%% 收到包的个数 %ld",item.ipAddress,item.hostName,item.maxDelaySeconds,item.minDelaySeconds,item.averageDelaySeconds,item.lossPercent,item.delayTimes.count);
            }
            
//            if (needRemoveAddressArray.count) {
//                 NSLog(@"失败的域名 == %@",needRemoveAddressArray);
//            }
            
            
            
//            SFAddressItem *item = resultArray.firstObject;
//            NSLog(@"最快的地址速度是: %.2f ms",item.averageDelaySeconds);
            
            completionHandler(resultArray, needRemoveAddressArray);
        });
    }];
}

@end
