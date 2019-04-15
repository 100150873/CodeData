//
//  SFDetectNetworkManager.m
//  NIM
//
//  Created by gzc on 2019/4/1.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFDetectNetworkManager.h"

#import "SFNetworkInformation.h"
#import "SFNetAddress.h"
#import "SFLoginMiddleWare.h"
#import "SFPingManager.h"
#import "SFIMMediator+AESModuleMediator.h"
#import "SFNetSpeedMeasurerManager.h"
#import "SFNetSpeedMeasurer.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface SFDetectNetworkManager ()

@property (nonatomic, strong) SFPingManager *pingManager;
@property (nonatomic, strong) SFNetSpeedMeasurerManager *netSpeedMeasurerManager;
/**
 是否检测超时
 */
@property (nonatomic, assign) BOOL isTimeOut;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, assign) NSInteger downloadTime;
@property (nonatomic, strong) NSDate *costTime;
@property (nonatomic, strong) NSArray *domainArray;
@property (nonatomic, copy) NSString *maxSpeed;
@property (nonatomic, copy) NSString *minSpeed;
@property (nonatomic, copy) NSString *avgSpeed;
@property (nonatomic, copy) NSString *detectNetworkPath;
@property (nonatomic, assign) NETWORK_TYPE currentNetType;
@property (nonatomic, copy) dispatch_block_t measurerSpeedFinishCallBack;
@property (nonatomic, copy) dispatch_block_t detectNetworkFinishCallBack;
@property (nonatomic, strong) NSMutableArray *arrayDetectData;
@property (nonatomic, strong) NSMutableString *stringPing;
@property (nonatomic, strong) NSMutableString *stringPraseDns;
@property (nonatomic, strong) NSMutableString *stringMeasurerSpeed;
@property (nonatomic, strong) NSMutableString *stringNetworkInfo;

@end

@implementation SFDetectNetworkManager

- (void)detectNetworkWithFinishCallBack:(dispatch_block_t)finishCallBack
{
    self.costTime = [NSDate date];
    self.isTimeOut = YES;
    self.detectNetworkFinishCallBack = finishCallBack;
    //检测网络环境信息
    [self fetchLocalNetEnvironment];
    if (self.currentNetType == 0) {
        if (finishCallBack) {
            finishCallBack();
        }
        [SFIMHUD showToastMessage:@"没有网络"];
        return;
    }
    [self.arrayDetectData sfim_safeAddObject:self.stringNetworkInfo];
    
    //ping
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self pingWithFinishCallBack:^{
        [self.arrayDetectData sfim_safeAddObject:self.stringPing];
        dispatch_group_leave(group);
    }];
    
    //DNS解析
    dispatch_group_enter(group);
    [self praseDnsWithFinishCallBack:^{
        [self.arrayDetectData sfim_safeAddObject:self.stringPraseDns];
        dispatch_group_leave(group);
    }];
    
    //测速
    dispatch_group_enter(group);
    [self fetchDownloadConfigRequestWithCallBack:^{//获取下载文件的地址和下载时间
        [self networkSpeedMeasurerWithFinishCallBack:^{//开始下载测速
            [self.arrayDetectData sfim_safeAddObject:self.stringMeasurerSpeed];
            dispatch_group_leave(group);
        }];
    }];
    
    //上传日志文件
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (self.detectNetworkFinishCallBack && self.isTimeOut) {
            self.isTimeOut = NO;
            [self handleNetworkDetectionLogData];
        }
    });
    
    //检测超时异常处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//检测超时处理
        if (self.isTimeOut) {//超时了
            if (self.detectNetworkFinishCallBack) {
                self.detectNetworkFinishCallBack();
                self.detectNetworkFinishCallBack = nil;
            }
        }
    });
}


+ (void)manualDetectNetworkWithFinishCallBack:(dispatch_block_t)finishCallBack
{
    
    SFDetectNetworkManager *manager = [[SFDetectNetworkManager alloc] init];
    [manager detectNetworkWithFinishCallBack:finishCallBack];
}


