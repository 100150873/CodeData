//
//  UILabel+Extension.h
//  PJCLitterCost
//
//  Created by yixin on 17/4/24.
//  Copyright © 2017年 ham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 根据label字体大小 文字内容 文字对齐方向 字体颜色 背景颜色 返回一个label的实例对象

 @param font 字体大小
 @param title 文字内容
 @param textAlignment 文字对齐方向
 @param color 字体颜色
 @param backGroundColor 背景颜色
 @return 返回一个label的实例对象
 */
+ (instancetype)labelWithFontSize:(UIFont *)font
                            title:(NSString *)title
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)color
                  backGroundColor:(UIColor *)backGroundColor;

/**
 根据label字体大小 文字内容 文字对齐方向 字体颜色 返回一个label的实例对象

 @param font 字体大小
 @param title 文字内容
 @param textAlignment 文字对齐方向
 @param color 字体颜色
 @return 返回一个label的实例对象
 */
+ (instancetype)labelWithFontSize:(UIFont *)font
                            title:(NSString *)title
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)color;

+ (instancetype)labelWithFontSize:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)titleColor;


/**
 根据字体大小 文字对齐方向 富文本属性 返回一个label的实例对象

 @param font 字体大小
 @param attributedString 富文本属性
 @param textAlignment 文字对齐方向
 @return label 的实例对象
 */
+ (instancetype)labelWithFontSize:(UIFont *)font
                 attributedString:(NSAttributedString *)attributedString
                    textAlignment:(NSTextAlignment)textAlignment;

/**
 设置label字体大小 文字内容 文字对齐方向 字体颜色

 @param font 字体大小
 @param title 文字内容
 @param textAlignment 文字对齐方向
 @param color 字体颜色
 */
- (void)setFontSize:(UIFont *)font
              title:(NSString *)title
      textAlignment:(NSTextAlignment)textAlignment
         titleColor:(UIColor *)color;

/**
 设置label的缩进效果

 @param number 缩进个数
 */
- (void)setLabelheadIndentNumber:(CGFloat)number;

/**
 label设置富文本颜色 (例：合计：300  只让价格变色 则index应该=3)
 
 @param text 文字
 @param index 从第几个变色
 @param beforeColor 之前的颜色
 @param afterColor 之后的颜色
 */
- (void)setText:(NSString *)text
        toIndex:(NSInteger)index
    beforeColor:(UIColor*)beforeColor
     afterColor:(UIColor *)afterColor;

@end
