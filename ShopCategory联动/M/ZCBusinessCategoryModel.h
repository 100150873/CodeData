//
//  ZCBusinessCategoryModel.h
//  OpenShop
//
//  Created by GZC on 2018/12/11.
//  Copyright © 2018年 SuWei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZCBusinessCategoryModel :NSObject

@property (nonatomic , assign) BOOL              Selected;
@property (nonatomic , assign) BOOL              Disabled;
@property (nonatomic , copy) NSString              * Text;
@property (nonatomic , copy) NSString              * Value;
@property (nonatomic , assign) NSString              * ParentValue;

@end


NS_ASSUME_NONNULL_END
