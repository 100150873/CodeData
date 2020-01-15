//
//  CourseVideoListJsonHandler.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/8.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoListJsonHandler.h"
#import "AFNetworking.h"
#import "Common.h"
#import "Config.h"
#import "JSON.h"
#import "SVProgressHUD.h"
#import "CoursesObject.h"
@implementation CourseVideoListJsonHandler

-(void)handlerCourseVideoObject:(CoursesObject *)cObj cuurentPageIndex:(int)currentPageIndex pageSize:(int)pageSize
{
    
    NSString *url =@"http://www.dota2ms.com/Service.asmx/CoursesVideoGetByID?CourseID={COURSEID}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    
    url = [url stringByReplacingOccurrencesOfString:@"{COURSEID}" withString:[NSString stringWithFormat:@"%d",cObj.CourseID]];
    url = [url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url = [url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
    NSLog(@"CourseVideoListJsonHandler--url--%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            [self.delegate CourseVideoListJsonHandler:self withResult:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [operation start];
}
@end
