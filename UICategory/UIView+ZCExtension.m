//
//  UIView+ZCExtension.m
//  MangocityTravel
//
//  Created by GZCMango on 16/8/17.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import "UIView+ZCExtension.h"
#import <objc/runtime.h>
static char jk_kActionHandlerTapBlockKey;
static char jk_kActionHandlerTapGestureKey;
static char jk_kActionHandlerLongPressBlockKey;
static char jk_kActionHandlerLongPressGestureKey;
@implementation UIView (ZCExtension)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)addcornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)addBorderWidth:(CGFloat)width
             WithColor:(UIColor *)color
          cornerRadius:(CGFloat)cornerRadius {
    [UIColor colorWithHexString:<#(nonnull NSString *)#>]
    [self addcornerRadius:cornerRadius];
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)addShadowWithShdowColor:(UIColor *)shdowColor {
    self.layer.shadowColor = shdowColor.CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.layer.shadowRadius = 1.0;
}

- (void)addShadowWithShdowColor:(UIColor *)shdowColor offSety:(CGFloat)y {
    self.layer.shadowColor = shdowColor.CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0, y);
    self.layer.shadowRadius = 1.0;
}

- (void)jk_addTapActionWithBlock:(JKGestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &jk_kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jk_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &jk_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &jk_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)jk_handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        JKGestureActionBlock block = objc_getAssociatedObject(self, &jk_kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}
- (void)jk_addLongPressActionWithBlock:(JKGestureActionBlock)block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &jk_kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jk_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &jk_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &jk_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)jk_handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        JKGestureActionBlock block = objc_getAssociatedObject(self, &jk_kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}


@end