+ (void)orderDetectNetworkWithDownloadUrl:(NSString *)downloadUrl
                             downloadTime:(NSInteger)downloadTime
                           finishCallBack:(dispatch_block_t)finishCallBack
{
    if (downloadUrl.length && downloadTime) {
        SFDetectNetworkManager *manager = [[SFDetectNetworkManager alloc] init];
        manager.downloadTime = downloadTime;
        manager.downloadUrl = downloadUrl;
        [manager detectNetworkWithFinishCallBack:finishCallBack];
    } else {//参数错误
        [SFIMHUD showError:NSLocalizedString(@"parameter_error", @"")];
    }
}


- (void)handleNetworkDetectionLogData
{
    if (self.arrayDetectData.count) {
        NSString *date = [[NSDate date] sfim_stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSMutableString *stringResult = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@: 网络检测 \n",date]];
        for (NSMutableString *string in self.arrayDetectData) {
            [stringResult appendString:[NSString stringWithFormat:@"\n%@",string]];
        }
        //整个过程总共耗时
        double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:self.costTime];//秒
        [stringResult appendString:[NSString stringWithFormat:@"\n\n全部总耗时 = %.2fs",millSecondsDelay]];
        NSLog(@"全部总耗时 = %.2fs",millSecondsDelay);
        
        NSString *aesDataStr = [[SFIMMediator sharedInstance] sfim_aes128MediatorEntryWithStr:stringResult];
        NSData *data =[aesDataStr dataUsingEncoding:NSUTF8StringEncoding];
        if ([data writeToFile:self.detectNetworkPath atomically:YES]) {//保存网络检测日志到本地沙盒文件
            //上传网易云后台
            [[NIMSDK sharedSDK].resourceManager upload:self.detectNetworkPath progress:^(float progress) {
                
            } completion:^(NSString * _Nullable urlString, NSError * _Nullable error) {
                if (!error && urlString) {
                    DDLogInfo(@"网络检测日志上传网易云成功   === %@",urlString);
                    [self uploadNetworkDetectionLogWithUrl:urlString finishCallBack:^{
                        DDLogInfo(@"网络检测日志上传丰声后台成功");
                        if (self.detectNetworkFinishCallBack) {
                            self.detectNetworkFinishCallBack();
                            self.detectNetworkFinishCallBack = nil;
                        }
                    }];
                }
            }];
        }
    }
}

- (NSMutableDictionary *)appendAppKeyAndSecret:(NSDictionary *)params {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result sfim_safeSetObject:[SFLoginMiddleWare currentUserIdStr] forKey:@"account"];
    [result sfim_safeSetObject:@"IOS" forKey:@"platform"];
    NSDictionary *dict = @{
                           @"appsecret" : @"63560b42e510",
                           @"appkey" : @"d0f0e645a710e919901fda410b7df7ea"
                           };
    [result addEntriesFromDictionary:dict];
    if (params) {
        [result addEntriesFromDictionary:params];
    }
    return result;
}


#pragma mark - Network Request

/**
 上传网络检测日志log到丰声nos后台

 @param url log文件的URL
 @param finishCallBack 上传成功后回调
 */
- (void)uploadNetworkDetectionLogWithUrl:(NSString *)url finishCallBack:(dispatch_block_t)finishCallBack
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict sfim_safeSetObject:url forKey:@"detectionLogFile"];
    [self detectNetworkWithParams:paramDict callBack:^(NSDictionary *responeDic) {
        if ([[responeDic sfim_safeObjectForKey:@"msgCode"] isEqualToString:@"200"]) {
            if (finishCallBack) {
                finishCallBack();
            }
        } else {
            [SFIMHUD showError:[responeDic sfim_safeObjectForKey:@"msgString"]];
        }
    }];
}

/**
 获取下载的配置
 */
- (void)fetchDownloadConfigRequestWithCallBack:(dispatch_block_t)callBack
{
    if (self.downloadTime && self.downloadUrl.length) {
        if (callBack) {
            callBack();
        }
        return;
    }
    
    [self detectNetworkWithParams:nil callBack:^(NSDictionary *responeDic) {
        
        NSDictionary *dicBody = [responeDic sfim_safeObjectForKey:@"body"];
        if (dicBody && [dicBody isKindOfClass:[NSDictionary class]]) {
            self.downloadUrl = [dicBody sfim_safeObjectForKey:@"detectionFile"];
            self.downloadTime = [[dicBody sfim_safeObjectForKey:@"time"] integerValue];
            if (callBack) {
                callBack();
            }
        }
    }];
   
}


