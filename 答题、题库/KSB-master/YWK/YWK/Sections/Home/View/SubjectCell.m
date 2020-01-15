//
//  SubjectCell.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/19.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "SubjectCell.h"

@implementation SubjectCell{
    UIImageView *_headView;
    UILabel *_content;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headView = [[UIImageView alloc] init];
        
        _content = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                         andText:@"CD-ROM驱动器、键盘、显示器"
                                    andTextColor:[UIColor blackColor]
                                      andBgColor:[UIColor clearColor]
                                         andFont:SYSTEMFONT(14)
                                andTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:_headView];
        [self addSubview:_content];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_equalTo(@(15));
        }];
        
    }
    return  self;
}


-(void)fillWithTitle:(NSString *)title index:(NSInteger)index;
{
    _content.text = title;
    _content.textColor = [UIColor blackColor];
    switch (index) {
        case 0:{
            _headView.image = [UIImage imageNamed:@"A"];
            
            break;
        }
        case 1:{
            _headView.image = [UIImage imageNamed:@"B"];

            break;
        }

        case 2:{
            _headView.image = [UIImage imageNamed:@"C"];

            break;
        }

        case 3:{
            _headView.image = [UIImage imageNamed:@"D"];

            break;
        }

            
        default:
            break;
    }
}


-(void)isRightWithIndex:(NSInteger)index;
{
    _content.textColor = [UIColor colorWithHexColorString:@"4c9038"];

    switch (index) {
        case 0:{
            _headView.image = [UIImage imageNamed:@"A1"];

            break;
        }
        case 1:{
            _headView.image = [UIImage imageNamed:@"B1"];
      

            break;
        }
            
        case 2:{
            _headView.image = [UIImage imageNamed:@"C1"];
     

            break;
        }
            
        case 3:{
            _headView.image = [UIImage imageNamed:@"D1"];
            break;
        }
            
            
        default:
            break;
    }

}

-(void)isWrong;
{
    _headView.image = [UIImage imageNamed:@"打叉-1"];
    _content.textColor = [UIColor redColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
