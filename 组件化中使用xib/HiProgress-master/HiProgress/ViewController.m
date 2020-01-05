//
//  ViewController.m
//  HiProgress
//
//  Created by WangZeKeJi on 14-8-5.
//  Copyright (c) 2014年 ___ChengPeng___. All rights reserved.
//

#import "ViewController.h"
#import "HiProgressView.h"
#import "ZCJoinMaterialView.h"
#import "GDFadeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    HiProgressView *progressView = [[HiProgressView alloc]initWithFrame:CGRectMake((320-263)/2, 100, 263, 12) withProgress:0.7];//传入参数范围0~1
    [self.view addSubview:progressView];

    ZCJoinMaterialView *subView = [[ZCJoinMaterialView alloc] init];
       subView.backgroundColor = [UIColor redColor];
           [self.view addSubview:subView];
           subView.frame = CGRectMake(0, 100, 200, 200);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
