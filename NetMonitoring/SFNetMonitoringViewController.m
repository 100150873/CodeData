//
//  SFNetMonitoringViewController.m
//  NIM
//
//  Created by gzc on 2019/3/28.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFNetMonitoringViewController.h"

#import "SFNetworkInformation.h"
#import "SFNetAddress.h"
#import "SFLoginMiddleWare.h"
#import "SFPingManager.h"
#import "SFNetSpeedMeasurer.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@interface SFNetMonitoringViewController ()<NSURLSessionDownloadDelegate>
{
    NSString *_appName;
    NSString *_appVersion;
    NSString *_userID;       //用户ID
    NSString *_systemInfo;
    NSString *_deviceID;  //客户端机器ID，如果不传入会默认取API提供的机器ID
    NSString *_carrierName;
    NSString *_ISOCountryCode;
    NSString *_MobileCountryCode;
    NSString *_MobileNetCode;
    
    NETWORK_TYPE _curNetType;
    NSString *_localIp;
    NSString *_gatewayIp;
    NSArray *_dnsServers;
    NSArray *_hostAddress;
    
    NSMutableString *_logInfo;  //记录网络诊断log日志
}

@property (weak, nonatomic) IBOutlet UILabel *labelDeviceInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelNetInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelLocalNetEnvironment;
@property (weak, nonatomic) IBOutlet UILabel *labelDNSPraseResult;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) SFPingManager* pingManager;
@property (nonatomic, strong) SFNetSpeedMeasurer *measurer;
@property (nonatomic, strong) NSArray *domainArray;
@property (nonatomic, strong) NSMutableDictionary *dicDNSResult;
@end

@implementation SFNetMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchDeviceInfo];//获取设备信息
    [self fetchLocalNetEnvironment];
    self.textView.editable = NO;
    [self praseDomainArray];
    [self testNetSpeed];
    [self ping];
}

- (void)fetchDeviceInfo
{
    _appVersion = CURRENT_VERSION;
    _userID = [SFLoginMiddleWare currentUserIdStr];
    UIDevice *device = [UIDevice currentDevice];
    _systemInfo = [NSString stringWithFormat:@"%@ %@",[device systemName],[device systemVersion]];
    _deviceID = [self uniqueAppInstanceIdentifier];
    NSString *deviceInfo = [NSString stringWithFormat:@"账号：%@\n版本号：%@\n手机系统：%@\n设备ID：%@",_userID,_appVersion,_systemInfo,_deviceID];
    self.labelDeviceInfo.text = deviceInfo;
}

- (void)ping
{
    self.pingManager = [[SFPingManager alloc] init];
    NSDate  *pingDate = [NSDate date];
//    [self.pingManager getFatestAddress:self.domainArray count:10 completionHandler:^(NSString *hostName, NSArray *sortedAddress) {
//        double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:pingDate];//秒
//        NSLog(@"fastest IP: %@  %@ 总耗时%.3f",hostName,sortedAddress,millSecondsDelay);
//    }];
}


- (void)testNetSpeed
{
    _measurer = [[SFNetSpeedMeasurer alloc] initWithAccuracyLevel:5 interval:1.0];
    
    __weak typeof(self) weak_self = self;
    _measurer.measurerBlock = ^(SFNetMeasurerResult * _Nonnull result) {
        SFNetConnectionType netType = result.connectionType;
        NSString *MaxSpeed = [NSString stringWithFormat:@"Max : %.2f MB/s",result.downlinkMaxSpeed];
        NSString *MinSpeed = [NSString stringWithFormat:@"Min : %.2f MB/s",result.downlinkMinSpeed];
        NSString *AvgSpeed = [NSString stringWithFormat:@"Avg : %.2f MB/s",result.downlinkAvgSpeed];
        NSString *CurSpeed = [NSString stringWithFormat:@"Cur : %.2f MB/s",result.downlinkCurSpeed];
        NSLog(@"\n %@\n %@\n %@\n %@",MaxSpeed,MinSpeed,AvgSpeed,CurSpeed);
    };
    
    [_measurer execute];
    NSURL* url = [NSURL URLWithString:@"http://s-zhihuishequ-apk.oss-cn-shanghai.aliyuncs.com/songdaojia/GTTemplateAPP.ipa"];
    if (!url)  return;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    [[session downloadTaskWithURL:url] resume];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [session invalidateAndCancel];
        [_measurer shutdown];
    });
}


