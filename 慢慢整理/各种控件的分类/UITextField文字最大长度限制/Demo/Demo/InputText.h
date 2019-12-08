//
//  TextLimit.h
//  FuzeGameApp
//
//  Created by 索泽文 on 16/1/23.
//  Copyright © 2015年 fuzegame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITextField (limit)
@property (nonatomic, assign) NSUInteger maxTextLength;
@end

@interface UITextView (limit)
@property (nonatomic, assign) NSUInteger maxTextLength;
@end




@interface UITextField (placeHolder)
@property (nonatomic, strong) UIColor *placeHolderColor;
@end

@interface UITextView (placeHolder)
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeHolderColor;
@end
