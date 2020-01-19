//
//  SFIMCheckWrongViewController.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import "SFIMCheckWrongViewController.h"
#import "SFIMWrongsView.h"
#import "SFIMTestWrongModel.h"
#import "NSDate+HPExtension.h"
#import "LEEAlert.h"
#import "HPProgressHUD.h"
#import "SFIMTestScoresViewController.h"
#import "SFIMAnswerQuestionNavgationBar.h"

@interface SFIMCheckWrongViewController ()<SFIMNavigationControllerDelegate>

@property (nonatomic, strong) SFIMWrongsView *wrongView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SFIMAnswerQuestionNavgationBar *navgationBar;

@end

@implementation SFIMCheckWrongViewController

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
    self.navgationBar.titleLabel.text = @"查看错题";
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
    //wrongView
    [self.view addSubview:self.wrongView];
    HPWeakSelf(self)
    self.wrongView.backHomeBlock = ^{
        [weakself.navigationController dismissViewControllerAnimated:YES completion:^{
            [[[UIViewController sfim_topViewController] navigationController] popViewControllerAnimated:YES];
        }];
    };
}

- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - SFIMNavigationControllerDelegate

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}


#pragma mark - 内部逻辑实现

- (void)pushTestResultViewController  {
    [self.navigationController pushViewController:[SFIMTestScoresViewController new] animated:YES];
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
    
    self.wrongView.dataArray = temArr;
    if (temArr.count == 0) {
        [HPProgressHUD showMessage:@"您当前没有错题"];
    }
    
}


#pragma mark - 懒加载

- (SFIMWrongsView *)wrongView {
    if (!_wrongView) {
        CGFloat y = 94;
        if (SFIM_DEVICE_IPHONE_X_SERIES) {
            //iPhoneX系列
            y = 118;
        }
        CGFloat x = (SFIM_SCREEN_WIDTH - 327) / 2;
        _wrongView = [[SFIMWrongsView alloc] initWithFrame:CGRectMake(x, y, 327, 544)];
        [_wrongView setSfim_cornerRadius:8.0];
    }
    return _wrongView;
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
