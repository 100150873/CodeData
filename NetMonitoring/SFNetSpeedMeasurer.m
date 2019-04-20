//
//  SFNetSpeedMeasurer.m
//  NIM
//
//  Created by gzc on 2019/4/10.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFNetSpeedMeasurer.h"

@interface SFNetSpeedMeasurer ()<NSURLSessionDownloadDelegate>

@property (nonatomic, copy) EndBlock endBlock;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) BOOL downloadAll;

@property (nonatomic, assign) int64_t oneMillBytes;
@property (nonatomic, assign) int64_t totalBytes;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) int64_t minSpeed;
@property (nonatomic, assign) int64_t maxSpeed;
@property (nonatomic, assign) int64_t avgSpeed;

@end

@implementation SFNetSpeedMeasurer

/**
 下载URL文件测速
 
 @param url 文件地址
 @param time 测速时间
 @param endBlock 测速结束的回调
 */
- (void)measurerNetSpeedWithUrl:(NSString *)url
                           time:(NSInteger)time
                       endBlock:(EndBlock)endBlock {
    NSURL* downloadUrl = [NSURL URLWithString:url];
    if (!url) {
        DDLogInfo(@"无效的下载URL");
        return;
    }
    if (time < 1) {
        return;
    }
    self.endBlock = endBlock;
    
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:downloadUrl];
    [downloadTask resume];
    self.time = time;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLogInfo(@"测速时间截止");
        [self measurerSpeedEnd];
    });
}

- (void)countTime {
    ++self.second;
    if (self.second > self.time) {
        [self measurerSpeedEnd];
        return;
    }
    [self calculateSpeed];
    //清空数据
    self.oneMillBytes = 0;
}

/**
 测速
 */
- (void)calculateSpeed {
    int64_t speed = self.oneMillBytes;
    if (self.minSpeed == 0 && speed) {
        self.minSpeed = speed;
    } else {
        self.minSpeed = MIN(speed, self.minSpeed);
    }
    self.maxSpeed = MAX(self.maxSpeed, speed);
}

- (void)stopMeasurer {
    [self measurerSpeedEnd];
}

- (void)measurerSpeedEnd {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!self.downloadAll) {
        [self.session invalidateAndCancel];
    }
    
    if (self.endBlock) {
        if (self.totalBytes && self.time) {
            self.avgSpeed = self.totalBytes / self.time;
            self.totalBytes = 0;
            DDLogInfo(@"最小速度 = %lld 最大速度 = %lld 平均速度 = %lld",self.minSpeed,self.maxSpeed,self.avgSpeed);
        }
        self.endBlock(self.minSpeed,self.maxSpeed,self.avgSpeed);
        self.endBlock = nil;
    }
}


#pragma mark -- NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didFinishDownloadingToURL:(NSURL*)location {
    DDLogInfo(@"下载完成");
    self.downloadAll = YES;
    [self measurerSpeedEnd];
}

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.oneMillBytes += bytesWritten;
    self.totalBytes = totalBytesWritten;
//    DDLogInfo(@"当前大小：%lld   已下载 ：%lld 总大小：%lld ",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
//    DDLogInfo(@"下载进度 ：%f ", progress);
}


#pragma mark - Getter

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

@end
