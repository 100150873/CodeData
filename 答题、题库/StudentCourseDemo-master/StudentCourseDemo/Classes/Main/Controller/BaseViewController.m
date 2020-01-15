//
//  BaseViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideFrameViewController.h"
#import "Common.h"
@interface BaseViewController ()
{
    
}
@end

@implementation BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        self.viewBounds = [Common resizeViewBounds:self.view.bounds withNavBarHeight:k_NavigationBarHeigh];
    }
}

- (void)changeNavBarTitleColor
{
    UIColor *cc = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}







@end
