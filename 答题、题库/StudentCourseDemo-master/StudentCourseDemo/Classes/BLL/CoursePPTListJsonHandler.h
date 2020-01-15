//
//  CoursePPTListJsonHandler.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursePPTObject.h"
#import "CoursesObject.h"
@protocol CoursePPTListJsonHandlerDelegate;
@interface CoursePPTListJsonHandler : NSObject
@property (nonatomic,weak) id <CoursePPTListJsonHandlerDelegate> delegate;
// 刷新数据
- (void)handlerCoursePPTObject:(CoursesObject *)cObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
// 判断刷新是否加载更多
@property (nonatomic,strong) NSString *ID;

@end


@protocol CoursePPTListJsonHandlerDelegate <NSObject>

@optional
- (void)CoursePPTListHandler:(CoursePPTListJsonHandler *)handler withResult:(NSString *)result;

@end