//
//  LeftMenuViewController.h
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewControllerDelegate;
@interface LeftMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) id<LeftMenuViewControllerDelegate> delegate;
@end

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional
- (void)leftMenuChangeSelected:(int)index;

@end
