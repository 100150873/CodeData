//
//  UITextField+Handy.m
//  PaperSource
//
//  Created by Yhoon on 15/10/19.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UITextField+Handy.h"

@implementation UITextField (Handy)

// 创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                            andName:(NSString*)tfText
                     andPlaceholder:(NSString*)placeholder
                   andTextAlignment:(NSTextAlignment)textAlignment
                        andFontSize:(UIFont*)font
                       andTextColor:(UIColor*)textColor
                        andDelegate:(id)delegate {
    
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.borderStyle              = UITextBorderStyleRoundedRect;
    textField.returnKeyType            = UIReturnKeyDefault;
    textField.text                     = tfText;
    textField.placeholder              = placeholder;
    textField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    textField.textAlignment            = textAlignment;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate                 = delegate;
    textField.keyboardType             = UIKeyboardTypeDefault;
    textField.keyboardAppearance       = UIKeyboardAppearanceDefault;
    textField.autocapitalizationType   = UITextAutocapitalizationTypeAllCharacters;
    textField.autocorrectionType       = UITextAutocorrectionTypeNo;
    textField.font                     = font;
    textField.textColor                = textColor;
    
    UIView *paddingView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    
    return textField;
}


+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                             andFontSize:(UIFont*)font
                            andTextColor:(UIColor*)textColor
                     andPlaceholderColor:(UIColor *)holderColer{
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.placeholder              = placeholder;
    textField.keyboardType             = UIKeyboardTypeDefault;
    textField.font                     = font;
    textField.textColor                = textColor;
    [textField setValue:holderColer forKeyPath:@"_placeholderLabel.textColor"];
//    UIView *paddingView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    paddingView.backgroundColor = [UIColor clearColor];
//    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    
    return textField;
    
}

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                             andFontSize:(UIFont*)font
                            andTextColor:(UIColor*)textColor
                     andPlaceholderColor:(UIColor *)holderColer
                          andLeftViewImg:(UIImage *)image
                        andLeftViewFrame:(CGRect)frame{
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    textField.placeholder              = placeholder;
    textField.keyboardType             = UIKeyboardTypeDefault;
    textField.font                     = font;
    textField.textColor                = textColor;
    [textField setValue:holderColer forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView         = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:VIEWFRAME(frame.size.height/2-image.size.height/2, 10, image.size.width, image.size.height)];
    logo.image = image;
    [paddingView addSubview:logo];
    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    textField.backgroundColor          = [UIColor whiteColor];
    return textField;
}

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                            andCanWrited:(BOOL)isWrite
                        andLeftViewTitle:(NSString *)title{
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    textField.userInteractionEnabled   = isWrite;
    textField.textAlignment            = NSTextAlignmentCenter;
    textField.placeholder              = placeholder;
    textField.keyboardType             = UIKeyboardTypeDefault;
    textField.font                     = SYSTEMFONT(16);
    textField.textColor                = APP_COLOR_GRAY_333333;
    [textField setValue:APP_COLOR_GRAY_666666 forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView         = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, title.length*16+25, rect.size.height)];
    UILabel *label = [UILabel createLabelWithFrame:paddingView.bounds
                                           andText:title
                                      andTextColor:APP_COLOR_GRAY_666666
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(16)
                                  andTextAlignment:NSTextAlignmentCenter];
    [paddingView addSubview:label];
    
    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    textField.backgroundColor          = [UIColor whiteColor];
    
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, rect.size.height, rect.size.width, 1)];
    cut.backgroundColor = APP_COLOR_GRAY_eeeeee;
    [textField addSubview:cut];
    
    return textField;
    
}

+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                          andPlaceholder:(NSString*)placeholder
                        andLeftViewImage:(UIImage *)image{
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    textField.placeholder              = placeholder;
    textField.font                     = SYSTEMFONT(16);
    textField.textColor                = APP_COLOR_GRAY_333333;
    [textField setValue:APP_COLOR_GRAY_666666 forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView         = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, rect.size.height, rect.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIEWFRAME((rect.size.height-image.size.width)/2, (rect.size.height-image.size.height)/2, image.size.width, image.size.height)];
    imageView.image = image;
    [paddingView addSubview:imageView];
    
    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    textField.backgroundColor          = [UIColor whiteColor];
    
    return textField;

}



@end
