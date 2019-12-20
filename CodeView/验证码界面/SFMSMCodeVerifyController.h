//
//  SFMSMCodeVerifyController.h
//  NIM
//
//  Created by gzc on 2019/12/19.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFMSMCodeVerifyController : SFBaseViewController

/**
 初始化方法

 @param phoneNumber 电话号码
 @param countryCode 国家编码
 @return 实例化对象
 */
- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                        countryCode:(NSString *)countryCode;

@end

NS_ASSUME_NONNULL_END
