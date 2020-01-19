//
//  UIImage+SFIMCollaborationModule.h
//  AFNetworking
//
//  Created by gzc on 2020/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SFIMCollaborationModule)

+ (instancetype)sfimCollaborationModule_imageWithName:(NSString *)name
                                               bundle:(NSString *)bundleName
                                          targetClass:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
