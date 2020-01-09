//
//  CoursePPTViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshFooterView.h"
#import "CoursePPTListJsonHandler.h"
#import "CoursePPTObject.h"
#import "CoursesObject.h"
#import "BaseViewController.h"
@protocol CoursePPTViewControllerDelegate;
@interface CoursePPTViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshFooterViewDelegate>
@property (nonatomic,strong) CoursesObject *coursesObj;
@property (nonatomic,weak) id<CoursePPTViewControllerDelegate> delegate;

- (void)reset;

@end

@protocol CoursePPTViewControllerDelegate <NSObject>

- (void)coursePPtGoBack;
- (void)coursePPtHome:(CoursePPTViewController *)courseHome selectedPPtObj:(CoursePPTObject *)coursePPtObj;

@end