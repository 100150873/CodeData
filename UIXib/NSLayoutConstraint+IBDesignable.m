//
//  NSLayoutConstraint+IBDesignable.m
//  ShareChain
//
//  Created by 罗建 on 2018/11/12.
//  Copyright © 2018年 Soway. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"

@implementation NSLayoutConstraint (IBDesignable)

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    adapterScreen = adapterScreen;
    if (adapterScreen){
        self.constant = self.constant * kScreenProportion;
        
    }
}

- (BOOL)adapterScreen{
    return YES;
}


@end



@implementation UILabel (FixScreenFont)

- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.font = [UIFont systemFontOfSize:kScreenProportion * fixWidthScreenFont];
    }else{
        self.font = self.font;
    }
}

- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}

@end


@implementation UIButton (FixScreenFont)

- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.titleLabel.font = [UIFont systemFontOfSize:kScreenProportion * fixWidthScreenFont];
    }else{
        self.titleLabel.font = self.font;
    }
}

- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}

@end



@implementation UITextField (FixScreenFont)

- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.font = [UIFont systemFontOfSize:kScreenProportion * fixWidthScreenFont];
    }else{
        self.font = self.font;
    }
}

- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}

@end

