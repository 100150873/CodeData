//
//  StudentCoursesListViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/2.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseListJsonHandler.h"
#import "CourseListViewCelL.h"
#import "RefreshFooterView.h"
#import "BaseViewController.h"
@class CoursePPTObject;
@protocol StudentCoursesListViewDelegate;
@interface StudentCoursesListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CourseListJsonHandlerDelegate,RefreshFooterViewDelegate>
@property (nonatomic,assign) id<StudentCoursesListViewDelegate> delegate;
@end
@protocol StudentCoursesListViewDelegate <NSObject>
- (void)showPPTHomeView:(CoursesObject *)obj;
- (void)showVideoHomeView:(CoursesObject *)obj;
@end