- (void)detectNetworkWithParams:(NSDictionary *)params callBack:(void (^)(NSDictionary *responeDic) )callBack
{
    SFIMHTTPRequestOption *option = [SFIMHTTPRequestOption defaultOption];
    option.requestType = SFIMHTTPRequestTypeForm;
    
    [[SFIMHTTPRequestCenter defaultCenter] POST:SF_NETWORK_MONITOR_URL
                                     parameters:[self appendAppKeyAndSecret:params]
                                         option:option
                                        handler:^(SFIMHTTPRequest *request, SFIMHTTPResponse *response) {
                                            
                                            DDLogInfo(@"网络监控配置信息 :\n 请求地址: %@\n 参数: %@\n 接口返回: %@\n error: %@\n", request.url,
                                                      request.parameters, response.responeData, response.error);
                                            
                                            if (!response.error) {
                                                NSError *error = [self p_errorWithResponse:response.responeData];
                                                if (error) {
                                                    [SFIMHUD showError:NSLocalizedString(@"Task_dataWrong", @"")];
                                                } else {
                                                    if (callBack) {
                                                        callBack((NSDictionary *) response.responeData);
                                                    }
                                                }
                                            } else {
                                                [SFIMHUD showError:NSLocalizedString(@"Task_dataWrong", @"")];
                                            }
                                        }];
}




- (NSError*)p_errorWithResponse:(NSDictionary*)response{
    NSString* errorInfo = @"";
    if (![response isKindOfClass:NSDictionary.class]) {
        // 不是字典 直接返回
        errorInfo = NSLocalizedString(@"Task_dataWrong", @"");
        NSError *error = [self p_errorWithInfo:errorInfo];
        return error;
    }
    NSString* result = response[@"msgCode"];
    // 返回成功
    if (result && [result isKindOfClass:NSString.class] && [result isEqualToString:@"200"]) {
        return nil;
    }
    NSString *msg = response[@"msgString"]; // 若失败时读取这个字段得知失败原因
    msg = msg?msg:NSLocalizedString(@"数据结构不正确", @"");
    NSError *error = [self p_errorWithInfo:msg];
    return error;
}

/**
 *  用给定的info构造一个错误，info会置为NSLocalizedDescriptionKey对应的值
 *
 *  @param errorInfo 指定的错误提示;若传空，则当成“未知错误”
 *
 *  @return 一个NSError对象
 */
- (NSError*)p_errorWithInfo:(NSString*)errorInfo{
    errorInfo = errorInfo ? errorInfo : NSLocalizedString(@"Task_unknownWrong", @"");
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errorInfo};
    NSError* error = [NSError errorWithDomain:@"SFNetworkDetect" code:777 userInfo:userInfo];
    return error;
}


#pragma mark - ping

