//
//  SFIMBeginTestViewController.m
//  ProblemTest
//
//  Created by gzc on 2020/1/4.
//  Copyright © 2020 Hopex. All rights reserved.
//

#import "SFIMBeginTestViewController.h"
#import "SFIMTestScoresViewController.h"

@interface SFIMBeginTestViewController ()

@property (nonatomic, strong) UIButton *beginTestButton;
@property (nonatomic, strong) UILabel *testTimeLabel;
@property (nonatomic, strong) UILabel *eligibilityCriteriaLabel;
//@property (nonatomic, strong) UILabel *testTimeLabel;

@end

@implementation SFIMBeginTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI {
    self.title = @"测试";
    //开始测试
    [self.view addSubview:self.beginTestButton];
    [self.beginTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(200, 30)]);
    }];
    
    CGFloat topMargin = 200;
    CGFloat bottomMargin = self.view.bounds.size.height - topMargin - 90;
    
    //左侧标题
    UILabel *labelTime = [self createLabelWithText:@"测试时间" isTextBlackColor:NO];
    UILabel *labelStandard = [self createLabelWithText:@"合格标准" isTextBlackColor:NO];
    UILabel *labelRule = [self createLabelWithText:@"得分规则" isTextBlackColor:NO];
    NSArray *leftLabels = @[labelTime,labelStandard,labelRule];
    [leftLabels mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:20 leadSpacing:topMargin tailSpacing:bottomMargin];
    [leftLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.width.equalTo(@100);
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
}

- (UILabel *)createLabelWithText:(NSString *)text isTextBlackColor:(BOOL)isTextBlackColor {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = isTextBlackColor ? [UIColor blackColor] : [UIColor grayColor];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:label];
    return label;
}



#pragma mark - Action

- (void)clickedBeginTestButton:(UIButton *)button {
    [self.navigationController pushViewController:[SFIMTestScoresViewController new] animated:YES];
}


#pragma mark - Getter

- (UIButton *)beginTestButton {
    if (!_beginTestButton) {
        _beginTestButton = [[UIButton alloc] init];
        [_beginTestButton setTitle:@"开始测试" forState:0];
        _beginTestButton.backgroundColor = [UIColor blueColor];
        [_beginTestButton addTarget:self action:@selector(clickedBeginTestButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _beginTestButton;
}


@end
