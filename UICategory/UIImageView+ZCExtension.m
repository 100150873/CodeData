//
//  UIImageView+ZCExtension.m
//  PJCLitterCost
//
//  Created by yixin on 17/4/6.
//  Copyright © 2017年 ham. All rights reserved.
//

#import "UIImageView+ZCExtension.h"

@implementation UIImageView (ZCExtension)

- (UIImage *)createNewImageWithBackGroundImage:(NSString *)backGroundImage contentText:(NSString *)contentText fontSize:(NSUInteger)fontSize

{
    
    UIImage *image = [UIImage imageNamed:backGroundImage];
    
    CGSize size=CGSizeMake(image.size.width, image.size.height);//画布大小
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [image drawAtPoint:CGPointMake(0, 0)];
    
    //获得一个位图图形上下文
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGSize textSize = [contentText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    [contentText drawAtPoint:CGPointMake((size.width - textSize.width ) * 0.5, (size.height - textSize.height ) * 0.5) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

- (void)addGestureTarget:(id)target action:(SEL)seletor
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:seletor];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

@end
