//
//  UserManager.m
//  YunTShop
//
//  Created by sfgod on 16/6/3.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager


+ (instancetype)sharedManager{
    static UserManager *usermanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usermanager = [[UserManager alloc] init];
    });
    return usermanager;
}

@end
