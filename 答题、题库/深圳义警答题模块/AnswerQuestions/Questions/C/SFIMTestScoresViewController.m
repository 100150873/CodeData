//
//  TOneViewController.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "SFIMTestScoresViewController.h"

#import "SFIMAnswerQuestionsViewController.h"
#import "SFIMCollaborationModuleDefine.h"
#import "SFIMTestResultView.h"
#import "SFIMAnswerQuestionNavgationBar.h"
#import "SFIMCheckWrongViewController.h"

@interface SFIMTestScoresViewController ()<SFIMNavigationControllerDelegate>

@property (nonatomic, strong) SFIMTestResultView *testResultView;
@property (nonatomic, strong) SFIMAnswerQuestionNavgationBar *navgationBar;

@end

@implementation SFIMTestScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor sfim_colorWithRed:64 green:90 blue:194 alpha:1.0];
    //透明导航栏
    self.navgationBar.titleLabel.text = @"测试成绩";
    [self.view addSubview:self.navgationBar];
    [self.navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (SFIM_DEVICE_IPHONE_X_SERIES) {
            make.top.equalTo(self.view).offset(44);
        } else {
            make.top.equalTo(self.view).offset(20);
        }
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.testResultView];
    [self.testResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navgationBar.mas_bottom).offset(30);
        make.center.equalTo(self.view);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(327, 544)]);
    }];
    [self.testResultView setSfim_cornerRadius:8.0];
    
    // 配置左上角返回按钮
    if (self.navigationController.viewControllers.count == 1) {
        // 说明不是push进来
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"collaboration_back_nav_image") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
        cancelItem.tintColor = [UIColor sfim_colorWithHexString:@"020F22"];
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
}

#pragma mark - SFIMNavigationControllerDelegate

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}


#pragma mark - Actions

/// 点击返回事件
- (void)backButtonClick {
//    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickedCheckWrongTopicButton:(UIButton *)button {
    SFIMCheckWrongViewController *vc = [[SFIMCheckWrongViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickedTestButton:(UIButton *)button {
    SFIMAnswerQuestionsViewController *vc = [[SFIMAnswerQuestionsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Getter

- (SFIMTestResultView *)testResultView {
    if (!_testResultView) {
      NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMTestResultView class]) owner:nil options:nil];
        _testResultView = views.firstObject;
        [_testResultView.checkWrongButton addTarget:self action:@selector(clickedCheckWrongTopicButton:) forControlEvents:UIControlEventTouchUpInside];
        [_testResultView.retestButton addTarget:self action:@selector(clickedTestButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testResultView;
}

- (SFIMAnswerQuestionNavgationBar *)navgationBar {
    if (!_navgationBar) {
      NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMAnswerQuestionNavgationBar class]) owner:nil options:nil];
        _navgationBar = views.firstObject;
        [_navgationBar.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchDown];
    }
    return _navgationBar;
}

@end