- (void)pingWithFinishCallBack:(dispatch_block_t)finishCallBack
{
    self.pingManager = [[SFPingManager alloc] init];
    NSDate  *pingDate = [NSDate date];
    NSInteger pingCount = 10;
    [self.pingManager getFatestAddress:self.domainArray count:pingCount completionHandler:^(NSArray<SFAddressItem *> *successArray, NSArray <NSString *>*failArray) {
        for (SFAddressItem *item in successArray) {
            NSMutableDictionary *dicItem = [[NSMutableDictionary alloc] init];
            [dicItem sfim_safeSetObject:item.hostName forKey:@"domain"];
            [dicItem sfim_safeSetObject:item.ipAddress forKey:@"ip"];
            [dicItem sfim_safeSetObject:@(item.totalPingCount) forKey:@"sentPackets"];
            [dicItem sfim_safeSetObject:@(item.delayTimes.count) forKey:@"receivedPackets"];
            [dicItem sfim_safeSetObject:[NSString stringWithFormat:@"%.2f",item.averageDelaySeconds] forKey:@"avgDelay"];
            [dicItem sfim_safeSetObject:[NSString stringWithFormat:@"%.2f",item.minDelaySeconds] forKey:@"minDelay"];
            [dicItem sfim_safeSetObject:[NSString stringWithFormat:@"%.2f",item.maxDelaySeconds] forKey:@"maxDelay"];
            NSString *stringItem = [dicItem yy_modelToJSONString];
            [self.stringPing appendString:[NSString stringWithFormat:@"%@\n",stringItem]];
        }
        
        if (failArray.count) {
            [self.stringPing appendString:@"ping失败的域名：\n"];
            for (NSString *domain in failArray) {
                [self.stringPing appendString:[NSString stringWithFormat:@"%@\n",domain]];
            }
        }
        
        double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:pingDate];//秒
        NSLog(@"ping == 总耗时%.2fs",millSecondsDelay);
        [self.stringPing appendString:[NSString stringWithFormat:@"ping总耗时：%.2fs\n",millSecondsDelay]];
        DDLogInfo(@"ping的结果 \n%@",self.stringPing);
        if (finishCallBack) {
            finishCallBack();
        }
    }];
}


#pragma mark - 当前网络环境

/**
 获取本地网络信息
 */
- (void)fetchLocalNetEnvironment
{
    
    NSString *networkType = @"";
    NSMutableDictionary *netDetail = [[NSMutableDictionary alloc] init];
    //判断是否联网以及获取网络类型
    NSArray *typeArr = [NSArray arrayWithObjects:@"2G", @"3G", @"4G", @"5G", @"wifi", nil];
    _currentNetType = [SFNetAddress getNetworkTypeFromStatusBar];
    if (_currentNetType == 0) {
        networkType = @"未联网";
    } else if (_currentNetType == 5) {//WiFi
        networkType = @"wifi";
        NSInteger signal = [SFNetworkInformation getWifiSignalStrength];
        NSString *ip = [SFNetAddress getGatewayIPAddress];
        NSString *ssid = [SFNetworkInformation getWifiSSID];//[SFNetworkInformation getWifiBSSID]
        NSString *speed = @"iOS";
        [netDetail sfim_safeSetObject:@(signal) forKey:@"signal"];
        [netDetail sfim_safeSetObject:ip forKey:@"ip"];
        [netDetail sfim_safeSetObject:ssid forKey:@"ssid"];
        [netDetail sfim_safeSetObject:speed forKey:@"speed"];
        [netDetail sfim_safeSetObject:networkType forKey:@"networkType"];
    } else if (_currentNetType > 0 && _currentNetType < 6) {//移动网络
        //手机卡运营商
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *operator = nil;
        if (carrier != NULL) {
            operator = [NSString stringWithFormat:@"%@ %@ %@ %@",[carrier carrierName],[carrier mobileNetworkCode],[carrier mobileCountryCode],[carrier isoCountryCode]];
        } else {
            operator = @"没有安装SIM卡";
        }
        NSString *channel = [typeArr sfim_safeObjectAtIndex:_currentNetType - 1];
        networkType = @"mobile";
        NSString *isRoaming = @"iOS";
        NSInteger signal = [SFNetworkInformation getSignalStrength];
        [netDetail sfim_safeSetObject:networkType forKey:@"networkType"];
        [netDetail sfim_safeSetObject:channel forKey:@"channel"];
        [netDetail sfim_safeSetObject:isRoaming forKey:@"isRoaming"];
        [netDetail sfim_safeSetObject:operator forKey:@"operator"];
        [netDetail sfim_safeSetObject:@[
                                        @{
                                            @"signal" : @(signal),
                                            @"channel" : channel
                                            }
                                        ] forKey:@"signal"];
    } else {
    }
    NSString *netDetailString = [netDetail yy_modelToJSONString];
    [self.stringNetworkInfo appendString:[NSString stringWithFormat:@"%@\n",netDetailString]];
    DDLogInfo(@"网络信息 \n%@",self.stringNetworkInfo);
//    //本地ip和DNS信息
//    [string appendString:[NSString stringWithFormat:@"\n当前本机IP：%@",[SFNetAddress deviceIPAdress]]];
//    NSArray *dnsServers = [NSArray arrayWithArray:[SFNetAddress outPutDNSServers]];
//    [string appendString:[NSString stringWithFormat:@"\n本地DNS：%@",[dnsServers componentsJoinedByString:@", "]]];
}


