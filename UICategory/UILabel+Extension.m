//
//  UILabel+Extension.m
//  PJCLitterCost
//
//  Created by yixin on 17/4/24.
//  Copyright © 2017年 ham. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (instancetype)labelWithFontSize:(UIFont *)font
                            title:(NSString *)title
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)color
                  backGroundColor:(UIColor *)backGroundColor {
    UILabel *label = [self labelWithFontSize:font title:title textAlignment:textAlignment titleColor:color];
    label.backgroundColor = backGroundColor;
    return label;
}

+ (instancetype)labelWithFontSize:(UIFont *)font
                            title:(NSString *)title
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignment;
    return label;
}

+ (instancetype)labelWithFontSize:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment
                       titleColor:(UIColor *)titleColor
{
   return [self labelWithFontSize:font title:@"" textAlignment:textAlignment titleColor:titleColor];
}

+ (instancetype)labelWithFontSize:(UIFont *)font
                 attributedString:(NSAttributedString *)attributedString
                    textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc]init];
    label.attributedText = attributedString;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

- (void)setFontSize:(UIFont *)font
              title:(NSString *)title
      textAlignment:(NSTextAlignment)textAlignment
         titleColor:(UIColor *)color {
    
    self.text = title;
    self.font = font;
    self.textColor = color;
    self.textAlignment = textAlignment;
}

- (void)setLabelheadIndentNumber:(CGFloat)number {
 
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
//    style.headIndent = number;//缩进
    style.firstLineHeadIndent = number;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    self.attributedText = text;
}

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
     afterColor:(UIColor *)afterColor
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:text];
    //获取要调整颜色的文字位置,调整颜色
    [hintString addAttribute:NSForegroundColorAttributeName value:beforeColor range:NSMakeRange(0,index)];
    [hintString addAttribute:NSForegroundColorAttributeName value:afterColor range:NSMakeRange(index,text.length-index)];
    self.attributedText=hintString;
}
@end
