//
//  SFNetSpeedMeasurerManager.m
//  NIM
//
//  Created by gzc on 2019/4/10.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFNetSpeedMeasurerManager.h"

@interface SFNetSpeedMeasurerManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) SFNetSpeedMeasurer *netSpeedMeasurer;
@property (nonatomic, copy) dispatch_block_t endBlock;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) BOOL downloadAll;
@end

@implementation SFNetSpeedMeasurerManager

- (void)measurerNetSpeedWithUrl:(NSString *)url
                           time:(NSInteger)time
                  measurerBlock:(void (^)(SFNetMeasurerResult *result))measurerBlock
                    endBlock:(dispatch_block_t)endBlock
{
    NSURL* downloadUrl = [NSURL URLWithString:url];
    if (!url) {
        DDLogInfo(@"无效的下载URL");
        return;
    }
    if (time < 1) {
        return;
    }
    self.endBlock = endBlock;
    self.netSpeedMeasurer.measurerBlock = measurerBlock;
    [self.netSpeedMeasurer execute];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:downloadUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            DDLogInfo(@"下载失败 \n %@",error);
        }
    }];
    [downloadTask resume];
    self.session = session;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DDLogInfo(@"测速时间截止");
        [self measurerSpeedEnd];
    });
}

- (void)stopMeasurer
{
    [self measurerSpeedEnd];
}

- (void)measurerSpeedEnd
{
    if (!self.downloadAll) {
        [self.session invalidateAndCancel];
    }
    [self.netSpeedMeasurer shutdown];
    if (self.endBlock) {
        self.endBlock();
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
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    DDLogInfo(@"下载进度 ：%f ", progress);
}


#pragma mark - Getter

- (SFNetSpeedMeasurer *)netSpeedMeasurer {
    if (!_netSpeedMeasurer) {
        _netSpeedMeasurer = [[SFNetSpeedMeasurer alloc] initWithAccuracyLevel:5 interval:1.0];
    }
    return _netSpeedMeasurer;
}
@end
