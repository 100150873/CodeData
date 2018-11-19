//
//  UIBarButtonItem+ZCExtension.m
//  GTTemplateAPP
//
//  Created by yixin on 2017/5/11.
//  Copyright © 2017年 GZC. All rights reserved.
//

#import "NSString+Extension.h"
#import "UIBarButtonItem+ZCExtension.h"

@implementation UIBarButtonItem (ZCExtension)

/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 * UIBarButtonItem *map = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
 调整间距
 map.customView.width = 60;
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(NSString *)image
                          highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

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
                                            action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithName:title font:font titleColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    CGFloat width = [title getNSStringSizeWithLimitSize:CGSizeMake(CGFLOAT_MAX, 30) fontSize:font].width;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.frame = CGRectMake(0, 0, width, 30);
    [btn.titleLabel sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
