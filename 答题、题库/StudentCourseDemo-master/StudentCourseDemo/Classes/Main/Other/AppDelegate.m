//
//  AppDelegate.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/2.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "AppDelegate.h"
#import "StudentCoursesListViewController.h"
#import "CoursePPTViewController.h"
#import "SlideFrameViewController.h"
#import "HttpConfig.h"
#import "ProblemPaperKindObject.h"
#import "JSON.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    [self performSelector:@selector(CategoryCourseinitAPPSetting) withObject:self afterDelay:0.0];

//    StudentCoursesListViewController *studentCourse = [[StudentCoursesListViewController alloc] init];
//    CoursePPTViewController *coursePPTVC = [[CoursePPTViewController alloc] init];
    SlideFrameViewController *slideVC = [[SlideFrameViewController alloc] init];
    self.window.rootViewController = slideVC;
    
    // self.window.backgroundColor =[UIColor whiteColor];
    // 3.显示窗口(成为主窗口)
    [self.window makeKeyAndVisible];
    
    return YES;
}
//分类题库网络获取最新应用信息
-(void)CategoryCourseinitAPPSetting
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrlCategoryCourse] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData *data= [html dataUsingEncoding:NSUTF8StringEncoding];
        [[ProblemPaperKindObject share] videoWithDict2:[data JSONValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}
-(void)initFailure
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"初始化数据失败"
                                                 delegate:self
                                        cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
    [alert setTag:3];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
