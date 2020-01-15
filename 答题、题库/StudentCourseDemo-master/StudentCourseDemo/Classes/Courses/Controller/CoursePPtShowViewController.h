//
//  CoursePPtShowViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "CoursePPTObject.h"
#import "CoursesObject.h"

@protocol CoursePPtShowViewControllerDelegate;
@interface CoursePPtShowViewController : BaseViewController <UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic,weak) id<CoursePPtShowViewControllerDelegate> delegate;
@property (nonatomic,strong) CoursePPTObject *coursePPtObj;
//@property (nonatomic,assign) BOOL isFrom

- (void)startLoading;
- (void)endLoading;
- (void)reset;
@end

@protocol CoursePPtShowViewControllerDelegate <NSObject>

- (void)CoursePPtShowViewControllerBack:(CoursePPtShowViewController *)CoursesPPtShowVC;
//- (void)CoursePPTShowViewControlle

@end
