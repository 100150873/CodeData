//
//  UITextField+Handy.h
//  PaperSource
//
//  Created by Yhoon on 15/10/19.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Handy)

// 创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                            andName:(NSString*)tfText
                     andPlaceholder:(NSString*)placeholder
                   andTextAlignment:(NSTextAlignment)textAlignment
                        andFontSize:(UIFont*)font
                       andTextColor:(UIColor*)textColor
                        andDelegate:(id)delegate;

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                             andFontSize:(UIFont*)font
                            andTextColor:(UIColor*)textColor
                     andPlaceholderColor:(UIColor *)holderColer;

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                             andFontSize:(UIFont*)font
                            andTextColor:(UIColor*)textColor
                     andPlaceholderColor:(UIColor *)holderColer
                          andLeftViewImg:(UIImage *)image
                        andLeftViewFrame:(CGRect)frame;

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                        andLeftViewImage:(UIImage *)image;



@end
