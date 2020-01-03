//
//  TableViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "TableViewHeaderView.h"

@implementation TableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = ZCGeneralColor.viewBGColor;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, self.height)];
        self.name.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.name];
    }
    return self;
}

@end
