//
//  SFMSMCodeVerifyController.m
//  NIM
//
//  Created by gzc on 2019/12/19.
//  Copyright © 2019 YzChina. All rights reserved.
//

#import "SFMSMCodeVerifyController.h"

#import "SFIMCodeInputView.h"
#import "CustomLeftBarView.h"
#import "UIAlertController+MessageLabel.h"
#define SEND_SPACE 60 //发送间隔60秒

@interface SFMSMCodeVerifyController ()<CustomLeftBarItemItemProtocol>

@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) SFIMGCDTimer *timer;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *topNoticeLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UIButton *noCodeButton;
@property (nonatomic, strong) UIButton *resendCodeButton;
@property (nonatomic, strong) SFIMCodeInputView *inputView;


@end

@implementation SFMSMCodeVerifyController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setUpLeftBar];
    [self configTouchViewCanResignFirstResponder];
    //开始定时器
    [self startTimer];
    [self.inputView textFieldBecomeFirstResponder];
}


#pragma mark - Initialization

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber
                        countryCode:(NSString *)countryCode {
    self = [super self];
    if (self) {
        _phoneNumber = phoneNumber;
        _countryCode = countryCode;
    }
    return  self;
}


#pragma mark - Action

- (void)touchResendCodeButton {
    //重发
    [self sendPhoneCode];
}

- (void)touchNotReceiveButton {
    //收不到验证码
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收不到验证码" message:@"1. 请确认手机号是否为当前使用的手机号;\n2. 请检查短信是否被安全软件拦截; \n3. 由于运营商关系，短信可能会延迟到达. " preferredStyle:UIAlertControllerStyleAlert];
    [[alert sfim_messageLabel] setTextAlignment:NSTextAlignmentLeft];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 发送验证码
 */
- (void)sendPhoneCode {
    
    SFIM_WEAK_SELF
    [PSProgressHUD showLoadingHUD:^(PSProgressHUD *make) {
        make.inView(self.view);
    }];
//    [[SFIMUserCenter defaultCenter].serviceManager sendSMSCodeWithPhoneNubmer:self.phoneNumber countryCode:self.countryCode codeType:self.inputType completion:^(NSString *errorMsg, BOOL success) {
    [PSProgressHUD hideHUD:^(PSProgressHUD *make) {
         make.inView(self.view);
    }];
//        if (errorMsg) {
//            [SFIMHUD showError:errorMsg];
//        } else {
//            NSString *message = success ? SFIM_LOGIN_RESOURCES_LOCAL(@"sfim.auth.codeInput.send_ok") : SFIM_LOGIN_RESOURCES_LOCAL(@"sfim.auth.codeInput.send_fail");
//            [SFIMHUD showSuccess:message];
//            //开始定时器
            [weakSelf startTimer];
//        }
//    }];
}

- (void)startTimer {
    SFIM_WEAK_SELF
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [SFIMGCDTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^{
        [weakSelf timeIsCome];
    }];
}

- (void)configTouchViewCanResignFirstResponder {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelfView)];
    [self.containerView addGestureRecognizer:tapGR];
}

- (void)touchSelfView {
    [self.inputView textFieldResignFirstResponder];
}

- (void)inputOKWithInputText:(NSString *)inputText {
    [self.inputView textFieldResignFirstResponder];
    [self loginWithSMSCode:inputText];
}

/**
 验证码登录
 
 @param smsCode 验证码
 */
- (void)loginWithSMSCode:(NSString *)smsCode {
    [SFIMHUD showLoading];
//    SFIM_WEAK_SELF
//    [[SFIMUserCenter defaultCenter].loginManager
//     phoneCodeLoginWithPhoneNumber:self.phoneNumber
//     countryCode:self.countryCode
//     smsCode:smsCode
//     completion:^(NSError *error, NSArray <SFIMCompany *>*joinComponyArray) {
//         [SFIMHUD hideHUD];
//         if (error) {
//             [weakSelf handleLoginError:error];
//         } else {
//             // 登录成功
//             SFIMLoginCompanyManager *manager = [SFIMLoginCompanyManager manager];
//             [manager doActionsWithCompanies:joinComponyArray viewController:weakSelf];
//         }
//     }];
}

