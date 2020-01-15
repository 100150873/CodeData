//
//  CourseVideoListViewCell.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseVideoObject.h"
#define k_CourseVideoListViewCell_Height 70.0f
@interface CourseVideoListViewCell : UITableViewCell
@property (nonatomic,strong) CourseVideoObject *coursesVideo;
@end
