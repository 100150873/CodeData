//
//  RightTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "RightTableViewCell.h"
#import "CategoryModel.h"

@interface RightTableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
//        [self.contentView addSubview:self.imageV];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 15)];
        self.nameLabel.centerY = 25;
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nameLabel];
        
//        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 30)];
//        self.priceLabel.font = [UIFont systemFontOfSize:14];
//        self.priceLabel.textColor = [UIColor redColor];
//        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)setModel:(FoodModel *)model
{
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.nameLabel.text = model.name;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",@(model.min_price)];
}

- (void)setTitle:(NSString *)title {
    
    self.nameLabel.text = title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    self.nameLabel.textColor = selected ? ZCGeneralColor.mainColor : ZCGeneralColor.contentColor_66;
    self.contentView.backgroundColor =  [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
