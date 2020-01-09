//
//  TOneViewController.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "SFIMTestScoresViewController.h"
#import "PTQuestionViewController.h"
#import "PTWrongViewController.h"

@interface SFIMTestScoresViewController ()

@end

@implementation SFIMTestScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"测试成绩";
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"60分";
    scoreLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(30);
    }];
    UIImageView *imageResult = [[UIImageView alloc] init];
    imageResult.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageResult];
    [imageResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(scoreLabel.mas_bottom).offset(10);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(80, 80)]);
    }];
    //查看错题
    UIButton *checkWrongTopicButton = [UIButton initButtonTitleFont:18 titleColor:[UIColor whiteColor] titleName:@"查看错题" backgroundColor:[UIColor darkGrayColor] radius:3.0];
    [checkWrongTopicButton addTarget:self action:@selector(clickedCheckWrongTopicButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkWrongTopicButton];
    //重新测试
    UIButton *testButton = [UIButton initButtonTitleFont:18 titleColor:[UIColor whiteColor] titleName:@"重新测试" backgroundColor:[UIColor darkGrayColor] radius:3.0];
    [testButton addTarget:self action:@selector(clickedTestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    NSArray *buttons = @[checkWrongTopicButton,testButton];
    CGFloat buttonWidth = 150;
    CGFloat margin = 20;
    CGFloat space = (self.view.bounds.size.width - buttonWidth * 2 - margin) / 2;
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:buttonWidth leadSpacing:space tailSpacing:space];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageResult.mas_bottom).offset(100);
        make.height.mas_equalTo(40);
    }];
}


#pragma mark - Actions

- (void)clickedCheckWrongTopicButton:(UIButton *)button {
    PTWrongViewController *vc = [[PTWrongViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedTestButton:(UIButton *)button {
    PTQuestionViewController *vc = [[PTQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
