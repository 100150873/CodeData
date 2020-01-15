//
//  NSBundle+SFIMSubBundle.h
//  NIM
//
//  Created by gzc on 2020/1/6.
//  Copyright © 2020 YzChina. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (SFIMSubBundle)

+ (instancetype)sfim_subBundleWithBundleName:(NSString *)bundleName
                                 targetClass:(Class)targetClass;
@end

NS_ASSUME_NONNULL_END
