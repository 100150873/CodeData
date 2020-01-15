//
//  CoursesObject.h
//  CourseList
//
//  Created by lmj on 15/11/1.
//  Copyright © 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursesObject : NSObject

@property (nonatomic,assign) int TeacherCourseClassID;
@property (nonatomic,strong) NSString *TeacherID;
@property (nonatomic,assign) int CourseID;
@property (nonatomic,assign) int ClassID;
@property (nonatomic,strong) NSString *TeacherName;
@property (nonatomic,strong) NSString *CourseName;
@property (nonatomic,strong) NSString *ClassName;
@property (nonatomic,strong) NSString *CourseDes;
@property (nonatomic,assign) int ChildCount;
@property (nonatomic,assign) int Row_number;
@property (nonatomic,strong) NSString *DepartmentName;
@property(nonatomic) BOOL isReaded;

-(id)initWithJson:(NSDictionary *)json;
+(NSArray *)initArrayWithJson:(NSArray *)json;
@end
