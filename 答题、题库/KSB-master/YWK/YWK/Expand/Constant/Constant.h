//
//  Constant.h
//  YHFoundation
//
//  Created by Yhoon on 16/1/14.
//  Copyright © 2016年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户数据保存Key
FOUNDATION_EXPORT NSString *const kLoginState;;
FOUNDATION_EXPORT NSString *const kLoginUserData;
FOUNDATION_EXPORT NSString *const kLoginPreUserName;

//七牛图片的头
FOUNDATION_EXPORT NSString *const kImageHead;

//高德地图的key
FOUNDATION_EXPORT NSString *const kGaodeMapKey;


//scheme
FOUNDATION_EXPORT NSString *const kappURLScheme;

//weixin scheme
FOUNDATION_EXPORT NSString *const kwxppURLScheme;

//更新用户信息的key
FOUNDATION_EXPORT NSString *const kUpdateUerInfo;

//后台进入前台时触发的通知key
FOUNDATION_EXPORT NSString *const kAppEnterForeground;

//定位回调时触发的通知key
FOUNDATION_EXPORT NSString *const kLocationSucceed;

//历史搜索 存取本地数据使用的key
FOUNDATION_EXPORT NSString *const kHistorySearch;

//友盟app的key
FOUNDATION_EXPORT NSString *const UmengAppkey;

//这个app的url
FOUNDATION_EXPORT NSString *const kAPPStoreURL;

//团购成功后删除购物车通知
FOUNDATION_EXPORT NSString *const kGoupDeleteCartNotification;

//设备的device_token
FOUNDATION_EXPORT NSString *const kDevice_Token;
