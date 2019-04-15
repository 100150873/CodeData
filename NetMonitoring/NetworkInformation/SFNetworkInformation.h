//
//  SFNetworkInformation.h
//  NIM
//
//  Created by gzc on 2019/3/28.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFNetworkInformation : NSObject

//获取当前网络类型
+ (NSString *)getNetworkType;
//获取当前网络类型
+ (NSString *)getNetworkTypeByReachability;
//获取Wifi信息
+ (id)fetchSSIDInfo;
//获取WIFI名字
+ (NSString *)getWifiSSID;
//获取WIFi的MAC地址
+ (NSString *)getWifiBSSID;
//获取Wifi信号强度
+ (int)getWifiSignalStrength;
//获取设备IP地址
+ (NSString *)getIPAddress;

//获取网络信号强度（dBm）
+ (int)getSignalStrength;

@end
