//
//  TextLimit.m
//  FuzeGameApp
//
//  Created by 索泽文 on 16/1/23.
//  Copyright © 2015年 fuzegame. All rights reserved.
//

#import "InputText.h"
#import <objc/runtime.h>

#pragma mark -**********************************  placeHolder  **************************************
@implementation UITextField (placeHolder)

static char placeHolderColorKey;
- (UIColor *)placeHolderColor
{
    return objc_getAssociatedObject(self, &placeHolderColorKey);
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    UIColor *color = placeHolderColor?placeHolderColor:[UIColor redColor];
    if (self.placeholder.length == 0) {
        self.placeholder = @" ";
    }
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    objc_setAssociatedObject(self, &placeHolderColorKey, placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end




@implementation UITextView (placeHolder)
+ (void)load
{
    [super load];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object: nil];
    swizzle([UIImage class], @selector(_setText:), @selector(setText:));
    swizzle([UIImage class], @selector(_setAttributedText:), @selector(setAttributedText:));


}

/**
 * 监听文字改变
 */
+ (void)textDidChange: (NSNotification *) notificaiton
{
    UITextView *textView = (UITextView *)notificaiton.object;
    [textView textDidChange];
}
- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText;
}
- (void)_setText:(NSString *)text
{
    self.text = text;
    [self textDidChange];
}
- (void)_setAttributedText:(NSAttributedString *)attributedText
{
    self.attributedText = attributedText;
    [self textDidChange];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
static char placeholderLabelKey;
- (void)setPlaceholderLabel:(UILabel *)placeholderLabel
{
    objc_setAssociatedObject(self, &placeholderLabelKey, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, &placeholderLabelKey);
    if (label) {
        return label;
        
    }
    CGFloat y = self.textContainerInset.top;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(4, y, 250, self.font.lineHeight)];
    label.font = self.font;
    objc_setAssociatedObject(self, &placeholderLabelKey, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:label];
    return label;
}


static char textViewPlaceHolderColorKey;
- (UIColor *)placeHolderColor {
    UIColor *color = objc_getAssociatedObject(self, &textViewPlaceHolderColorKey);
    if (color) {
        return color;
    }
    color = [UIColor lightGrayColor];
    objc_setAssociatedObject(self, &textViewPlaceHolderColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    self.placeholderLabel.textColor = placeHolderColor;
    objc_setAssociatedObject(self, &textViewPlaceHolderColorKey, placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char textViewPlaceHolderKey;
- (NSString *)placeholder {
    NSString *str = objc_getAssociatedObject(self, &textViewPlaceHolderKey);
    if (str) {
        return str;
    }
    str = [[NSString alloc] init];
    objc_setAssociatedObject(self, &textViewPlaceHolderKey, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return str;
}


- (void)setPlaceholder:(NSString *)placeholder
{
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.textColor = self.placeHolderColor;

    objc_setAssociatedObject(self, &textViewPlaceHolderKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//静态就交换静态，实例方法就交换实例方法
void swizzle(Class c,SEL origSEL,SEL newSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!origMethod) {
        origMethod = class_getClassMethod(c, origSEL);
        if (!origMethod) {
            return;
        }
        newMethod = class_getClassMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }else{
        newMethod = class_getInstanceMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
        
    }
    //自身已经有了就添加不成功，直接交换即可
    if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
    
}
@end





#pragma mark -**********************************  limit  **************************************
@implementation UITextField (limit)

static char textFieldMaxKey;
- (NSUInteger)maxTextLength
{
    return [objc_getAssociatedObject(self, &textFieldMaxKey) integerValue];
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength
{
    objc_setAssociatedObject(self, &textFieldMaxKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end





@implementation UITextView (limit)
static char textViewMaxKey;
- (NSUInteger)maxTextLength
{
    return [objc_getAssociatedObject(self, &textViewMaxKey) integerValue];
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength
{
    objc_setAssociatedObject(self, &textViewMaxKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end






@interface TextLimit:NSObject
@end
@implementation TextLimit

+ (void)load
{
    [super load];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object: nil];
}

#pragma mark - 通知事件
+ (void)textFieldDidChange:(NSNotification*)notification
{
    UITextField *textField = (UITextField *)notification.object;
    
    NSUInteger maxTextLength = textField.maxTextLength;
    if (maxTextLength && textField.text.length > maxTextLength && textField.markedTextRange == nil) {
        textField.text = [textField.text substringWithRange: NSMakeRange(0, maxTextLength)];
    }
}


+ (void)textViewDidChange: (NSNotification *) notificaiton
{
    UITextView *textView = (UITextView *)notificaiton.object;
    NSUInteger maxTextLength = textView.maxTextLength;
    
    if (maxTextLength && textView.text.length > maxTextLength && textView.markedTextRange == nil) {
        textView.text = [textView.text substringWithRange: NSMakeRange(0, maxTextLength)];
    }
}
@end
