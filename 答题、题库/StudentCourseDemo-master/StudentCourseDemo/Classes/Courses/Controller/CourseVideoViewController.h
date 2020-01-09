//
//  CourseVideoViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseVideoListJsonHandler.h"
#import "RefreshFooterView.h"
#import "CoursesObject.h"
@protocol CourseVideoViewControllerDelegate;
@interface CourseVideoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshFooterViewDelegate>
@property (nonatomic,weak) id<CourseVideoViewControllerDelegate> delegate;
@property (nonatomic,strong) CoursesObject *courseObj;
- (void)reset;
@end
@protocol CourseVideoViewControllerDelegate <NSObject>
- (void)courseVideoGoBack;
- (void)CourseVideoPlayShow:(CourseVideoViewController *)listVC selectedCourseVideoObject:(CourseVideoObject *)cvObj;

@end
