//
//  SFIMAnswerQuestionsViewController.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "SFIMAnswerQuestionsViewController.h"
#import "PTQuestionView.h"
#import "SFIMTestTopicModel.h"
#import "PTTestResultModel.h"
#import "NSDate+HPExtension.h"
#import "LEEAlert.h"
#import "HPProgressHUD.h"
#import "SFIMTestScoresViewController.h"
#import "SFIMAnswerQuestionNavgationBar.h"


@interface SFIMAnswerQuestionsViewController ()<SFIMNavigationControllerDelegate>

@property (nonatomic, strong) PTQuestionView *testView;
@property (nonatomic, strong) NSTimer *countDownTimer;      // 计时器
@property (nonatomic, assign) NSInteger totalSeconds;       // 总时间
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SFIMAnswerQuestionNavgationBar *navgationBar;
@end

@implementation SFIMAnswerQuestionsViewController{
    NSInteger startTime;    // 做题开始时间戳
    NSInteger endTime;      // 做题结束时间戳
    NSInteger useTimes;     // 做题用时
    NSInteger doNumber;     // 做题数量
    NSInteger rightNumber;  // 正确的数量
    NSInteger getScore;     // 得分
    NSString *addUpAnswer;  // 统计答案 目前用字符串和“,”拼接，只适合单选题
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSArray array];
    _length_time = @"5";
    _total_topic = @"5";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)dealloc {
    
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor sfim_colorWithRed:64 green:90 blue:194 alpha:1.0];
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
    //testView
    [self.view addSubview:self.testView];
    HPWeakSelf(self)
    self.testView.SubmitAnswerBlock = ^{
        
        if (weakself.testView.recordAnswer.count == weakself.dataArray.count) {
            // 做完交卷
            [LEEAlert alert].config.LeeCornerRadius(5.0).LeeShadowOpacity(0.4).LeeTitle(@"确认交卷吗？").LeeAddAction(^(LEEAction *action) {
                action.title = @"再检查一下";
                action.titleColor = [UIColor hex:@"#020F22"];
                action.font = [UIFont systemFontOfSize:21];
            }).LeeAddAction(^(LEEAction *action) {
                action.title = @"确认交卷";
                action.titleColor = [UIColor hex:@"#007AFF"];
                action.font = [UIFont systemFontOfSize:21];
                action.clickBlock = ^{
                    
                    [weakself carryOutAction];
                };
            }).LeeShow();
        }else {
            // 中途交卷
            NSInteger surplus = self.dataArray.count - self.testView.recordAnswer.count;
            NSString *tipTitle = [NSString stringWithFormat:@"您还有%ld题目未作答，确认交卷吗？",surplus];
            [LEEAlert alert].config.LeeCornerRadius(5.0).LeeShadowOpacity(0.4).LeeTitle(tipTitle).LeeAddAction(^(LEEAction *action) {
                action.title = @"确认交卷";
                action.titleColor = [UIColor hex:@"#020F22"];
                action.font = [UIFont systemFontOfSize:16];
                action.clickBlock = ^{
                    
                    [weakself carryOutAction];
                };
            }).LeeAddAction(^(LEEAction *action) {
                action.title = @"继续作答";
                action.titleColor = [UIColor hex:@"#007AFF"];
                action.font = [UIFont systemFontOfSize:16];
            }).LeeShow();
        }
    };
}


#pragma mark - SFIMNavigationControllerDelegate

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

#pragma mark - 内部逻辑实现
- (void)countDownAction {
    
    self.totalSeconds--;
    self.testView.timeCounting = [self secondsToHourMinuteSeconds:self.totalSeconds];
    
    // 倒计时到0时
    if (self.totalSeconds == 0) {
        [self.countDownTimer invalidate];
        
        HPWeakSelf(self)
        [LEEAlert alert].config.LeeCornerRadius(5.0).LeeShadowOpacity(0.4).LeeTitle(@"做题时间到，请您选择放弃本次做题还是交卷").LeeAddAction(^(LEEAction *action) {
            action.title = @"交卷";
            action.titleColor = [UIColor hex:@"e34a50"];
            action.font = [UIFont systemFontOfSize:21];
            action.clickBlock = ^{
                
                [weakself carryOutAction];
            };
        }).LeeAddAction(^(LEEAction *action) {
            action.title = @"放弃";
            action.titleColor = [UIColor hex:@"e34a50"];
            action.font = [UIFont systemFontOfSize:21];
            action.clickBlock = ^{
                
                [weakself.navigationController popViewControllerAnimated:YES];
            };
        }).LeeShow();
    }
}

// 交卷执行
- (void)carryOutAction {
    DEBUGLog(@"交卷啦~~~");
    
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];   // 暂停时间
    }
    
    [self calculateTheResults];     //计算结果
}

