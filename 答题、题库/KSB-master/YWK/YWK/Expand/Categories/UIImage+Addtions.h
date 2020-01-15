//
//  UIImage+Addtions.h
//  DispathOnLine
//
//  Created by 苏凡 on 16/3/16.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Addtions)

//调整图片为正确的位置
- (UIImage *)fixOrientation;

//压缩图片成数据流
- (NSData *)scaleToSize;

@end
