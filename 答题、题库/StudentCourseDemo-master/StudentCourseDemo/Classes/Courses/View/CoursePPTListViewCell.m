//
//  CoursePPTListViewCell.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursePPTListViewCell.h"
#import "Common.h"
#import "UIImageView+AFNetworking.h"

@interface CoursePPTListViewCell ()
{
    UIImageView *headerImageView;
    UITextField *title;
    UILabel *departmentLabel;
    UILabel *date;
}
@end

@implementation CoursePPTListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView = [[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
         [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        [self addSubview:headerImageView];
        
        title = [[UITextField alloc] init];
        [title setTextColor:[Common translateHexStringToColor:@"121212"]];
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [title setEnabled:NO];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFrame:CGRectMake(75, 8, CGRectGetWidth(self.bounds)-75-10, 20)];

        [self addSubview:title];
        
        departmentLabel = [[UILabel alloc] init];
        [departmentLabel setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [departmentLabel setNumberOfLines:0];
        [departmentLabel setBackgroundColor:[UIColor clearColor]];
        [departmentLabel setFrame:CGRectMake(75, 30, CGRectGetWidth(self.bounds) - 75 - 10, 20)];
        [self addSubview:departmentLabel];
        
        date = [[UILabel alloc] init];
        [date setTextColor:[Common translateHexStringToColor:@"888888"]];
        [date setFont:[UIFont systemFontOfSize:13]];
        [date setNumberOfLines:0];
        [date setBackgroundColor:[UIColor clearColor]];
        [date setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
        [self addSubview:date];
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, k_CourseListView_Height - 10,self.bounds.size.width,1)];
        //separator.backgroundColor = [UIColor darkGrayColor];
        separator.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        //[self addSubview:separator];
        [self addSubview:separator];
        
        
        
    }
    return  self;
}

- (void)setCoursePPT:(CoursePPTObject *)coursePPT
{
    _coursePPT = coursePPT;
    if (_coursePPT.headerImageView.length > 0) {
        [headerImageView setImageWithURL:[NSURL URLWithString:_coursePPT.headerImageView]];
    } else{
        [headerImageView setImage:[UIImage imageNamed:@"userheader"]];
    }
    title.text = _coursePPT.PPTName;
    departmentLabel.text = _coursePPT.CourseName;
    date.text = _coursePPT.date;
    
    [self setNeedsLayout];
}



@end
