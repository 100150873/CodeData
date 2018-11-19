//
//  AppDelegate+ZCExtension.h
//  PJCLitterCost
//
//  Created by yixin on 17/4/25.
//  Copyright © 2017年 ham. All rights reserved.
//


#import "AppDelegate.h"
#import <Bugly/Bugly.h>


@interface AppDelegate (ZCExtension)<BuglyDelegate>

- (void)configBugly;
/**
 键盘管理配置
 */
- (void)configurationIQKeyboard;
@end
