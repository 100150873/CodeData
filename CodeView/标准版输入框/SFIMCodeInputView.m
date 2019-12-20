//
//  SFIMCodeInputView.m
//  SFIMUserCenter
//
//  Created by 汤世豪(80002131) on 2019/4/15.
//

#import "SFIMCodeInputView.h"
//#import "SFIMLoginModuleDefine.h"
#import <SFIMUIKit/SFIMUIKit.h>

#define CODE_COUNT 6

@interface SFIMCodeInputView ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *inputLabelArray;
@property (nonatomic, strong) NSMutableArray *lineViewArray;
@property (nonatomic, copy) SFIMCodeInputCompletion completion;
@end

@implementation SFIMCodeInputView

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCompletion:(void (^)(NSString * _Nonnull))completion {
    self = [super init];
    if (self) {
        _completion = completion;
        [self configSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - life cycle


#pragma mark - Actions
- (void)textFieldDidChange {
    if(!self.textField.isFirstResponder) {
        return;
    }
    NSString *inputText = self.textField.text;
    for (NSInteger index = 0; index < CODE_COUNT; index ++) {
         UILabel *label = self.inputLabelArray[index];
        UIView *lineView = self.lineViewArray[index];
        if (index < inputText.length) {
            NSString *indexText = [inputText substringWithRange:NSMakeRange(index, 1)];
            label.text = indexText;
            lineView.backgroundColor = [UIColor sfim_colorWithHexString:@"#007AFF"];
        }
        else {
            label.text = @"";
            lineView.backgroundColor = [UIColor sfim_colorWithRed:222 green:226 blue:235];
        }
    }
    if (inputText.length >= CODE_COUNT && self.completion) {
        //验证码输完了
        self.completion(inputText);
    }
}

/**
 成为第一响应者
 */
- (void)textFieldBecomeFirstResponder {
    [self.textField becomeFirstResponder];
}

/**
 辞去第一响应者
 */
- (void)textFieldResignFirstResponder {
    [self.textField resignFirstResponder];
}

#pragma mark - Delegates


#pragma mark - Private method
- (void)configSubviews {
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    for (NSInteger index = 0; index < CODE_COUNT; index ++) {
        UILabel *label = [self getInputLabel];
        [self addSubview:label];
        [self.inputLabelArray addObject:label];
        
        UIView *view = [self getLineView];
        [self addSubview:view];
        [self.lineViewArray addObject:view];
    }
    
     for (NSInteger index = 0; index < CODE_COUNT; index ++) {
         UILabel *label = self.inputLabelArray[index];
         [label mas_makeConstraints:^(MASConstraintMaker *make) {
             if (0 == index) {
                 make.leading.mas_equalTo(self);
             } else {
                 UILabel *beforeLabel = self.inputLabelArray[index - 1];
                 make.leading.mas_equalTo(beforeLabel.mas_trailing).offset(8);
             }
             make.top.bottom.mas_equalTo(self);
             make.width.mas_equalTo(32);
         }];
         
         UIView *lineView = self.lineViewArray[index];
         [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.mas_equalTo(label);
             make.height.mas_equalTo(1);
             make.width.bottom.mas_equalTo(label);
         }];
    }
}

#pragma mark - Getter & Setter
- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [UITextField new];
        textField.textColor = [UIColor whiteColor];
        textField.tintColor = [UIColor whiteColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
        if (@available(iOS 12.0, *)) {//支持验证码提示
            textField.textContentType = UITextContentTypeOneTimeCode;
        }
#endif
        _textField = textField;
    }
    return _textField;
}

- (UILabel *)getInputLabel {
    UILabel *label = [UILabel new];
    label.textColor = [UIColor sfim_colorWithHexString:@"#0B2031"];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIView *)getLineView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor sfim_colorWithRed:222 green:226 blue:235];
    return view;
}

- (NSMutableArray *)inputLabelArray {
    if (!_inputLabelArray) {
        _inputLabelArray = [NSMutableArray array];
    }
    return _inputLabelArray;
}

- (NSMutableArray *)lineViewArray {
    if (!_lineViewArray) {
        _lineViewArray = [NSMutableArray array];
    }
    return _lineViewArray;
}

@end
