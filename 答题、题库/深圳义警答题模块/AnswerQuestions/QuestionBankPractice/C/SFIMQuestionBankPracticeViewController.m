//
//  SFIMQuestionBankPracticeViewController.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/15.
//

#import "SFIMQuestionBankPracticeViewController.h"

#import "SFIMQuestionBankView.h"
#import "SFIMTestWrongModel.h"
#import "NSDate+HPExtension.h"
#import "LEEAlert.h"
#import "HPProgressHUD.h"
#import "SFIMTestScoresViewController.h"
#import "SFIMAnswerQuestionNavgationBar.h"

@interface SFIMQuestionBankPracticeViewController ()<SFIMNavigationControllerDelegate>

@property (nonatomic, strong) SFIMQuestionBankView *questionBankView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SFIMAnswerQuestionNavgationBar *navgationBar;

@end

@implementation SFIMQuestionBankPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSArray array];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor sfim_colorWithRed:64 green:90 blue:194 alpha:1.0];
    //透明导航栏
    self.navgationBar.titleLabel.text = @"题库练习";
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
    //questionBankView
    [self.view addSubview:self.questionBankView];
    HPWeakSelf(self)
    self.questionBankView.backHomeBlock = ^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)backItemAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SFIMNavigationControllerDelegate

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}


#pragma mark - 数据请求 / 数据处理
// 请求题目
- (void)fetchData {
    NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
    NSString *path = [bundle pathForResource:@"TestWrong" ofType:@"plist"];
    DEBUGLog(@"plist path -- %@",path);
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:path];
    DEBUGLog(@"data dic -- %@",dataDic);
    
    NSArray *temArr = [SFIMTestWrongModel arrayOfModelsFromDictionaries:dataDic[@"msg"][@"data"]];
    
    self.questionBankView.dataArray = temArr;
    if (temArr.count == 0) {
        [HPProgressHUD showMessage:@"您当前没有错题"];
    }
    
}


#pragma mark - 懒加载

- (SFIMQuestionBankView *)questionBankView {
    if (!_questionBankView) {
        CGFloat y = 94;
        if (SFIM_DEVICE_IPHONE_X_SERIES) {
            //iPhoneX系列
            y = 118;
        }
        CGFloat x = (SFIM_SCREEN_WIDTH - 327) / 2;
        _questionBankView = [[SFIMQuestionBankView alloc] initWithFrame:CGRectMake(x, y, 327, 544)];
        [_questionBankView setSfim_cornerRadius:8.0];
        SFIM_WEAK_SELF;
        _questionBankView.backHomeBlock = ^{
            [weakSelf backItemAction];
        };
    }
    return _questionBankView;
}

- (SFIMAnswerQuestionNavgationBar *)navgationBar {
    if (!_navgationBar) {
        NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMAnswerQuestionNavgationBar class]) owner:nil options:nil];
        _navgationBar = views.firstObject;
        [_navgationBar.backButton addTarget:self action:@selector(backItemAction) forControlEvents:UIControlEventTouchDown];
    }
    return _navgationBar;
}

@end
