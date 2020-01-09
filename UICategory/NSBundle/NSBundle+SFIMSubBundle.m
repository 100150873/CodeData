//
//  NSBundle+SFIMSubBundle.m
//  NIM
//
//  Created by gzc on 2020/1/6.
//  Copyright © 2020 YzChina. All rights reserved.
//

#import "NSBundle+SFIMSubBundle.h"

@implementation NSBundle (SFIMSubBundle)

+ (instancetype)sfim_subBundleWithBundleName:(NSString *)bundleName
                                 targetClass:(Class)targetClass {
    //并没有拿到子bundle
    NSBundle *bundle = [NSBundle bundleForClass:targetClass];
    //在这个路径下找到子bundle的路径
    NSString *path = [bundle pathForResource:bundleName ofType:@"bundle"];
    //根据路径拿到子bundle
    return path?[NSBundle bundleWithPath:path]:[NSBundle mainBundle];
    
    /*
     这种方式也可以
     NSBundle *bundle = [NSBundle bundleForClass:targetClass];
     NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
     return path?[NSBundle bundleWithURL:url]:[NSBundle mainBundle];
     */
}

@end
