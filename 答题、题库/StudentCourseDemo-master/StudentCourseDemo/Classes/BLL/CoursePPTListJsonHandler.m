//
//  CoursePPTListJsonHandler.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursePPTListJsonHandler.h"
#import "AFNetworking.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "CoursesObject.h"
@implementation CoursePPTListJsonHandler
- (void)handlerCoursePPTObject:(CoursesObject *)cObj currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize
{
    
//    NSLog(@"cpObj.CourseID---%d",cObj.CourseID);
    NSString *url = @"http://www.dota2ms.com/Service.asmx/CoursesPPTGetByID?CourseID={COURSEID}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url = [url stringByReplacingOccurrencesOfString:@"{COURSEID}" withString:[NSString stringWithFormat:@"%d",cObj.CourseID]];
    url = [url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url = [url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//       NSLog(@"url---%@",url);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//     NSLog(@"handlerCoursePPTObject---%@",[responseObject JSONValue]);
        if (self.delegate) {
//             NSLog(@"responseObject---%@",[responseObject JSONValue]);
            [self.delegate CoursePPTListHandler:self withResult:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [operation start];
}
@end