- (void)praseDomainArray
{
    // 获得全局的并发队列将任务添加全局队列 中 异步 执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_group_t group = dispatch_group_create();
        NSDate *date = [NSDate date];
        for (NSString *domain in self.domainArray) {
            dispatch_group_enter(group);
            // host地址IP列表
            long time_start = [SFNetTimer getMicroSeconds];
            _hostAddress = [NSArray arrayWithArray:[SFNetAddress getDNSsWithDormain:domain]];
            long time_duration = [SFNetTimer computeDurationSince:time_start] / 1000;
            NSString *praseResult = @"";
            if ([_hostAddress count] == 0) {
                praseResult = @"DNS解析结果:\n 解析失败";
            } else {
                praseResult = [NSString stringWithFormat:@"DNS解析结果:\n %@ (%ldms)",
                               [_hostAddress componentsJoinedByString:@", "],
                               time_duration];
            }
            if (domain) {
                [self.dicDNSResult sfim_safeSetObject:praseResult forKey:domain];
            }
            dispatch_group_leave(group);
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            double millSecondsDelay = [[NSDate date] timeIntervalSinceDate:date];//秒
            NSLog(@"DNS解析总耗时%.3f",millSecondsDelay);
            NSLog(@"解析结果 ： %@",self.dicDNSResult);
        });
        
    });
    
}

#pragma mark -- NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didFinishDownloadingToURL:(NSURL*)location {
    NSLog(@"下载完成");
    [_measurer shutdown];
}

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"下载进度 ：%f", progress);
}


/**
 * 获取deviceID
 */
- (NSString *)uniqueAppInstanceIdentifier
{
    NSString *app_uuid = @"";
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    app_uuid = [NSString stringWithString:(__bridge NSString *)uuidString];
    CFRelease(uuidString);
    CFRelease(uuidRef);
    return app_uuid;
}

/**
 获取本地网络信息
 */
- (void)fetchLocalNetEnvironment
{
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier != NULL) {
        _carrierName = [carrier carrierName];
        _ISOCountryCode = [carrier isoCountryCode];
        _MobileCountryCode = [carrier mobileCountryCode];
        _MobileNetCode = [carrier mobileNetworkCode];
        NSString *netInfo = [NSString stringWithFormat:@"运营商：%@ %@ %@ %@",_carrierName,_MobileNetCode,_MobileCountryCode,_ISOCountryCode];
        
        self.labelNetInfo.text = netInfo;
    } else {
        self.labelNetInfo.text = @"没有安装SIM卡";
    }
    
    //判断是否联网以及获取网络类型
    NSMutableString *string = [[NSMutableString alloc] init];
    NSArray *typeArr = [NSArray arrayWithObjects:@"2G", @"3G", @"4G", @"5G", @"wifi", nil];
    _curNetType = [SFNetAddress getNetworkTypeFromStatusBar];
    if (_curNetType == 0) {
        [string appendString:@"未联网"];
        self.labelLocalNetEnvironment.text = string;
    } else {
        if (_curNetType > 0 && _curNetType < 6) {
            [string appendString:[typeArr objectAtIndex:_curNetType - 1]];
            if (_curNetType == 5) {//WiFi
                _gatewayIp = [SFNetAddress getGatewayIPAddress];
                [string appendString:[NSString stringWithFormat:@" 信号强度：%d \nwifi地址：%@ \nWiFi名称：%@ \n网关IP：%@",[SFNetworkInformation getWifiSignalStrength],[SFNetworkInformation getWifiBSSID],[SFNetworkInformation getWifiSSID],_gatewayIp]];
            } else {
                [string appendString:[NSString stringWithFormat:@" 信号强度：%d",[SFNetworkInformation getSignalStrength]]];
            }
        }
    }
    
    //本地ip信息
    _localIp = [SFNetAddress deviceIPAdress];
    [string appendString:[NSString stringWithFormat:@"\n当前本机IP：%@",_localIp]];
    
    _dnsServers = [NSArray arrayWithArray:[SFNetAddress outPutDNSServers]];
    [string appendString:[NSString stringWithFormat:@"\n本地DNS：%@",[_dnsServers componentsJoinedByString:@", "]]];

    self.labelLocalNetEnvironment.text = string;
}