- (void)timeIsCome {
    self.lastTime = self.lastTime + 1;
    if (self.lastTime >= SEND_SPACE) {
        self.lastTime  = 0;
        self.resendCodeButton.enabled = YES;
        [self.resendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.timer invalidate];
        return;
    } else {
        self.resendCodeButton.enabled = NO;
        NSString *buttonTitle = [NSString stringWithFormat:@"%.0f秒后重新发送",  SEND_SPACE - self.lastTime];
        [self.resendCodeButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}


#pragma mark  CustomLeftBarItemItemProtocol

- (void)onLeftButtonPressed {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UI

- (void)setupUI {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.topNoticeLabel];
    [self.containerView addSubview:self.phoneNumLabel];
    [self.containerView addSubview:self.noCodeButton];
    [self.containerView addSubview:self.inputView];
    [self.containerView addSubview:self.resendCodeButton];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self.view);
    }];
    [self.topNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(44);
        make.left.equalTo(self.containerView).offset(40);
        make.height.mas_equalTo(50);
    }];
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topNoticeLabel.mas_bottom).offset(16);
        make.left.equalTo(self.topNoticeLabel);
        make.right.equalTo(self.containerView).offset(- 10);
        make.height.mas_equalTo(18);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumLabel.mas_bottom).offset(48);
        make.leading.trailing.mas_equalTo(self.phoneNumLabel);
        make.height.mas_equalTo(56);
    }];
    [self.noCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).offset(20);
        make.left.equalTo(self.topNoticeLabel);
        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(200);
    }];
    [self.resendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(92);
        make.leading.mas_equalTo(self.view).offset(24);
        make.trailing.mas_equalTo(self.view).offset(-24);
        make.height.mas_equalTo(48);
    }];
}

- (void)setUpLeftBar {
    CustomLeftBarView *ccview = [CustomLeftBarView new];
    ccview.delegate = self;
    UIBarButtonItem *leftItem =
    [[UIBarButtonItem alloc] initWithCustomView:ccview];
    self.navigationItem.leftBarButtonItems =
    @[ [UIBarButtonItem sfim_getNilBarItemWithWidth:-10], leftItem ];
}

#pragma mark - Getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)topNoticeLabel {
    if (!_topNoticeLabel) {
        _topNoticeLabel = [[UILabel alloc] init];
        _topNoticeLabel.font = [UIFont systemFontOfSize:24];
        _topNoticeLabel.text = @"验证码已发送至手机";
        _topNoticeLabel.textColor = [UIColor sfim_colorWithHexString:@"#0B2031"];
    }
    return _topNoticeLabel;
}

- (UILabel *)phoneNumLabel {
    if (!_phoneNumLabel) {
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.font = [UIFont systemFontOfSize:16];
        _phoneNumLabel.text = [NSString stringWithFormat:@"+%@ %@",self.countryCode,self.phoneNumber];
    }
    return _phoneNumLabel;
}

- (SFIMCodeInputView *)inputView {
    if (!_inputView) {
        SFIM_WEAK_SELF
        SFIMCodeInputView *view = [[SFIMCodeInputView alloc] initWithCompletion:^(NSString *inputText) {
            [weakSelf inputOKWithInputText:inputText];
        }];
        _inputView = view;
    }
    return _inputView;
}

- (UIButton *)noCodeButton {
    if (!_noCodeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"收不到验证码?" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor sfim_colorWithHexString:@"#7E8388"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(touchNotReceiveButton) forControlEvents:UIControlEventTouchUpInside];
        _noCodeButton = button;
    }
    return _noCodeButton;
}

- (UIButton *)resendCodeButton {
    if (!_resendCodeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"60秒后重新发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor sfim_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setBackgroundImage:[UIImage sfim_imageWithColor:[UIColor sfim_colorWithHexString:@"#BBCCE3"]] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage sfim_imageWithColor:[UIColor sfim_colorWithHexString:@"#344F9C"]] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor sfim_colorWithHexString:@"#B4C5DE"].CGColor;
        button.layer.cornerRadius = 24;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button addTarget:self action:@selector(touchResendCodeButton) forControlEvents:UIControlEventTouchUpInside];
        _resendCodeButton = button;
    }
    return _resendCodeButton;
}

@end
