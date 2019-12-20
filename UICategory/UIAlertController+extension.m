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

- (UILabel *)sfim_messageLabel {
    UIView *subView1 = [self.view.subviews sfim_safeObjectAtIndex:0];
    UIView *subView2 = [subView1.subviews sfim_safeObjectAtIndex:0];
    UIView *subView3 = [subView2.subviews sfim_safeObjectAtIndex:0];
    UIView *subView4 = [subView3.subviews sfim_safeObjectAtIndex:0];
    //这一层一般是放title 和 message label的view
    UIView *subView5 = [subView4.subviews sfim_safeObjectAtIndex:0];
    NSArray *subviewArray = subView5.subviews;
    //取出所有label (iOS10及以下第一个和第二个是label,ios12是第二个第三个是label,所以直接遍历取出所有label)
    NSMutableArray *labelArray = [NSMutableArray array];
    [subviewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UILabel.class]) {
            [labelArray sfim_safeAddObject:obj];
        }
    }];
    //取出消息展示label
    UILabel *messageLabel = [labelArray sfim_safeObjectAtIndex:1];
    return messageLabel;
}


@end
