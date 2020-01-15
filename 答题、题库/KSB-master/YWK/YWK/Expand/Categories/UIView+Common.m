//
//  UIView+Common.m
//  PaperSource
//
//  Created by Yhoon on 15/11/4.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)drawLineWith:(CGRect)rect{
    UIView *cut = [[UIView alloc] initWithFrame:rect];
    cut.backgroundColor = APP_COLOR_GRAY_cccccc;
    [self addSubview:cut];
}
- (void)drawTopLine{
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, ViewWidth(self), SINGLE_LINE_WIDTH)];
    cut.backgroundColor = APP_COLOR_GRAY_cccccc;
    [self addSubview:cut];
}
- (void)drawBottomLine{
    UIView *cut = [[UIView alloc] init];
    cut.backgroundColor = APP_COLOR_GRAY_cccccc;
    [self addSubview:cut];
    
    [cut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(SINGLE_LINE_WIDTH);
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-SINGLE_LINE_WIDTH);
        make.right.equalTo(self);
    }];
}

@end
