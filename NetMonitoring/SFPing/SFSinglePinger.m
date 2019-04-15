//
//  SFSinglePinger.m
//  SFPingDemo
//
//  Created by minihao on 2019/1/4.
//  Copyright © 2019 minihao. All rights reserved.
//

#import "SFSinglePinger.h"
#import "SimplePing.h"

@implementation SFPingItem

@end

@interface SFSinglePinger () <SimplePingDelegate>

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, strong) SimplePing *pinger;
@property (nonatomic, strong) NSTimer *sendTimer;
/// packet send time array
@property (nonatomic, strong) NSMutableArray <NSDate *>*startDateArray;
/// index of packet send time array
@property (nonatomic, assign) NSInteger dateSendIndex;
@property (nonatomic, copy) PingCallBack pingCallBack;
/// send times
@property (nonatomic, assign) NSInteger count;
/// need ping count
@property (nonatomic, assign) NSInteger needPingCount;
/// receive packets or delay perform count
@property (nonatomic, assign) NSInteger receivedOrDelayCount;

@end

@implementation SFSinglePinger

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack
{
    if (self = [super init]) {
        self.hostName = hostName;
        self.count = count;
        self.needPingCount = count;
        self.startDateArray = [NSMutableArray array];
        self.pingCallBack = pingCallBack;
        self.pinger = [[SimplePing alloc] initWithHostName:hostName];
        self.pinger.addressStyle = SimplePingAddressStyleAny;
        self.pinger.delegate = self;
        [self.pinger start];
    }
    return self;
}

+ (instancetype)startWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack
{
    return [[self alloc] initWithHostName:hostName count:count pingCallBack:pingCallBack];
}

#pragma mark - Private Methods
/// stop ping service
- (void)stop
{
    NSLog(@"%@ stop",self.hostName);
    [self cleanWithStatus:SFSinglePingStatusDidFinished];
}

/// ping delay
- (void)timeOutDelay
{
    if (self.sendTimer) {
        NSLog(@"丢包了 %@ timeout nextSequenceNumber = %d",self.hostName,self.pinger.nextSequenceNumber);
        self.receivedOrDelayCount++;
        SFPingItem *pingItem = [[SFPingItem alloc] init];
        pingItem.hostName = self.hostName;
        pingItem.status = SFSinglePingStatusDidTimeOut;
        self.pingCallBack(pingItem);
        if (self.receivedOrDelayCount == self.needPingCount) {
            [self stop];
        }
    }
}

/// ping failure
- (void)fail
{
//    NSLog(@"%@ fail",self.hostName);
    [self cleanWithStatus:SFSinglePingStatusDidError];
}

- (void)cleanWithStatus:(SFSinglePingStatus)status
{
    SFPingItem *pingItem = [[SFPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.status = status;
    self.pingCallBack(pingItem);
    
    [self.pinger stop];
    self.pinger = nil;
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    [self cancelRunLoopPerformTimeOut];
    
    self.hostName = nil;
    [self.startDateArray removeAllObjects];
    self.pingCallBack = nil;
}


#pragma mark - Ping Delegate
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    NSLog(@"start ping %@",self.hostName);
    [self sendPing];
    NSAssert(self.sendTimer == nil, @"timer can't be nil");
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.sendTimer forMode:NSDefaultRunLoopMode];
    
    SFPingItem *pingItem = [[SFPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.ipAddress = pinger.IPAddress;
    pingItem.status = SFSinglePingStatusDidStart;
    self.pingCallBack(pingItem);
}

- (void)sendPing
{
    if (self.count < 1) {
        return;
    }
    self.count --;
    [self.startDateArray addObject:[NSDate date]];
    [self performSelector:@selector(timeOutDelay) withObject:@(self.pinger.nextSequenceNumber) afterDelay:1.0];
    [self.pinger sendPingWithData:nil];
}

- (void)cancelRunLoopPerformTimeOut
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; //这个是取消当前run loop 里面所有未执行的 延迟方法
    NSLog(@"失败%@ %@",self.hostName, error.localizedDescription);
    [self fail];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"%@ %hu send packet success",self.hostName, sequenceNumber);
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    NSLog(@"发不出去");
    NSLog(@"%@ %hu send packet failed: %@",self.hostName, sequenceNumber, error.localizedDescription);
    [self cleanWithStatus:SFSinglePingStatusDidFailToSendPacket];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutDelay) object:@(sequenceNumber)];
    double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:self.startDateArray[self.dateSendIndex]] * 1000;//毫秒
    self.dateSendIndex++;
    self.receivedOrDelayCount++;
    NSLog(@"%@ %hu received, size=%lu time=%.2fms",self.hostName, sequenceNumber, (unsigned long)packet.length, millSecondsDelay);
    SFPingItem *pingItem = [[SFPingItem alloc] init];
    pingItem.hostName = self.hostName;
    pingItem.ipAddress = pinger.IPAddress;
    pingItem.status = SFSinglePingStatusDidReceivePacket;
    pingItem.millSecondsDelay = millSecondsDelay;
    self.pingCallBack(pingItem);
    
    if (self.receivedOrDelayCount == self.needPingCount) {
        [self stop];
    }
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
}

@end
