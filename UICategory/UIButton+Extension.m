//
//  UIButton+Extension.m
//  PJCLitterCost
//
//  Created by yixin on 17/4/5.
//  Copyright © 2017年 ham. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
#pragma mark 创建按钮

- (void)setButtonImageTitleStyle:(ZCButtonImageTitleStyle)style
                            spacing:(CGFloat)spacing {
  
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = [self.titleLabel.text widthForFont:self.titleLabel.font];
    CGFloat labelHeight = [self.titleLabel.text heightForFont:self.titleLabel.font
                                                           width:labelWidth];
    
    //  image中心移动的X距离
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    //  image中心移动的Y距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;
    
    //  label中心移动的X距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    //  label中心移动的Y距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    switch (style) {
        case ZCButtonImageTitleStyleLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, - spacing / 2, 0, spacing / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, - spacing / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, spacing / 2);
        }
            break;
        case ZCButtonImageTitleStyleRight: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing / 2, 0, - (labelWidth + spacing / 2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - (imageWidth + spacing / 2), 0, imageWidth + spacing / 2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, spacing / 2);
        }
            break;
        case ZCButtonImageTitleStyleTop: {
            self.imageEdgeInsets = UIEdgeInsetsMake(- imageOffsetY, imageOffsetX, imageOffsetY, - imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, - labelOffsetX, - labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, - changedWidth / 2, changedHeight - imageOffsetY, - changedWidth / 2);
        }
            break;
        case ZCButtonImageTitleStyleBottom: {
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, - imageOffsetY, - imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(- labelOffsetY, - labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight - imageOffsetY, - changedWidth / 2, imageOffsetY, - changedWidth / 2);
        }
            break;
    }
}


+ (UIButton *)buttonWithName:(NSString *)name
                    font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    return btn;
}

+ (UIButton *)buttonWithNormalName:(NSString *)normalName
                              normalFont:(UIFont *)normalFont
                        normalTitleColor:(UIColor *)normalTitleColor
                      selectedName:(NSString *)selectedName
                              selectedFont:(UIFont *)selectedFont
                        selectedTitleColor:(UIColor *)selectedTitleColor {
    UIButton* btn = [self buttonWithName:normalName font:normalFont titleColor:normalTitleColor];
    [btn setTitle:selectedName forState:UIControlStateSelected];
    [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    return btn;
}

+ (UIButton *)buttonWithName:(NSString *)name
                    font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
             backGroundColor:(UIColor *)backGroundColor
{
    UIButton* btn = [self buttonWithName:name font:font titleColor:titleColor];
    [btn setBackgroundColor:backGroundColor];
    return btn;
}

- (void)setButtonNormalTitle:(NSString *)normalTitle
                        font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
             backGroundColor:(UIColor *)backGroundColor
{
    [self setTitle:normalTitle forState:0];
    self.titleLabel.font = font;
    [self setTitleColor:titleColor forState:0];
    [self setBackgroundColor:backGroundColor];
}

+ (UIButton*)buttonWithName:(NSString*)name normalBackImage:(NSString*)image andHilightBackImage:(NSString*)hilightImage {
    
    UIImage *normalImage = [UIImage imageNamed:image];
    UIImage *hightlightImage = [UIImage imageNamed:hilightImage];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:55 topCapHeight:17];
    hightlightImage = [hightlightImage stretchableImageWithLeftCapWidth:55 topCapHeight:17];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont fontWithName:@"STHeiti" size:15.0f];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:hightlightImage forState:UIControlStateHighlighted];
    return btn;
}

+ (UIButton*)buttonWithNormalImage:(NSString*)image andHilightImage:(NSString*)hilightImage
{
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hilightImage] forState:UIControlStateHighlighted];
    return btn;
}
+ (UIButton*)buttonWithNormalImage:(NSString*)image andSelectedImage:(NSString*)selectedImage {

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    return btn;
}
- (void)setNormalTitle:(NSString*)normalTitle
              fontSize:(UIFont *)fontSize
      normalTitleColor:(UIColor *)normalTitleColor
       normalImageName:(NSString *)normalImageName {
    [self setTitle:normalTitle forState:0];
    self.titleLabel.font = fontSize;
    [self setTitleColor:normalTitleColor forState:0];
    [self setImage:[UIImage imageNamed:normalImageName] forState:0];
}

+ (UIButton *)buttonWithName:(NSString *)name {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tintColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:20];
    return btn;
}

+ (UIButton *)buttonWithBackgroundImage:(NSString *)backgroundImage {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName
                              imageName:(NSString *)imageName {
    UIButton *btn = [self buttonWithBackgroundImage:backgroundImageName];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName]  forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)buttonWithName:(NSString *)name normalImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateSelected];
//    [btn setTitleColor:RGBColor(73, 73, 73) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    return btn;

}

+ (UIButton *)buttonWithNormalName:(NSString *)normalName
                      selectedName:(NSString *)selectedName
                   normalImageName:(NSString *)normalImageName
                 selectedImageName:(NSString *)selectedImageName
                  normalTitleColor:(UIColor *)normalTitleColor
                selectedTitleColor:(UIColor *)selectedTitleColor
                              font:(UIFont *)font
                   backGroundColor:(UIColor *)backGroundColor {
    UIButton *btn = [self buttonWithNormalName:normalName font:font titleColor:normalTitleColor backGroundColor:backGroundColor normalImageName:normalImageName];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [btn setTitle:selectedName forState:UIControlStateSelected];
    return btn;
}

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)jk_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton jk_b_imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)jk_b_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIButton *)buttonWithNormalName:(NSString *)name
                              font:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                   backGroundColor:(UIColor *)backGroundColor
                   normalImageName:(NSString *)imageName {
    
    UIButton *btn = [self buttonWithName:name font:font titleColor:titleColor backGroundColor:backGroundColor];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

- (void)setButtonNormalTitle:(NSString *)normalTitle
                        font:(UIFont *)font
                  titleColor:(UIColor *)titleColor
             backGroundColor:(UIColor *)backGroundColor
             normalImageName:(NSString *)imageName {
    
    [self setImage:[UIImage imageNamed:imageName] forState:0];
    [self setTitleColor:titleColor forState:0];
    [self setTitle:normalTitle forState:0];
    self.titleLabel.font = font;
    self.backgroundColor = backGroundColor;
}

- (void)addcornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = YES;
}

- (void)addBorderWidth:(CGFloat)width WithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    [self addcornerRadius:cornerRadius];
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setButtonTitleFont:(UIFont *)font normalColor:(UIColor *)normalCorlor
{
    self.titleLabel.font = font;
    [self setTitleColor:normalCorlor forState:UIControlStateNormal];
}

- (void)setNormalTitle:(NSString *)normalTitle
           normalColor:(UIColor *)normalCorlor
              fontSize:(UIFont *)fontSize {
    [self setTitle:normalTitle forState:0];
    [self setButtonTitleFont:fontSize normalColor:normalCorlor];
}

@end