// 返回上一页面执行
- (void)backItemAction:(UIButton *)btn {
    
    HPWeakSelf(self)
    btn.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        // 做了题，但是没有交卷
        if (weakself.testView.recordAnswer.count) {
            [LEEAlert alert].config.LeeCornerRadius(5.0).LeeShadowOpacity(0.4).LeeTitle(@"您还没交卷，确认退出吗？").LeeAddAction(^(LEEAction *action) {
                action.title = @"确认";
                action.titleColor = [UIColor hex:@"e34a50"];
                action.font = [UIFont systemFontOfSize:21];
                action.clickBlock = ^{
                    
                    if (weakself.navigationController.viewControllers.count > 1) {
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        [weakself dismissViewControllerAnimated:YES completion:nil];
                    }
                };
            }).LeeAddAction(^(LEEAction *action) {
                action.title = @"取消";
                action.titleColor = [UIColor hex:@"e34a50"];
                action.font = [UIFont systemFontOfSize:21];
            }).LeeShow();
        }else {
            [weakself pushTestResultViewController];
        }
    }];
}

- (void)pushTestResultViewController  {
    [self.navigationController pushViewController:[SFIMTestScoresViewController new] animated:YES];
}

- (NSString *)secondsToHourMinuteSeconds:(NSInteger)seconds {
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];// 时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds - 3600*[str_hour integerValue])/60];// 分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];// 秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}


#pragma mark - 计算做题结果
- (void)calculateTheResults {
    addUpAnswer = @"";
    useTimes = [self.length_time integerValue]*60 - self.totalSeconds;
    endTime = startTime+useTimes;
    doNumber = self.testView.recordAnswer.count;
    rightNumber = 0;
    getScore = 0;
    NSArray *youAnswer = self.testView.recordAnswer.copy;
    
    DEBUGLog(@"you answer%@", youAnswer);
    DEBUGLog(@"model array %@", self.dataArray);
    
    // 开始比对答案
    for (int i = 0; i < youAnswer.count; i++) {
        NSArray *tempArr = youAnswer[i];
        if (tempArr.count) {
            addUpAnswer = [[addUpAnswer stringByAppendingString:[tempArr firstObject]] stringByAppendingString:@","];
            
            SFIMTestTopicModel *model = self.dataArray[i];
            
            if ([model.answer isEqualToString:[tempArr firstObject]]) {
                // 做对了
                rightNumber++;
                getScore+= [model.score integerValue];
            } else {
            }
        } else {
            doNumber-=1;
            addUpAnswer = [[addUpAnswer stringByAppendingString:@""] stringByAppendingString:@","];
        }
        
    }
    
    // 向后台提交答案
    NSInteger stringLength = addUpAnswer.length;
    
    if (youAnswer.count == [self.total_topic integerValue]) {
        addUpAnswer = [addUpAnswer substringToIndex:stringLength - 1];
    }else {
        
        NSInteger addDou = [self.total_topic integerValue] - youAnswer.count - 1;
        if (addDou > 0) {
            for (int i = 0; i < addDou; i++) {
                addUpAnswer = [addUpAnswer stringByAppendingString:@","];
            }
        }
    }
    
    DEBUGLog(@"your answer string: %@",addUpAnswer);
    
    [HPProgressHUD showMessage:[NSString stringWithFormat:@"做题数量%ld, 正确数%ld, 得分%ld", doNumber,rightNumber,getScore]];
    
    // 创建一个ResultModel  可用这个model传递结果数据
    PTTestResultModel *resultM = [[PTTestResultModel alloc] init];
    resultM.use_time = StringValueFromInt(useTimes);
    resultM.questionNum = self.total_topic;
    resultM.answerNum = StringValueFromInt(doNumber);
    resultM.rightNum = StringValueFromInt(rightNumber);
    resultM.score = StringValueFromInt(getScore);
    resultM.totalScore = @"";
    
    DEBUGLog(@"测试结果：%@",resultM);
    [self pushTestResultViewController];
}


#pragma mark - 数据请求 / 数据处理
// 请求题目
- (void)fetchData {
    NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
    NSString *path = [bundle pathForResource:@"Question" ofType:@"plist"];
    DEBUGLog(@"plist path -- %@",path);
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:path];
    DEBUGLog(@"data dic -- %@",dataDic);
    
    NSArray *temArr = [SFIMTestTopicModel arrayOfModelsFromDictionaries:dataDic[@"msg"][@"data"]];
    
    [self handleTopicData:temArr];
    
}

- (void)handleTopicData:(NSArray *)array {
    
    if (array.count) {
        self.dataArray = array.copy;
        self.testView.dataArray = self.dataArray;
        
        // 题目数据获取成功后，开始计时
        self.totalSeconds = [self.length_time integerValue] * 60; // 转换为秒
        self.testView.timeCounting = [self secondsToHourMinuteSeconds:self.totalSeconds];
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        startTime = [[NSDate getCurrentTimeStamp] integerValue];
    }
}


#pragma mark - 懒加载

- (PTQuestionView *)testView {
    if (!_testView) {
        CGFloat y = 94;
        if (SFIM_DEVICE_IPHONE_X_SERIES) {
            //iPhoneX系列
            y = 118;
        }
        CGFloat x = (SFIM_SCREEN_WIDTH - 327) / 2;
        _testView = [[PTQuestionView alloc] initWithFrame:CGRectMake(x, y, 327, 544)];
        [_testView setSfim_cornerRadius:8.0];
    }
    return _testView;
}

- (SFIMAnswerQuestionNavgationBar *)navgationBar {
    if (!_navgationBar) {
        NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMAnswerQuestionNavgationBar class]) owner:nil options:nil];
        _navgationBar = views.firstObject;
        [_navgationBar.backButton addTarget:self action:@selector(backItemAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _navgationBar;
}

@end
