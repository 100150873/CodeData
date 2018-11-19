//
//  UIBarButtonItem+ZCExtension.h
//  GTTemplateAPP
//
//  Created by yixin on 2017/5/11.
//  Copyright © 2017年 GZC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZCExtension)

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(NSString *)image
                          highImage:(NSString *)highImage;

/**
 定制导航栏右边的按钮的字体颜色 大小 名称
 
 @param title 名称
 @param font 字体大小
 @param color 字体颜色
 */
+ (UIBarButtonItem *)customNavigationRighItemTitle:(NSString *)title
                                          fontSize:(UIFont *)font
                                        titleColor:(UIColor *)color
                                            Target:(id)target
                                            action:(SEL)action;

@end
