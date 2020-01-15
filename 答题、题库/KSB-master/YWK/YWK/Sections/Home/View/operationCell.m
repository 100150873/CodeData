//
//  operationCell.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/23.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "operationCell.h"

@implementation operationCell{
    UILabel *_content;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _content = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                         andText:@""
                                    andTextColor:[UIColor blackColor]
                                      andBgColor:[UIColor clearColor]
                                         andFont:SYSTEMFONT(14)
                                andTextAlignment:NSTextAlignmentLeft];
        _content.numberOfLines = 0;
        
        [self addSubview:_content];
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
    }
    return  self;
}

-(void)fillWithContent:(NSString *)content
{
    _content.text = content;
}

@end
