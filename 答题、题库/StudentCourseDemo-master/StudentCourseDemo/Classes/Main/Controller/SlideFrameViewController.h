//
//  SlideFrameViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "CourseListJsonHandler.h"
#import "CoursePPTListJsonHandler.h"
#import "LeftMenuViewController.h"
#import "CoursePPTViewController.h"
#import "StudentCoursesListViewController.h"
#import "BaseViewController.h"
#import "CoursePPtShowViewController.h"
#import "CourseVideoViewController.h"
#import "CourseVideoListJsonHandler.h"

#import "IndexSlideViewController.h"
#import "QuestionListJsonHandler.h"
#import "QuestionViewController.h"
#import "QuestionListViewController.h"


//typedef NS_ENUM(NSInteger,LeftIndex){
//    LeftIndexStudentCourse,
//    LeftIndexCoursePPt
//};

@interface SlideFrameViewController : UIViewController<RESideMenuDelegate,CourseListJsonHandlerDelegate,CoursePPTListJsonHandlerDelegate,LeftMenuViewControllerDelegate,CoursePPTViewControllerDelegate,StudentCoursesListViewDelegate,CoursePPtShowViewControllerDelegate,CourseVideoListJsonHandlerDelegate,CourseVideoViewControllerDelegate,QuestionListViewControllerDelegate,QuestionViewControllerDelegate,QuestionListJsonHandlerDelegate,IndexSlideViewControllerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
//@property (nonatomic,readonly,assign) LeftIndex selectedIndex;

@end