#pragma mark - NDS解析

/**
 解析DNS
 */
- (void)praseDnsWithFinishCallBack:(dispatch_block_t)finishCallBack
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        NSDate *dnsDate = [NSDate date];
        NSMutableArray *failArray = [[NSMutableArray alloc] init];
        for (NSString *domain in self.domainArray) {
            dispatch_group_enter(group);
            // host地址IP列表
            NSDate *dateImte = [NSDate date];
            NSArray *dnsResult = [NSArray arrayWithArray:[SFNetAddress getDNSsWithDormain:domain]];
            double time_duration =  [[NSDate date] timeIntervalSinceDate:dateImte] * 1000;//毫秒
            if (dnsResult.count) {
                NSMutableDictionary *dicItem = [[NSMutableDictionary alloc] init];
                [dicItem sfim_safeSetObject:domain forKey:@"domain"];
                [dicItem sfim_safeSetObject:[NSString stringWithFormat:@"%.2fms",time_duration] forKey:@"delay"];
                [dicItem sfim_safeSetObject:dnsResult forKey:@"ip"];
                
                NSString *stringItem = [dicItem yy_modelToJSONString];
                [self.stringPraseDns appendString:[NSString stringWithFormat:@"%@\n",stringItem]];
            } else {
                [failArray sfim_safeAddObject:domain];
            }
            dispatch_group_leave(group);
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            if (failArray.count) {
                [self.stringPraseDns appendString:@"DNS解析失败的域名："];
                for (NSString *domain in failArray) {
                    [self.stringPraseDns appendString:[NSString stringWithFormat:@"\n%@",domain]];
                }
            }
            double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:dnsDate];//秒
            NSLog(@"DNS解析总耗时%.2fs",millSecondsDelay);
            [self.stringPraseDns appendString:[NSString stringWithFormat:@"DNS解析总耗时：%.2fs\n",millSecondsDelay]];
            
            DDLogInfo(@"DNS解析结果 \n%@",self.stringPraseDns);
            if (finishCallBack) {
                finishCallBack();
            }
        });
    });
}


#pragma mark - 测速

- (void)networkSpeedMeasurerWithFinishCallBack:(dispatch_block_t)finishCallBack
{
    self.measurerSpeedFinishCallBack = finishCallBack;
    WS(weakSelf);
    [self.netSpeedMeasurerManager measurerNetSpeedWithUrl:self.downloadUrl time:self.downloadTime measurerBlock:^(SFNetMeasurerResult *result) {
        weakSelf.maxSpeed = [NSString stringWithFormat:@"%.2f MB/s",result.downlinkMaxSpeed];
        weakSelf.minSpeed = [NSString stringWithFormat:@"%.2f MB/s",result.downlinkMinSpeed];
        weakSelf.avgSpeed = [NSString stringWithFormat:@"%.2f MB/s",result.downlinkAvgSpeed];
    } endBlock:^{
        [weakSelf measurerSpeedFinish];
    }];
}

- (void)measurerSpeedFinish
{
    if (self.measurerSpeedFinishCallBack) {
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
        if (self.maxSpeed.length) {
            [dicData sfim_safeSetObject:self.maxSpeed forKey:@"maxSpeed"];
            [dicData sfim_safeSetObject:self.minSpeed forKey:@"minSpeed"];
            [dicData sfim_safeSetObject:self.avgSpeed forKey:@"avgSpeed"];
        } else {
            [dicData sfim_safeSetObject:@"测速失败" forKey:@"maxSpeed"];
        }
        [dicData sfim_safeSetObject:self.downloadUrl forKey:@"service"];
        [dicData sfim_safeSetObject:@(self.downloadTime) forKey:@"time"];
        
        NSString *speed = [dicData yy_modelToJSONString];
        [self.stringMeasurerSpeed appendString:[NSString stringWithFormat:@"%@\n",speed]];
        if (self.maxSpeed == 0) {//测速失败，可能是没有网络
            DDLogInfo(@"没有网速");
        }
        DDLogInfo(@"下载速率 \n%@",self.stringMeasurerSpeed);
        self.measurerSpeedFinishCallBack();
        self.measurerSpeedFinishCallBack = nil;
    }
}

