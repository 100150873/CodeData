//
//  CourseVideoListJsonHandler.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseVideoObject.h"
#import "CoursesObject.h"

@protocol CourseVideoListJsonHandlerDelegate;
@interface CourseVideoListJsonHandler : NSObject
@property (nonatomic,weak) id<CourseVideoListJsonHandlerDelegate> delegate;
@property (nonatomic,strong) NSString *ID;
- (void)handlerCourseVideoObject:(CoursesObject *)cObj cuurentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
@end
@protocol CourseVideoListJsonHandlerDelegate <NSObject>

@optional
- (void)CourseVideoListJsonHandler:(CourseVideoListJsonHandler *)handler withResult:(NSString *)result;

@end
