//
//  UIAlertController+extension.h
//  XWAlert
//
//  Created by Apple on 2017/4/3.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (extension)
/**
 to add UIAlertAction with UIAlertActionStyleDefault
 
 @param title - the title of UIAlertAction
 @param handler - to handle your business
 */
- (void)addAlertDefaultActionWithTitle:(NSString *_Nullable)title
                               handler:(void (^_Nullable)(UIAlertAction * _Nullable  action))handler;


/**
 to add TextField in your alert, callback the  textFiled which  you built
 it only support in Alert Styple
 
 @param placeholder - set TextField's placeholder
 @param secureTextEntry - set Secure input Mode
 @param textFiledhandler - to handle textField which you can do anything
 */
- (void)addTextFieldWithPlaceholder:(NSString *_Nullable)placeholder
                    secureTextEntry:(BOOL)secureTextEntry
                   textFiledhandler:(void(^_Nullable)(UITextField * _Nonnull textField))textFiledhandler;

- (void)addTitleAttributedStringWithFontSize:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)titleColor;

- (void)addMessageAttributedStringWithFontSize:(UIFont *_Nullable)font titleColor:(UIColor *_Nullable)titleColor;

- (void)addCancelActionAttributedStringWithFontSize:(UIFont *)font titleColor:(UIColor *)titleColor;
@end