//INFO_SECURITY_DOMAIN, //资讯安全域名
//SFIM_SCSS_DOMAIN, //scss域名
//FileUploadHOST, //文件上传桶名
//SFIM_ROBOT_HEADER, //机器人域名
//SFIM_MATE_CIRCLE_HEADER, //同事圈域名
//SFIM_CEO_ONLINE_HEADER, //紧密公司总裁在线域名
//SFIM_UPDATE_HEADER, //二维码域名
//MCAS_HEADER, //cas域名
//HONEY_HEADER, //帮助与反馈域名
//MECP_HEADER, //ecp域名
//MEETING_HEAD, //日程接口域名（部分）
//DICK_ONLINE_HEAD, //dick在线域名
//RedEnvelopeBaseUrl, //红包接口域名
//SFIM_VERSION_UPDATE, //版本更新域名
//INFO_NEW_DOMAIN,  //资讯新域名
//INFO_NEW_DOMAIN_HTTPS, //资讯新HTTPS域名

- (NSArray *)domainArray {
    if (!_domainArray) {
        _domainArray = @[
                         @"imsp-mms.sf-express.com",
                         @"mscss.sf-express.com",
                         @"sfim-file.sf-express.com",
                         @"sfim-mconnect.sf-express.com",
                         @"sfim-mlaud.sf-express.com",
                         @"sfim-laud.sf-express.com",
                         @"sfim-update.sf-express.com",
                         @"mcas.sf-express.com",
                         @"honey.sf-express.com",
                         @"mecp.sf-express.com",
                         @"msfsm.sf-express.com",
                         @"sfim-mcommon.sf-express.com",
                         @"sfim-hb.sf-express.com",
                         @"sfim-core-update.sf-express.com",
                         @"imsp.sf-express.com"
                         ];
    }
    return _domainArray;
}

- (NSMutableDictionary *)dicDNSResult {
    if (!_dicDNSResult) {
        _dicDNSResult = [[NSMutableDictionary alloc] init];
    }
    return _dicDNSResult;
}

- (IBAction)testDownloadSpeed:(id)sender {
    
    [self testNetSpeed];
}

- (IBAction)clickHKDns:(id)sender {
    
}
- (IBAction)clickCNDns:(id)sender {
    
}

- (IBAction)clickPingBtn:(UIButton *)sender {
    NSArray *hostNameArray = @[
                               @"www.baidu.com",
                               @"honey.sf-express.com",
                               @"sfim-hb.sf-express.com",
                               @"sfim-mcommon.sf-express.com",
                               @"mcas.sf-express.com",
                               @"sfim-update.sf-express.com",
                               @"sfim-core-update.sf-express.com",
                               @"www.jianshu.com"
                               ];
    
    self.pingManager = [[SFPingManager alloc] init];
//    [self.pingManager getFatestAddress:hostNameArray count:10 completionHandler:^(NSString *hostName, NSArray *sortedAddress) {
//        NSLog(@"fastest IP: %@  %@",hostName,sortedAddress);
//    }];
}

@end
