//
//  AppDelegate+ZCExtension.m
//  PJCLitterCost
//
//  Created by yixin on 17/4/25.
//  Copyright © 2017年 ham. All rights reserved.
//

#import "IQKeyboardManager.h"
#import "AppDelegate+ZCExtension.h"

@implementation AppDelegate (ZCExtension)
#pragma mark - =======Bugly=========
- (void)configBugly
{
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.delegate = self;
    config.unexpectedTerminatingDetectionEnable = YES;//非正常退出记录
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel = @"App Store";
    [Bugly startWithAppId:ZCBuglyKey config:config];
    if ([[ZCUserCenter shareZCUserCenter] isLogin]) {
        [Bugly setUserIdentifier:[ZCUser phone]];
    }
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
}

/**
 键盘管理配置
 */
- (void)configurationIQKeyboard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
 
}

#pragma mark - =======BuglyDelegate=========
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
{
    [Bugly setTag:501];//自定义闪退标签
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\n追溯堆栈：%@",name, reason, stackArray];
    NSString *crash = [NSString stringWithFormat:@"文件名:%@ \n函数名:%s\n 行号:%d \n 崩溃信息:\n%@\n用户:%@ \n",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__PRETTY_FUNCTION__, __LINE__, exceptionInfo,[ZCUser phone]];
    return crash;
}



@end
