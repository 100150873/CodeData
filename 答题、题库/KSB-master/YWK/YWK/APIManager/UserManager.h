//
//  UserManager.h
//  YunTShop
//
//  Created by sfgod on 16/6/3.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface UserManager : NSObject

@property (strong, nonatomic) UserModel *user;      //
@property (strong, nonatomic) NSCache   *orderCache;  //
@property (strong, nonatomic) NSCache   *dishCache;   //
@property (strong, nonatomic) NSCache   *yungouCache; //


+ (instancetype)sharedManager;
//- (void)

@end
