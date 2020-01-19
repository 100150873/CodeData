//
//  SFIMBeginTestViewController.m
//  ProblemTest
//
//  Created by gzc on 2020/1/4.
//  Copyright © 2020 Hopex. All rights reserved.
//

#import "SFIMBeginTestViewController.h"
#import "SFIMAnswerQuestionsViewController.h"
#import "SFIMCollaborationModuleDefine.h"
#import "SFIMAnswerQuestionNavgationBar.h"

@interface SFIMBeginTestViewController ()<SFIMNavigationControllerDelegate>

@property (nonatomic, strong) UIButton *beginTestButton;
@property (nonatomic, strong) UILabel *testTimeLabel;
@property (nonatomic, strong) UILabel *eligibilityCriteriaLabel;
/** 左上角返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SFIMAnswerQuestionNavgationBar *navgationBar;

@end

@implementation SFIMBeginTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor sfim_colorWithHexString:@"#5878B6"];
    //透明导航栏
    self.navgationBar.titleLabel.text = @"测试";
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
    //容器view
    CGFloat containerViewHeight = 500;
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(327, containerViewHeight)]);
    }];
    [self.containerView setSfim_cornerRadius:8.0];
    
   //图标
    UIImageView *iconImgeView = [[UIImageView alloc] initWithImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"answer_test_image")];
    [self.containerView addSubview:iconImgeView];
    [iconImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(40);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(109, 99)]);
    }];
    
    CGFloat topMargin = 178;
    CGFloat bottomMargin = containerViewHeight - topMargin - 84;
    
    //左侧标题
    UILabel *labelTime = [self createLabelWithText:@"测试时间" isTextBlackColor:NO];
    UILabel *labelStandard = [self createLabelWithText:@"合格标准" isTextBlackColor:NO];
    UILabel *labelRule = [self createLabelWithText:@"得分规则" isTextBlackColor:NO];
    NSArray *leftLabels = @[labelTime,labelStandard,labelRule];
    [leftLabels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:20 leadSpacing:topMargin tailSpacing:bottomMargin];
    [leftLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(44);
        make.width.equalTo(@70);
    }];
    //右侧内容
    UILabel *timeLabel = [self createLabelWithText:@"60分钟" isTextBlackColor:YES];
    UILabel *standardLabel = [self createLabelWithText:@"80分" isTextBlackColor:YES];
    NSString *ruleString = @"单选题50分\n多选题20分\n判断题20分";
    UILabel *ruleLabel = [self createLabelWithText:ruleString isTextBlackColor:YES];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelTime);
        make.left.equalTo(labelTime.mas_right).offset(17);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [standardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelStandard);
        make.left.equalTo(labelStandard.mas_right).offset(17);
        make.right.equalTo(timeLabel);
    }];
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelRule);
        make.left.equalTo(labelTime.mas_right).offset(17);
        make.right.equalTo(standardLabel);
    }];
    
    //开始测试
    [self.containerView addSubview:self.beginTestButton];
    [self.beginTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ruleLabel.mas_bottom).offset(70);
        make.centerX.equalTo(self.containerView);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(240, 48)]);
    }];
    [self.beginTestButton setSfim_cornerRadius:24];
    
//    // 配置左上角返回按钮
//    if (self.navigationController.viewControllers.count == 1) {
//        // 说明不是push进来
//        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"collaboration_back_nav_image") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
////        cancelItem.tintColor = [UIColor sfim_colorWithHexString:@"020F22"];
//        self.navigationItem.leftBarButtonItem = cancelItem;
//    }
}

- (UILabel *)createLabelWithText:(NSString *)text isTextBlackColor:(BOOL)isTextBlackColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = isTextBlackColor ? [UIColor blackColor] : [UIColor grayColor];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18.0];
    [self.containerView addSubview:label];
    return label;
}


#pragma mark - SFIMNavigationControllerDelegate

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

#pragma mark - Action

- (void)clickedBeginTestButton:(UIButton *)button {
    [self.navigationController pushViewController:[SFIMAnswerQuestionsViewController new] animated:YES];
}

/// 点击返回事件
- (void)backButtonClick {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *button = [[UIButton alloc] init];
        UIImage *backImage = SFIM_COLLABORATION_RESOURCES_IMAGE(@"collaboration_back_nav_image");
        [button setImage:backImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _backButton = button;
    }
    return _backButton;
}

- (UIButton *)beginTestButton {
    if (!_beginTestButton) {
        _beginTestButton = [[UIButton alloc] init];
        [_beginTestButton setTitle:@"开始测试" forState:0];
        [_beginTestButton setTitleColor:[UIColor whiteColor] forState:0];
        _beginTestButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _beginTestButton.backgroundColor = [UIColor sfim_colorWithHexString:@"#5878B6"];
        [_beginTestButton addTarget:self action:@selector(clickedBeginTestButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _beginTestButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
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
