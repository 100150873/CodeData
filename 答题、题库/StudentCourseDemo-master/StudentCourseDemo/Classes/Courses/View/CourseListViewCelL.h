//
//  CourseListViewCelL.h
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesObject.h"
@protocol CoursesCellDelegate;

@interface CourseListViewCelL : UITableViewCell
@property (nonatomic,strong) CoursesObject *courses;
@property (nonatomic,assign) id<CoursesCellDelegate> delegate;

@end


@protocol CoursesCellDelegate <NSObject>

@optional
- (void)coursesListPptFocus:(int)index;

- (void)coursesListVideoFocus:(int)index;

- (void)coursesListIntroductionFocus:(int)index;

@end
