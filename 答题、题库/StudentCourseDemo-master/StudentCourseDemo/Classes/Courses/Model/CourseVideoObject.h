//
//  CourseVideoObject.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseVideoObject : NSObject

@property (nonatomic,assign) int VideoID;
@property (nonatomic,assign) int CourseID;
@property (nonatomic,strong) NSString *VideoName;
@property (nonatomic,strong) NSString *VideoPath;
@property (nonatomic,strong) NSString *VideoImage;
@property (nonatomic,strong) NSString *VideoLength;
@property (nonatomic,strong) NSString *CourseName;
@property (nonatomic,strong) NSString *VideoDes;
@property (nonatomic,assign) int Row_Number;

- (id)initWithJson:(NSDictionary *)json;
+ (NSArray *)initWithArray:(NSArray *)json;

@end
