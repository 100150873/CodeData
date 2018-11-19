//
//  UIImageView+ZCExtension.h
//  PJCLitterCost
//
//  Created by yixin on 17/4/6.
//  Copyright © 2017年 ham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ZCExtension)
- (UIImage *)createNewImageWithBackGroundImage:(NSString *)backGroundImage contentText:(NSString *)contentText fontSize:(NSUInteger)fontSize;

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName;

- (void)addGestureTarget:(id)target action:(SEL)seletor;

@end
