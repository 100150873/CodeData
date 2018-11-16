//
//  NSLayoutConstraint+IBDesignable.h
//  ShareChain
//
//  Created by 罗建 on 2018/11/12.
//  Copyright © 2018年 Soway. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (IBDesignable)

@property(nonatomic, assign) IBInspectable BOOL adapterScreen;

@end

@interface UILabel (FixScreenFont)

@property (nonatomic)IBInspectable float fixWidthScreenFont;

@end


@interface UIButton (FixScreenFont)

@property (nonatomic)IBInspectable float fixWidthScreenFont;

@end

@interface UITextField (FixScreenFont)

@property (nonatomic)IBInspectable float fixWidthScreenFont;

@end

//

NS_ASSUME_NONNULL_END