#pragma mark - Getter

- (NSString *)detectNetworkPath {
    if (!_detectNetworkPath) {
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
         NSString *dataFilePath = [documentDir stringByAppendingPathComponent:@"NetworkMonitor"]; // 在Document目录下创建 "NetworkMonitor" 文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
        if (!(isDir && existed)) {
            // 在Document目录下创建一个archiver目录
            [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _detectNetworkPath = [dataFilePath stringByAppendingPathComponent:@"networkLog.log"];
        DDLogInfo(@"沙盒路径 == %@",_detectNetworkPath);
    }
    return _detectNetworkPath;
}

- (NSMutableString *)stringNetworkInfo {
    if (!_stringNetworkInfo) {
        _stringNetworkInfo = [[NSMutableString alloc] initWithString:@"网络环境 \n"];
    }
    return _stringNetworkInfo;
}

- (NSMutableString *)stringPing {
    if (!_stringPing) {
        _stringPing = [[NSMutableString alloc] initWithString:@"ping检测结果 \n"];
    }
    return _stringPing;
}

- (NSMutableString *)stringPraseDns {
    if (!_stringPraseDns) {
        _stringPraseDns = [[NSMutableString alloc] initWithString:@"DNS解析结果 \n"];
    }
    return _stringPraseDns;
}

- (NSMutableString *)stringMeasurerSpeed {
    if (!_stringMeasurerSpeed) {
        _stringMeasurerSpeed = [[NSMutableString alloc] initWithString:@"网速检测结果 \n"];
    }
    return _stringMeasurerSpeed;
}

- (SFNetSpeedMeasurerManager *)netSpeedMeasurerManager {
    if (!_netSpeedMeasurerManager) {
        _netSpeedMeasurerManager = [[SFNetSpeedMeasurerManager alloc] init];
    }
    return _netSpeedMeasurerManager;
}

- (NSMutableArray *)arrayDetectData {
    if (!_arrayDetectData) {
        _arrayDetectData = [[NSMutableArray alloc] init];
    }
    return _arrayDetectData;
}

- (NSArray *)domainArray
{
    if (!_domainArray) {
        _domainArray = @[
                         @"imsp-mms.sf-express.com",
//                         @"mscss.sf-express.com",
//                         @"sfim-file.sf-express.com",
//                         @"sfim-mconnect.sf-express.com",
//                         @"sfim-mlaud.sf-express.com",
                         @"sfim-laud.sf-express.com",
                         @"sfim-update.sf-express.com",
                         @"mcas.sf-express.com",
                         @"honey.sf-express.com",
                         @"mecp.sf-express.com",
                         @"msfsm.sf-express.com",
                         @"sfim-mcommon.sf-express.com",
                         @"sfim-hb.sf-express.com",
                         @"sfim-core-update.sf-express.com",
                         @"imsp.sf-express.com",
                         @"sps.sf-express.com",
                         @"sfim-musts.sf-express.com",
                         @"kms-mappserver.sf-express.com",
                         @"sfim-auth.sf-express.com",
                         @"sfim-log.sf-express.com",
                         @"mrm-app.sf-express.com",
//                         @"rp.sf-pay.com",
                         @"sfim.sf-express.com",
                         @"sfimmobilelink.sf-express.com",
                         @"sfim-nos.sf-express.com",
//                         @"sf.nos.netease.im",
                         @"ccmp.sf-express.com",
//                         @"esg-sfim-nos-m.sf-express.com",
                         @"sfim-sms-bg.sf-express.com",
                         @"asr-bl.sf-express.com",
//                         @"sfim-nos-hk.sf-express.com",
//                         @"sfim-hk.sf-express.com"
                         ];
    }
    return _domainArray;
}

@end
