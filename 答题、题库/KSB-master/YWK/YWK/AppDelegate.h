//
//  AppDelegate.h
//  YWK
//
//  Created by 杨伟康 on 2017/5/17.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RootViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)RootViewController *rootVC;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

