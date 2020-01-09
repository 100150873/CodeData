//
//  CoursesObject.m
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import "CoursesObject.h"

@implementation CoursesObject

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        if (json != nil) {
            self.TeacherCourseClassID = [[json objectForKey:@"TeacherCourseClassID"] intValue];
            self.TeacherID = [json objectForKey:@"TeacherID"];
            self.CourseID = [[json objectForKey:@"CourseID"] intValue];
            self.ClassID = [[json objectForKey:@"ClassID"] intValue];
            self.TeacherName = [json objectForKey:@"TeacherName"];
            self.CourseName = [json objectForKey:@"CourseName"];
            self.ClassName = [json objectForKey:@"ClassName"];
            self.CourseDes = [json objectForKey:@"CourseDes"];
            self.ChildCount = [[json objectForKey:@"ChildCount"] intValue];
            self.Row_number = [[json objectForKey:@"Row_number"] intValue];
            self.DepartmentName = [json objectForKey:@"DepartmentName"];
        }
    }
    return self;
}

+ (NSArray *)initArrayWithJson:(NSArray *)json
{
    // cell数据
    NSMutableArray *objArr =[[NSMutableArray alloc] init];
    for (NSDictionary *dic in json) {
        CoursesObject *courseObj = [[CoursesObject alloc] initWithJson:dic];
        [objArr addObject:courseObj];
        courseObj = nil;
    }
    NSArray *result = [NSArray arrayWithArray:objArr];
    
    return result;
}

@end
