//
//  CourseListJsonHandler.h
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoursesObject.h"
@protocol CourseListJsonHandlerDelegate;
@interface CourseListJsonHandler : NSObject
@property (nonatomic,weak) id <CourseListJsonHandlerDelegate> delegate;

// 刷新数据
- (void)handlerCourseObject:(CoursesObject *)cOjb currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize;
// 判断刷新是否加载更多
@property (nonatomic,strong) NSString *ID;

@end
@protocol CourseListJsonHandlerDelegate <NSObject>
@optional
- (void)CourseListJsonHandler:(CourseListJsonHandler *)handler withResult:(NSString *)result;

@end

/**
 *
 NSString *url=@"http://www.dota2ms.com/Service.asmx/TeacherCourseClassSelect?TeacherID=yas&ClassID={CLASSID}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
 url=[url stringByReplacingOccurrencesOfString:@"{CLASSID}" withString:[NSString stringWithFormat:@"%d",cOjb.ClassID]];
 url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
 url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
 NSLog(@"url---%@",url);
 NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
 AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"responseObject---%@",[responseObject JSONValue]);
 if (self.delegate) {
 [self.delegate CourseListJsonHandler:self  withResult:responseObject];
 
 }
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 //[loadingLabel setText:@"加载失败"];
 [SVProgressHUD showErrorWithStatus:@"加载失败"];
 }];
 [operation start];

 */
