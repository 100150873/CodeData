//
//  UIView+ZCExtension.h
//  MangocityTravel
//
//  Created by GZCMango on 16/8/17.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JKGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (ZCExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (UIViewController *)viewController;
/*!
 *  添加边框
 *
 *  @param width 边框宽度
 *  @param color 边框颜色
 *  @param cornerRadius 边框圆角半径
 */
- (void)addBorderWidth:(CGFloat)width
             WithColor:(UIColor *)color
          cornerRadius:(CGFloat)cornerRadius;

- (void)addcornerRadius:(CGFloat)cornerRadius;

- (void)addShadowWithShdowColor:(UIColor *)shdowColor;

- (void)addShadowWithShdowColor:(UIColor *)shdowColor offSety:(CGFloat)y;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)jk_addTapActionWithBlock:(JKGestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)jk_addLongPressActionWithBlock:(JKGestureActionBlock)block;
@end
