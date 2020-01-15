//
//  CourseVideoObject.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoObject.h"

@implementation CourseVideoObject

- (id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.VideoID = [[json objectForKey:@"VideoID"] intValue];
        self.CourseID = [[json objectForKey:@"CourseID"] intValue];
        self.VideoName = [json objectForKey:@"VideoName"];
        self.VideoPath = [json objectForKey:@"VideoPath"];
        self.VideoImage = [json objectForKey:@"VideoImage"];
        self.VideoLength = [json objectForKey:@"VideoLength"];
        self.CourseName = [json objectForKey:@"CourseName"];
        self.VideoDes = [json objectForKey:@"VideoDes"];
        self.Row_Number = [[json objectForKey:@"Row_Number"] intValue];
    }
    return self;
}

+ (NSArray *)initWithArray:(NSArray *)json
{
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in json) {
        CourseVideoObject *courseVideo = [[CourseVideoObject alloc] initWithJson:dic];
        [mutableArr addObject:courseVideo];
        courseVideo = nil;
    }
    NSArray *result = [NSArray arrayWithArray:mutableArr];
    return result;
}

@end
