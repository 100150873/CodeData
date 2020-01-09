//
//  CoursePPTObject.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursePPTObject : NSObject

//@property (nonatomic,assign) int PPTID;
@property (nonatomic,assign) int CourseID;
@property (nonatomic,strong) NSString *PPTName;
@property (nonatomic,strong) NSString *PPTPath;
@property (nonatomic,strong) NSString *PPTDes;
@property (nonatomic,strong) NSString *headerImageView;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *departmentName;
@property (nonatomic,strong) NSString *CourseName;
@property (nonatomic,assign) int Row_Number;

- (id)initWithJson:(NSDictionary *)json;
+ (NSArray *)initWithArray:(NSArray *)json;
@end
