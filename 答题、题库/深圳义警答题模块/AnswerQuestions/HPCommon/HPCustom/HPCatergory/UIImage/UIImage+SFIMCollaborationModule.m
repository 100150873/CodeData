//
//  UIImage+SFIMCollaborationModule.m
//  AFNetworking
//
//  Created by gzc on 2020/1/9.
//

#import "UIImage+SFIMCollaborationModule.h"

@implementation UIImage (SFIMCollaborationModule)

+ (instancetype)sfimCollaborationModule_imageWithName:(NSString *)name
                                               bundle:(NSString *)bundleName
                                          targetClass:(Class)targetClass {
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSBundle *curB = [NSBundle bundleForClass:targetClass];
    NSString *imgName = [NSString stringWithFormat:@"%@@%zdx.png", name,scale];
    NSString *dir = [NSString stringWithFormat:@"%@",bundleName];
    NSString *path = [curB pathForResource:imgName ofType:nil inDirectory:dir];
    return path?[UIImage imageWithContentsOfFile:path]:nil;
}


@end




