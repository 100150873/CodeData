//
//  CourseListJsonHandler.m
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import "CourseListJsonHandler.h"
#import "AFNetworking.h"
#import "CoursesObject.h"
#import "SVProgressHUD.h"
#import "JSON.h"
@implementation CourseListJsonHandler
- (void)handlerCourseObject:(CoursesObject *)cOjb currentPageIndex:(int)currentPageIndex pageSize:(int)pageSize
{
//    NSLog(@"handlerCourseObject--");
//    NSLog(@"handlerCourseObjectcurrentPageIndex--%d",currentPageIndex);
//    NSLog(@"cOjb---%d",cOjb.ClassID);
    NSString *url=@"http://www.dota2ms.com/Service.asmx/TeacherCourseClassSelect?TeacherID=&ClassID={CLASSID}&CurrentPageIndex={PAGEINDEX}&PageSize={PAGESIZE}";
    url=[url stringByReplacingOccurrencesOfString:@"{CLASSID}" withString:[NSString stringWithFormat:@"%d",cOjb.ClassID]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",pageSize]];
//    NSLog(@"url---%@",url);

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responseObject---%@",[responseObject JSONValue]);
//        NSLog(@"bb");
        if (self.delegate) {
            [self.delegate CourseListJsonHandler:self  withResult:responseObject];
//
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
    [operation start];
}



@end
