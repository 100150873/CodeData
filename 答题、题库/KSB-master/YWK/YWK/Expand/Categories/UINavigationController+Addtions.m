//
//  UINavigationController+Addtions.m
//  YuanChenKeeper
//
//  Created by Yhoon on 16/1/26.
//  Copyright © 2016年 com.Qingye.YuanChenKeeper. All rights reserved.
//

#import "UINavigationController+Addtions.h"

@implementation UINavigationController (Addtions)

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    
    //修改导航栏标题的字体
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    //字典中放入你想修改的键值对,原来的UITextAttributeFont、UITextAttributeTextColor、UITextAttributeTextShadowColor、UITextAttributeTextShadowOffset已弃用
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                               NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0]
                                               };
    
}

@end
