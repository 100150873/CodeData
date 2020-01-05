//
//  ZCJoinMaterialView.m
//  OpenShop
//
//  Created by 罗建 on 2018/11/30.
//  Copyright © 2018年 SuWei. All rights reserved.
//

#import "ZCJoinMaterialView.h"
#import "NSBundle+wgSubBundle.h"

@implementation ZCJoinMaterialView

//+ (instancetype)JoinMaterialViewFromNib {
//    NSArray *views = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
//
//    return views.firstObject;
//}

- (instancetype)init {
    NSLog(@"11111111");
    NSBundle *bundle = [NSBundle wg_subBundleWithBundleName:@"ModuleXib" targetClass:[self class]];
    NSLog(@"2222");
    NSArray *views = [bundle loadNibNamed:@"ZCJoinMaterialView" owner:nil options:nil];
    NSLog(@"3333");
    return views.firstObject;
}




@end
