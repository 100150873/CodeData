//
//  PTQuestionChoiceButtonView.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "PTQuestionChoiceButtonView.h"

@interface PTQuestionChoiceButtonView ()

@property (nonatomic, strong) UIButton *choiceBtn;      // 选项按钮
@property (nonatomic, strong) UILabel *answerLabel;     // 答案描述
/// 是否正确
@property (nonatomic, strong) UIImageView *choiceStateimageView;
@end

@implementation PTQuestionChoiceButtonView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self choiceCreateInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self choiceCreateInterface];
    }
    return self;
}


#pragma mark - Actions

- (void)tapChoiceBtnViewAction {
    
    if (self.status == ChoiceButtonStatusNormal) {
        self.status = ChoiceButtonStatusSelected;
    }else if (self.status == ChoiceButtonStatusSelected) {
        self.status = ChoiceButtonStatusNormal;
    }
    
    if ([self.delegate respondsToSelector:@selector(touchChoiceButton:)]) {
        [self.delegate touchChoiceButton:self];
    }
}


#pragma mark - 数据处理

- (void)setChoiceType:(NSInteger)ChoiceType {
    _ChoiceType = ChoiceType;
    switch (ChoiceType) {
        case 0:
            [self.choiceBtn setTitle:@"A" forState:UIControlStateNormal];
            break;
        case 1:
            [self.choiceBtn setTitle:@"B" forState:UIControlStateNormal];
            break;
        case 2:
            [self.choiceBtn setTitle:@"C" forState:UIControlStateNormal];
            break;
        case 3:
            [self.choiceBtn setTitle:@"D" forState:UIControlStateNormal];
            break;
        case 4:
            [self.choiceBtn setTitle:@"E" forState:UIControlStateNormal];
            break;
        case 5:
            [self.choiceBtn setTitle:@"F" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setStatus:(ChoiceButtonStatus)status {
    _status = status;
    
    UIImage *choiceImage = nil;
    switch (status) {
        case ChoiceButtonStatusNormal: {
            self.backgroundColor = [UIColor hex:@"#F2F6FF"];
            [_choiceBtn setTitleColor:[UIColor hex:@"121212"] forState:UIControlStateNormal];
            self.answerLabel.textColor = [UIColor hex:@"#020F22"];
//            [_choiceBtn setBackgroundImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"study_circle_white") forState:UIControlStateNormal];
        }
            break;
        case ChoiceButtonStatusSelected: {
            self.backgroundColor = [UIColor hex:@"#007AFF"];
            [_choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.answerLabel.textColor = [UIColor whiteColor];
        }
            break;
        case ChoiceButtonStatusCorrect: {
            self.backgroundColor = [UIColor hex:@"#007AFF"];
            [_choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.answerLabel.textColor = [UIColor whiteColor];
            choiceImage = SFIM_COLLABORATION_RESOURCES_IMAGE(@"choice_right_image");
        }
            break;
        case ChoiceButtonStatusError: {
            self.backgroundColor = [UIColor hex:@"#FE7040"];
            [_choiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.answerLabel.textColor = [UIColor whiteColor];
            choiceImage = SFIM_COLLABORATION_RESOURCES_IMAGE(@"choice_error_image");
        }
            break;
        default:
            break;
    }
    //回答正确、错误图片
    if ([self.subviews containsObject:self.choiceStateimageView]) {
        [self.choiceStateimageView removeFromSuperview];
    }
    self.choiceStateimageView = [[UIImageView alloc] initWithImage:choiceImage];
    [self addSubview:self.choiceStateimageView];
    [self.choiceStateimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(- 14);
    }];
}

- (void)setChoiceDesc:(NSString *)choiceDesc {
    _choiceDesc = choiceDesc;
    self.answerLabel.text = choiceDesc;
}


#pragma mark - 视图布局

- (void)choiceCreateInterface {
    self.backgroundColor = [UIColor hex:@"#F2F6FF"];
    [self setSfim_cornerRadius:8.0];
    [self addSubview:self.choiceBtn];
    [self addSubview: self.answerLabel];
    
    [self.choiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(20, 20)]);
    }];
    
    //选项内容
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choiceBtn.mas_right);
        make.right.equalTo(self).offset(-35);
        make.centerY.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChoiceBtnViewAction)];
    [self addGestureRecognizer:tap];
}


#pragma mark - 懒加载

- (UIButton *)choiceBtn {
    if (!_choiceBtn) {
        _choiceBtn = [[UIButton alloc] init];
        [_choiceBtn setTitleColor:[UIColor hex:@"121212"] forState:0];
        _choiceBtn.titleLabel.font = [UIFont sfim_mediumFontWithSize:14];
        [_choiceBtn setBackgroundImage:GetImage(@"study_circle_white") forState:UIControlStateNormal];
        _choiceBtn.userInteractionEnabled = false;
    }
    return _choiceBtn;
}

- (UILabel *)answerLabel {
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc] init];
        _answerLabel.textColor = [UIColor hex:@"#020F22"];
        _answerLabel.font = [UIFont sfim_mediumFontWithSize:14];
        _answerLabel.numberOfLines = 0;
    }
    return _answerLabel;
}

- (UIImageView *)choiceStateimageView {
    if (!_choiceStateimageView) {
        _choiceStateimageView = [[UIImageView alloc] init];
    }
    return _choiceStateimageView;
}

@end
