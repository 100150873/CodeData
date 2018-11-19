//
//  UIButton+Extension.h
//  PJCLitterCost
//
//  Created by yixin on 17/4/5.
//  Copyright © 2017年 ham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ZCButtonImageTitleStyle) {
    ZCButtonImageTitleStyleLeft   = 0,  //图片在左，文字在右，整体居中。
    ZCButtonImageTitleStyleRight  = 1,  //图片在右，文字在左，整体居中。
    ZCButtonImageTitleStyleTop    = 2,  //图片在上，文字在下，整体居中。
    ZCButtonImageTitleStyleBottom = 3,  //图片在下，文字在上，整体居中。
};

@interface UIButton (Extension)


/**
 利用 UIButton 的 titleEdgeInsets 和 imageEdgeInsets 来实现文字和图片的自由排列
 注意: 这个方法需要在设置图片和文字之后才可以调用, 且 button 的大小要大于图片大小 + 文字大小 + spacing
 */
- (void)setButtonImageTitleStyle:(ZCButtonImageTitleStyle)style
                            spacing:(CGFloat)spacing;



+ (UIButton *)buttonWithImageName:(NSString *)imageName;
/**
 *  创建文字按钮
 *
 *  @param name 按钮名字
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithName:(NSString *)name;

/**
 *  创建一般状态下带文字的按钮
 *
 *  @param name         按钮文字
 *  @param titleColor        普通状态的颜色
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithName:(NSString *)name
                    font:(UIFont *)font
                  titleColor:(UIColor *)titleColor;

/**
 一般状态和选中状态的文字和颜色和大小

 @param normalName <#normalName description#>
 @param normalFont <#normalFont description#>
 @param normalTitleColor <#normalTitleColor description#>
 @param selectedName <#selectedName description#>
 @param selectedFont <#selectedFont description#>
 @param selectedTitleColor <#selectedTitleColor description#>
 @return <#return value description#>
 */
+ (UIButton *)buttonWithNormalName:(NSString *)normalName
                        normalFont:(UIFont *)normalFont
                  normalTitleColor:(UIColor *)normalTitleColor
                      selectedName:(NSString *)selectedName
                      selectedFont:(UIFont *)selectedFont
                selectedTitleColor:(UIColor *)selectedTitleColor;

/**
 创建一般状态下带文字和背景颜色的按钮

 @param name 按钮文字
 @param font 文字大小
 @param titleColor 文字颜色
 @param backGroundColor 文字背景颜色
 @return 按钮
 */
+ (UIButton *)buttonWithName:(NSString *)name
                        font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
             backGroundColor:(UIColor *)backGroundColor;

- (void)setButtonNormalTitle:(NSString *)normalTitle
                        font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
             backGroundColor:(UIColor *)backGroundColor;


/**
 *  创建带文字和一般状态高亮状态的图片按钮
 *
 *  @param name         按钮文字
 *  @param image        普通状态的背景图片
 *  @param hilightImage 高亮状态的背景图片
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithName:(NSString *)name
             normalBackImage:(NSString *)image
         andHilightBackImage:(NSString *)hilightImage;

- (void)setNormalTitle:(NSString*)normalTitle
              fontSize:(UIFont *)fontSize
      normalTitleColor:(UIColor *)normalTitleColor
       normalImageName:(NSString *)normalImageName;
/**
 创建一般状态文字,一般状态和选中状态下带图片的按钮
 
 @param name 按钮一般状态的名字
 @param imageName 按钮一般状态的图片
 @param selectedImageName 按钮选中状态的图片
 @return 按钮
 */
+ (UIButton *)buttonWithName:(NSString *)name
             normalImageName:(NSString *)imageName
        andSelectedImageName:(NSString *)selectedImageName;

/**
 *  创建只有图片的按钮
 *
 *  @param image        普通状态图片
 *  @param hilightImage 高亮状态图片
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithNormalImage:(NSString *)image
                    andHilightImage:(NSString *)hilightImage;

/**
 *  创建一般状态和选择状态下的带图片的按钮
 *
 *  @param image         普通状态图片
 *  @param selectedImage 选择状态图片
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithNormalImage:(NSString *)image
                   andSelectedImage:(NSString *)selectedImage;


/**
 *  创建背景图片按钮
 *
 *  @param backgroundImage 背景图片
 *
 *  @return 按钮
 */
+ (UIButton *)buttonWithBackgroundImage:(NSString *)backgroundImage;

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName
                              imageName:(NSString *)imageName;



/**
 创建一般状态带文字和图片的按钮
 
 @param name 按钮一般状态的名字
 @param imageName 按钮一般状态的图片
 @return 按钮
 */
+ (UIButton *)buttonWithNormalName:(NSString *)name
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                   backGroundColor:(UIColor *)backGroundColor
                   normalImageName:(NSString *)imageName ;

- (void)setButtonNormalTitle:(NSString *)normalTitle
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                   backGroundColor:(UIColor *)backGroundColor
                   normalImageName:(NSString *)imageName;

/**
 创建一般状态下文字和图片文字颜色 选中状态下文字和图片文字颜色 和带背景色及文字大小 的按钮

 @param normalName 一般状态下文字
 @param selectedName 选中状态下文字
 @param normalImageName 一般状态下图片
 @param selectedImageName 选中状态下文字
 @param font 字体大小
 @param normalTitleColor 一般状态字体颜色
 @param selectedTitleColor 选中状态字体颜色
 @param backGroundColor 按钮背景色
 @return 按钮
 */
+ (UIButton *)buttonWithNormalName:(NSString *)normalName
                      selectedName:(NSString *)selectedName
                   normalImageName:(NSString *)normalImageName
                 selectedImageName:(NSString *)selectedImageName
                  normalTitleColor:(UIColor *)normalTitleColor
                selectedTitleColor:(UIColor *)selectedTitleColor
                              font:(UIFont *)font
                   backGroundColor:(UIColor *)backGroundColor;


/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)jk_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/*!
 *  添加边框
 *
 *  @param width 边框宽度
 *  @param color 边框颜色
 *  @param cornerRadius 边框圆角半径
 */
- (void)addBorderWidth:(CGFloat)width WithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (void)addcornerRadius:(CGFloat)cornerRadius;

- (void)setNormalTitle:(NSString *)normalTitle
           normalColor:(UIColor *)normalCorlor
              fontSize:(UIFont *)fontSize;

- (void)setButtonTitleFont:(UIFont *)font normalColor:(UIColor *)normalCorlor;

@end
