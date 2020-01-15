//
//  CourseVideoListViewCell.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoListViewCell.h"
#import "Common.h"
#import "Config.h"
#import "UIImageView+AFNetworking.h"
@interface CourseVideoListViewCell ()
{
    UIImageView *headerImageView;
    UITextField *videoName;
    UILabel *courseName;
    UILabel *videoLength;
    
}
@end

@implementation CourseVideoListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView = [[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        [self addSubview:headerImageView];
        
        videoName = [[UITextField alloc] init];
        [videoName setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [videoName setFont:[UIFont systemFontOfSize:14]];
        [videoName setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [videoName setBackgroundColor:[UIColor clearColor]];
        [videoName setEnabled:NO];
        [videoName setFrame:CGRectMake(75 , 8, CGRectGetWidth(self.bounds) - 75 - 10, 20)];
        [self addSubview:videoName];
        
        courseName = [[UILabel alloc] init];
        [courseName setTextColor:[Common translateHexStringToColor:@"888888"]];
        [courseName setFont:[UIFont systemFontOfSize:13]];
        [courseName setNumberOfLines:0];
        [courseName setBackgroundColor:[UIColor clearColor]];
        [courseName setFrame:CGRectMake(75, 30, 100, 30)];
        [self addSubview:courseName];
        
        videoLength = [[UILabel alloc] init];
        [videoLength setTextColor:[Common translateHexStringToColor:@"888888"]];
        [videoLength setFont:[UIFont systemFontOfSize:13]];
        [videoLength setNumberOfLines:0];
        [videoLength setBackgroundColor:[UIColor clearColor]];
        [videoLength setFrame:CGRectMake(CGRectGetWidth(self.bounds) - 100, 30, 100, 30)];
        [self addSubview:videoLength];
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, k_CourseVideoListViewCell_Height - 1.0, self.bounds.size.width - 20, 1)];
        
        separator.backgroundColor = [Common translateHexStringToColor:@"e1e1e1"];
        [self addSubview:separator];
        
    }
    return self;
}

- (void)setCoursesVideo:(CourseVideoObject *)coursesVideo
{
    _coursesVideo = coursesVideo;
    if (_coursesVideo.VideoImage) {
        [headerImageView setImageWithURL:[NSURL URLWithString:_coursesVideo.VideoImage]];
    } else{
        [headerImageView setImage:[UIImage imageNamed:@"userheader"]];
    }
    
    // 标题
    videoName.text = _coursesVideo.VideoName;
    if ([_coursesVideo.VideoName length] > 16) {
        courseName.text = [_coursesVideo.CourseName substringFromIndex:16];
    } else{
        courseName.text = coursesVideo.CourseName;
    }
    videoLength.text = [NSString stringWithFormat:@"时间:%@分",_coursesVideo.VideoLength];
    
    [self setNeedsLayout];
}


@end
