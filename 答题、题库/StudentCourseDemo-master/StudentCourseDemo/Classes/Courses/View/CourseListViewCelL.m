//
//  CourseListViewCelL.m
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import "CourseListViewCelL.h"
#import "Config.h"
#import "Common.h"
@interface CourseListViewCelL()
{
    UIImageView *headerImageView;
    UITextField *courseName;
    UILabel *departmentLabel;
    UIButton *pptBtn;
    UIButton *wordBtn;
    UIButton *videoBtn;
    UIButton *introductionBtn;
    
}
@end

@implementation CourseListViewCelL

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, k_CoursesListCell_Height- 10)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView.layer setCornerRadius:3];
        [bgView.layer setBorderWidth:1.0f];
        [bgView.layer setBorderColor:[UIColor colorWithWhite:0.0f alpha:0.1].CGColor];
        [self addSubview:bgView];
        
        headerImageView = [[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeLeft];
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        [bgView addSubview:headerImageView];
        
        courseName = [[UITextField alloc] init];
        [courseName setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [courseName setFont:[UIFont boldSystemFontOfSize:14]];
        [courseName setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [courseName setEnabled:NO];
        [courseName setBackgroundColor:[UIColor clearColor]];
        [courseName setFrame:CGRectMake(75, 8, CGRectGetWidth(bgView.bounds)- 10 -75, 20)];
        [bgView addSubview:courseName];
        
        departmentLabel = [[UILabel alloc] init];
        [departmentLabel setTextColor:[Common translateHexStringToColor:@"888888"]];
        [departmentLabel setFont:[UIFont systemFontOfSize:13]];
        [departmentLabel setNumberOfLines:0];
        [departmentLabel setBackgroundColor:[UIColor clearColor]];
        [departmentLabel setFrame:CGRectMake(75, 30, CGRectGetWidth(self.bounds) - 75 - 10, 20)];
//        NSLog(@" CGRectGetWidth(self.bounds) - 75 - 10---%f", CGRectGetWidth(self.bounds) - 75 - 10);
//        [departmentLabel setFrame:CGRectMake(75, 30, 100, 30)];
        [bgView addSubview:departmentLabel];
        
        pptBtn = [[UIButton alloc] init];
        
        [pptBtn setTitle:@"PPT" forState:UIControlStateNormal];
        [pptBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [pptBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [pptBtn setBackgroundImage:[UIImage imageNamed:@"cellBtn"] forState:UIControlStateNormal];
        [pptBtn setFrame:CGRectMake(10, 70, 54, 24)];
        [pptBtn addTarget:self action:@selector(pptFocus) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:pptBtn];
        
        videoBtn = [[UIButton alloc] init];
        [videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [videoBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [videoBtn setBackgroundImage:[UIImage imageNamed:@"cellBtn"] forState:UIControlStateNormal];
        [videoBtn setFrame:CGRectMake(70, 70, 54, 24)];
        [videoBtn addTarget:self action:@selector(videoFocus) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:videoBtn];
        
        introductionBtn = [[UIButton alloc] init];
        [introductionBtn setTitle:@"课程简介" forState:UIControlStateNormal];
        [introductionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [introductionBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [introductionBtn setBackgroundImage:[UIImage imageNamed:@"cellBtn"] forState:UIControlStateNormal];
        [introductionBtn setFrame:CGRectMake(130, 70, 54, 24)];
        [introductionBtn addTarget:self action:@selector(courseIntroductionFocus) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:introductionBtn];
        
    }
    return  self;
}

- (void)setCourses:(CoursesObject *)courses
{
    _courses = courses;
//    if (_courses) {
//        [headerImageView setImage:[UIImage imageNamed:@"userheader@2x"]];
//    } else{
//        [headerImageView setImage:[UIImage imageNamed:@"userheader@2x"]];
//    }
    [headerImageView setImage:[UIImage imageNamed:@"userheader"]];
    // 标题
    courseName.text = _courses.CourseName;
    departmentLabel.text = _courses.DepartmentName;
    
//    NSLog(@"_courses.CourseID--%d",_courses.CourseID);
//    pptBtn.tag = _courses.CourseID;
//    if (_courses.) {
//        <#statements#>
//    }
    
    
    [self setNeedsLayout];
}
- (void)pptFocus
{
//    NSLog(@"pptFocus");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(coursesListPptFocus:)]) {
//        NSLog(@"pptFocus2");
//        pptBtn  = [[UIButton alloc] init];
//        NSLog(@"self.tag---%d",self.tag);
        [self.delegate coursesListPptFocus:self.tag];
//        NSLog(@"pptFocus2");
    }
}

- (void)videoFocus
{
    NSLog(@"videoFocus");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(coursesListVideoFocus:)]) {
        [self.delegate coursesListVideoFocus:self.tag];
    }
}

- (void)courseIntroductionFocus
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(coursesListIntroductionFocus:)]) {
        [self.delegate coursesListIntroductionFocus:self.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}


@end
