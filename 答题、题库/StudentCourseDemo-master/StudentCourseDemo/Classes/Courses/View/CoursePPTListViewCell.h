//
//  CoursePPTListViewCell.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursePPTObject.h"
#define k_CourseListView_Height 70.0f
@interface CoursePPTListViewCell : UITableViewCell
@property (nonatomic,strong) CoursePPTObject *coursePPT;
@end
