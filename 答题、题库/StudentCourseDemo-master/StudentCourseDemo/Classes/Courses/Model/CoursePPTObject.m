//
//  CoursePPTObject.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursePPTObject.h"

@implementation CoursePPTObject

-(id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.CourseID = [[json objectForKey:@"Courseid"] intValue];
//        self.CourseID = [[json objectForKey:@"CourseID"] intValue];
        self.PPTName = [json objectForKey:@"PptName"];
        self.PPTPath = [json objectForKey:@"PptPath"];
        self.PPTDes = [json objectForKey:@"PptDes"];
        self.CourseName = [json objectForKey:@"CourseName"];
        self.Row_Number = [[json objectForKey:@"Row_Number"] intValue];
    }
    return self;
}

+ (NSArray *)initWithArray:(NSArray *)json
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in json) {
        CoursePPTObject *coursePPT  = [[CoursePPTObject alloc] initWithJson:dic];
        [mutableArray addObject:coursePPT];
        coursePPT = nil;
    }
    NSArray *result = [NSArray arrayWithArray:mutableArray];
    return result;
}

@end
