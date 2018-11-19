//
//  UIWindow+ZCExtension.m
//  GTTemplateAPP
//
//  Created by yixin on 2017/6/21.
//  Copyright © 2017年 GZC. All rights reserved.
//

#import "ZCLoginVC.h"
#import "ZCGuideVC.h"
#import "ZCTabbarVC.h"
#import "UIWindow+ZCExtension.h"
#import "ZCNavigationController.h"

static NSString *const KEY_VERSION = @"CFBundleShortVersionString";
@implementation UIWindow (ZCExtension)

- (void)configRootVC
{
   dispatch_block_t swithRootVC = ^{
        if ([[ZCUserCenter shareZCUserCenter] isLogin]) {//已登录
            self.rootViewController = [ZCTabbarVC tabBar];
        } else {//未登录
            ZCLoginVC *loginVC = [[ZCLoginVC alloc]init];
            loginVC.loginSuccess = ^{//登录成功
                ZCLog(@"登录成功切换根控制器");
                self.rootViewController = [ZCTabbarVC tabBar];
            };
            ZCNavigationController *nav = [[ZCNavigationController alloc] initWithRootViewController:loginVC];
            self.rootViewController = nav;
        }
    };
    
    NSString *lastVersion = [ZCUserDefaults objectForKey:KEY_VERSION];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[KEY_VERSION];
    if (![currentVersion isEqualToString:lastVersion]) {//显示新版本页面
        ZCGuideVC *guideVC = [[ZCGuideVC alloc] init];
        self.rootViewController = guideVC;
        guideVC.switchRootVCBlock = swithRootVC;
        [ZCUserDefaults setObject:currentVersion forKey:KEY_VERSION];
    } else {
        swithRootVC();
    }
}
@end
