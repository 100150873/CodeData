//
//  ZCPlaceholderView.m
//  OpenShop
//
//  Created by GZC on 2018/12/19.
//  Copyright © 2018年 SuWei. All rights reserved.
//

#import "ZCPlaceholderView.h"

@interface ZCPlaceholderView ()

@property (nonatomic , strong) UIImageView       *imgV;
@property (nonatomic , strong) UILabel           *labelDesc;
@property (nonatomic , strong) UIButton          *buttonReload;
@end

@implementation ZCPlaceholderView

/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(ZCPlaceholderViewType)type delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _type = type;
        _delegate = delegate;
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - Public

/**
 修改占位文字和图片

 @param desc 文字
 @param image 图片
 */
- (void)changePlaceholderDesc:(NSString *)desc image:(NSString *)image {
    
    self.labelDesc.text = desc;
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    self.imgV.image = [UIImage imageNamed:image];
    self.imgV.size = imageV.size;
}


/**
 底部按钮标题

 @param buttonTitle 钮标题
 */
- (void)setButtonTitle:(NSString *)buttonTitle {
    
    self.buttonReload.hidden = NO;
    [self.buttonReload setTitle:buttonTitle forState:UIControlStateNormal];
}


#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    
    NSArray *images = @[@"placeholder_noNetwork",@"placeholder_noShop",@"placeholder_noData",@"placeholder_noResult"];
    NSArray *descs = @[@"网络连接异常，请检查您的网络状态",@"您暂时没有门店，快去创建吧",@"暂时没有数据",@"暂时没有搜到相关信息"];
    if (!(_type < images.count)) return;
    self.backgroundColor = [UIColor whiteColor];
    
    //------- 说明label在正中间 -------//
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
    descLabel.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    [self addSubview:descLabel];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = ZCGeneralColor.contentColor_66;
    descLabel.font = ZCGeneralFont.font_15;
    descLabel.text = descs[_type];
    self.labelDesc = descLabel;
    
    //------- 图片在label正上方 -------//
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[_type]]];
    imageView.centerX = self.width * 0.5;
    imageView.bottom = descLabel.top - 25;
    [self addSubview:imageView];
    self.imgV = imageView;
    
    //------- 按钮在说明label下方 -------//
    UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 45, CGRectGetMaxY(descLabel.frame) + 20, 90, 40)];
    [self addSubview:reloadButton];
    [reloadButton setTitleColor:[ZCGeneralColor mainColor] forState:UIControlStateNormal];
    reloadButton.titleLabel.font = ZCGeneralFont.font_15;
    reloadButton.layer.borderColor = [ZCGeneralColor mainColor].CGColor;
    reloadButton.layer.borderWidth = 1;
    reloadButton.layer.cornerRadius = 2.0;
    reloadButton.layer.masksToBounds = YES;
    [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.hidden = YES;
    self.buttonReload = reloadButton;
    
    if (_type == ZCPlaceholderViewTypeNoNetwork) {// 没网
        [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
        reloadButton.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


#pragma mark - 重新加载按钮点击
/** 重新加载按钮点击 */
- (void)reloadButtonClicked:(UIButton *)sender {
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:reloadButtonDidClick:)]) {
        [_delegate placeholderView:self reloadButtonDidClick:sender];
    }
    // 从父视图上移除
    [self removeFromSuperview];
}

@end
