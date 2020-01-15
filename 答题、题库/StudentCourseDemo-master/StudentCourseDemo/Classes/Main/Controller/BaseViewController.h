//
//  BaseViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define k_NavigationBarHeigh 44.0f

@class SlideFrameViewController;
@interface BaseViewController : UIViewController
@property (nonatomic) CGRect viewBounds;
@property (nonatomic,strong) UIViewController *leftVC;
@property (nonatomic,strong) UIViewController *rightVC;
@property (nonatomic,strong) SlideFrameViewController *slideFrameVC;

- (void)changeNavBarTitleColor;

@end
