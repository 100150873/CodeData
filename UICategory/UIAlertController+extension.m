//
//  UIAlertController+extension.m
//  XWAlert
//
//  Created by Apple on 2017/4/3.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

#import "UIAlertController+extension.h"

@implementation UIAlertController (extension)

- (void)addAlertDefaultActionWithTitle:(NSString *_Nullable)title
                               handler:(void (^_Nullable)(UIAlertAction * _Nullable  action))handler
{
    ZCWeakSelf;
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if (handler) {
                                                           handler(action);
                                                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                                       }
                                                   }];
    [weakSelf addAction:action];
}

- (void)addTextFieldWithPlaceholder:(NSString *_Nullable)placeholder
                    secureTextEntry:(BOOL)secureTextEntry
                   textFiledhandler:(void(^_Nullable)(UITextField * _Nonnull textField))textFiledhandler
{

    [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = secureTextEntry;
        textField.placeholder = placeholder;
        __weak typeof(textField) weakTextFiled = textField;
        if (textFiledhandler) {
            textFiledhandler(weakTextFiled);
        }
    }];

}

- (void)addTitleAttributedStringWithFontSize:(UIFont *)font titleColor:(UIColor *)titleColor {
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:self.title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, alertControllerStr.length)];
    [self setValue:alertControllerStr forKey:@"attributedTitle"];
}

- (void)addMessageAttributedStringWithFontSize:(UIFont *)font titleColor:(UIColor *)titleColor {
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:self.message];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, alertControllerStr.length)];
    [self setValue:alertControllerStr forKey:@"attributedMessage"];
    
}

- (void)addCancelActionAttributedStringWithFontSize:(UIFont *)font titleColor:(UIColor *)titleColor {
    for (UIAlertAction *action in self.actions) {
        if (action.style == UIAlertActionStyleCancel) {
            [action setValue:titleColor forKey:@"titleTextColor"];
        }
    }

}

@end
