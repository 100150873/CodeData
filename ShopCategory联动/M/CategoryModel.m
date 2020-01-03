//
//  CategoryModel.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CategoryModel.h"

@implementation CategoryModel
//返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
             @"spus" : [FoodModel class]
             };
}

@end

@implementation FoodModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{ @"foodId": @"id" };
}

@end
