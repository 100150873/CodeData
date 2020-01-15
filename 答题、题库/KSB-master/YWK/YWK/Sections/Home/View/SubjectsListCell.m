//
//  SubjectsListCell.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/18.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "SubjectsListCell.h"

@implementation SubjectsListCell{
    UILabel *_title;
    UILabel *_content;
    UIImageView *_back;

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
        _title = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                       andText:@"计算机一级office历年真题1"
                                  andTextColor:[UIColor blackColor]
                                    andBgColor:[UIColor clearColor]
                                       andFont:SYSTEMFONT(14)
                              andTextAlignment:NSTextAlignmentLeft];
        
        _content = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                       andText:@"共30题 已完成0题"
                                  andTextColor:[UIColor blackColor]
                                    andBgColor:[UIColor clearColor]
                                       andFont:SYSTEMFONT(12)
                              andTextAlignment:NSTextAlignmentLeft];
        
        _back = [[UIImageView alloc] init];
        _back.image = [UIImage imageNamed:@"返回-"];

        [self addSubview:_title];
        [self addSubview:_content];
        [self addSubview:_back];

        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-30);
            make.bottom.equalTo(self.mas_centerY).offset(-2);
            make.height.mas_equalTo(@(16));
        }];
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-30);
            make.top.equalTo(self.mas_centerY).offset(2);
            make.height.mas_equalTo(@(16));
        }];

        [_back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.equalTo(self.mas_right).offset(-12);
            make.width.equalTo(@8);
            make.height.equalTo(@13);
        }];

        
    }
    return  self;
}


-(void)fillWithTitle:(NSString *)title index:(NSInteger)index;
{
    
    NSString *str = [NSString stringWithFormat:@"%ld",index];
    NSDictionary *dic =  DEFAULTS_GET_OBJ(str);
    
    _title.text = title;
    _content.text = [NSString stringWithFormat:@"共50题 已完成%ld题",dic.count];
}


@end
