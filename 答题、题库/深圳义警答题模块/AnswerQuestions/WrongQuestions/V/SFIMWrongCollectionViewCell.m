//
//  SFIMWrongCollectionViewCell.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import "SFIMWrongCollectionViewCell.h"

#import "PTQuestionChoiceView.h"
#import "SFIMCollaborationModuleDefine.h"

@interface SFIMWrongCollectionViewCell ()

@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) UIView *backView;                     // 白背景
@property (nonatomic, strong) UILabel *titleLabel;                  // 题目
@property (nonatomic, strong) PTQuestionChoiceView *choiceView;     // 选项视图

@property (nonatomic, strong) UIButton *lastBtn;                    //上一题
@property (nonatomic, strong) UIButton *nextBtn;                    //下一题

@property (nonatomic, strong) NSArray *choiceDesc;

/// 正确答案
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation SFIMWrongCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor hex:@"f5f5f5"];
        [self createInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setConstraints];
}

#pragma mark - 内部逻辑实现
- (void)lastBtnAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sfimQuestionCellTapLastQuestion:)]) {
        [self.delegate sfimQuestionCellTapLastQuestion:self];
    }
}

- (void)nextBtnAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sfimQuestionCellTapNextQuestion:)]) {
        [self.delegate sfimQuestionCellTapNextQuestion:self];
    }
}

#pragma mark - 代理协议
- (void)updateTheSelectChoice:(NSArray *)choiceArray {
    
    if ([self.delegate respondsToSelector:@selector(sfimQuestionCellUpdateSelectChoices:cell:)]) {
        [self.delegate sfimQuestionCellUpdateSelectChoices:choiceArray.copy cell:self];
    }
    
    if (choiceArray.count) {
        DEBUGLog(@"选择了 %@",choiceArray);
        self.nextBtn.enabled = true;
        self.nextBtn.backgroundColor = [UIColor hex:@"#344F9C"];
    } else {
        DEBUGLog(@"不可  下一步");
        self.nextBtn.enabled = false;
        self.nextBtn.backgroundColor = [UIColor hex:@"#B4C5DE"];
    }
}


#pragma mark - 数据处理
- (void)setModel:(SFIMTestWrongModel *)model {
    
    _model = model;
    self.titleLabel.text = model.title;
    [_titleLabel changeLineSpace:5.0];
    
    NSString *opString = model.option;
    // 去掉字符串末尾的","
    if ([model.option hasSuffix:@","]) {
        NSInteger opLen = model.option.length;
        opString = [model.option substringToIndex:opLen-1];
    }
    self.choiceDesc = [opString componentsSeparatedByString:@","];
    DEBUGLog(@"我的错题-选项数据：%@",self.choiceDesc);
    
    if (_choiceView && [self.contentView.subviews containsObject:_choiceView]) {
        [self.choiceView removeFromSuperview];
        self.choiceView = nil;
    }
    [self.contentView addSubview:self.choiceView];
    
    // 我的错题，不可编辑
    self.choiceView.userInteractionEnabled = false;
    
    [self.choiceView setChoiceData:self.choiceDesc index:self.indexPathRow+1];
    self.choiceView.correctChoice = @[model.answer];
    self.choiceView.haveSelectChoice = @[model.select_answer];
    self.rightLabel.text = [NSString stringWithFormat:@"正确答案为%@",model.answer];
    NSString *typeString = @"单选";
    if ([model.type integerValue] == 0) {
        typeString = @"单选";
    }else if ([model.type integerValue] == 1) {
        typeString = @"多选";
    }
    
    [self layoutSubviews];
}

- (void)setIsFirst:(BOOL)isFirst {
    _isFirst = isFirst;
    //改变上一题按钮UI
    self.lastBtn.enabled = !isFirst;
    if (isFirst) {
        self.lastBtn.backgroundColor = [UIColor hex:@"#B4C5DE"];
    }else {
        self.lastBtn.backgroundColor = [UIColor hex:@"#344F9C"];
    }
}

- (void)setIsTheLast:(BOOL)isTheLast {
    _isTheLast = isTheLast;
    self.nextBtn.enabled = !isTheLast;
    if (isTheLast) {
        self.nextBtn.backgroundColor = [UIColor hex:@"#B4C5DE"];
    } else {
        self.nextBtn.backgroundColor = [UIColor hex:@"#344F9C"];
    }
}



#pragma mark - 视图布局
- (void)createInterface {
    
    [self.contentView addSubview:self.scrollV];
    [self.contentView addSubview:self.choiceView];
    [self.scrollV addSubview:self.backView];
    [self.scrollV addSubview:self.titleLabel];
    [self.scrollV addSubview:self.lastBtn];
    [self.scrollV addSubview:self.nextBtn];
    [self.scrollV addSubview:self.rightLabel];
}

- (void)setConstraints {
    
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollV).offset(15);
        make.width.mas_equalTo(self.contentView.width - 30);
        make.top.equalTo(self.scrollV).offset(18);
    }];
    
    [self.choiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(60 * _choiceDesc.count);
    }];
    
    //正确答案
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.choiceView.mas_bottom);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.choiceView);
    }];
    
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 110;
    CGFloat margin = 20;
    if (self.lastBtn && [self.scrollV.subviews containsObject:self.lastBtn]) {
        
        [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX).offset(-margin);
            make.top.equalTo(self.backView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        }];
        
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(margin);
            make.top.equalTo(self.lastBtn);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        }];
        
    }else if (self.nextBtn && [self.scrollV.subviews containsObject:self.nextBtn]) {
        
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.backView.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        }];
    }
    
    //30+HP_SCALE_H(30)+50+HP_SCALE_H(60) * _choiceDesc.count+25+titleLabelHeight+18
    //123+HP_SCALE_H(30)+HP_SCALE_H(60) * _choiceDesc.count+titleLabelHeight
    self.scrollV.contentSize = CGSizeMake(self.width, 123 + 55 + 60 * _choiceDesc.count+self.titleLabel.height);
    
}


#pragma mark - 懒加载
- (UIScrollView *)scrollV {
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollV.backgroundColor = [UIColor whiteColor];
        _scrollV.scrollEnabled = false;
    }
    return _scrollV;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView initViewBackColor:[UIColor whiteColor]];
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel initLabelTextFont:26 textColor:[UIColor hex:@"262626"] title:@""];
        _titleLabel.font = [UIFont sfim_mediumFontWithSize:17];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (PTQuestionChoiceView *)choiceView {
    if (!_choiceView) {
        _choiceView = [[PTQuestionChoiceView alloc] init];
        _choiceView.backgroundColor = [UIColor whiteColor];
    }
    return _choiceView;
}

- (UIButton *)lastBtn {
    if (!_lastBtn) {
        _lastBtn = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"上一题" backgroundColor:[UIColor hex:@"#344F9C"] radius:20.0];
        _lastBtn.layer.borderColor = [UIColor hex:@"b2b2b2"].CGColor;
        _lastBtn.layer.borderWidth = 0.5;
        [_lastBtn addTarget:self action:@selector(lastBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton initButtonTitleFont:24 titleColor:[UIColor whiteColor] titleName:@"下一题" backgroundColor:[UIColor hex:@"#344F9C"] radius:20.0];
        _nextBtn.layer.borderColor = [UIColor hex:@"b2b2b2"].CGColor;
        _nextBtn.layer.borderWidth = 0.5;
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.font = [UIFont sfim_mediumFontWithSize:14];
        _rightLabel.textColor = [UIColor sfim_colorWithHexString:@"#020F22"];
    }
    return _rightLabel;
}

@end
