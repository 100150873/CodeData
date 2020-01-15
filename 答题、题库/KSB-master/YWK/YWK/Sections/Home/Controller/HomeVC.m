//
//  HomeVC.m
//  SXK
//
//  Created by 杨伟康 on 2016/11/11.
//  Copyright © 2016年 ywk. All rights reserved.
//

#import "HomeVC.h"
#import "ZZCircleProgress.h"
#define ZZRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface HomeVC ()

@property (nonatomic, strong) ZZCircleProgress *circle;

@property (nonatomic, strong) UILabel *totalLab;

@property (nonatomic, strong) UILabel *completeLab;

@property (nonatomic, strong) UILabel *followLab;

@property (nonatomic, strong) UILabel *errorLab;

@end

@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    NSDictionary *dic = DEFAULTS_GET_OBJ(@"follow");
    NSDictionary *dic1 = DEFAULTS_GET_OBJ(@"error");
    self.followLab.text = [NSString stringWithFormat:@"收藏:%ld题",dic.count];
    self.errorLab.text = [NSString stringWithFormat:@"错题:%ld题",dic1.count];
    
    NSInteger k = 0;
    for (int i = 0; i < 6; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic =  DEFAULTS_GET_OBJ(str);
        k = k +dic.count;
    }
    self.completeLab.text = [NSString stringWithFormat:@"完成:%ld题",k];
    self.circle.progress = k / 300.f;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"计算机一级";
    [self initUI];
}

-(void)initUI
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = rgb(18, 103, 213);

    self.circle = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 0, 0) pathBackColor:rgb(159, 200, 247) pathFillColor:rgb(180, 199, 32) startAngle:-90 strokeWidth:10];
    self.circle.progress = 0.0;
    self.circle.showPoint = NO;
    NSDictionary *dic = DEFAULTS_GET_OBJ(@"follow");
    NSDictionary *dic1 = DEFAULTS_GET_OBJ(@"error");

    
    self.totalLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                          andText:@"题量:300题"
                                     andTextColor:[UIColor whiteColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:SYSTEMFONT(14)
                                 andTextAlignment:NSTextAlignmentLeft];

    self.completeLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                            andText:@"完成:0题"
                                       andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(14)
                                   andTextAlignment:NSTextAlignmentLeft];
    
    self.followLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                           andText:[NSString stringWithFormat:@"收藏:%ld题",dic.count]
                                      andTextColor:[UIColor whiteColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(14)
                                  andTextAlignment:NSTextAlignmentLeft];

    self.errorLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                          andText:[NSString stringWithFormat:@"错题:%ld题",dic1.count]
                                     andTextColor:[UIColor whiteColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:SYSTEMFONT(14)
                                 andTextAlignment:NSTextAlignmentLeft];
    
    
    
    
    
    
    

    
    [view addSubview:self.circle];
    [self.view addSubview:view];
    [view addSubview:self.totalLab];
    [view addSubview:self.completeLab];
    [view addSubview:self.followLab];
    [view addSubview:self.errorLab];
    
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view.mas_left).offset(30);
        make.size.mas_equalTo(CGSizeMake(130, 130));
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.height.equalTo(@(180));
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circle.mas_top).offset(10);
        make.left.equalTo(self.circle.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [self.completeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLab.mas_bottom).offset(15);
        make.left.equalTo(self.circle.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [self.followLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.completeLab.mas_bottom).offset(15);
        make.left.equalTo(self.circle.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [self.errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followLab.mas_bottom).offset(15);
        make.left.equalTo(self.circle.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];

    UIButton *Subjects = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f, 200, 80, 80) andTitle:@"考试大纲" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:rgb(40, 186, 188)];
    [Subjects addTarget:self action:@selector(SubjectsClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects, 40);
    
    UIButton *Subjects1 = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f*2 +80, 200, 80, 80) andTitle:@"选择题" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:rgb(27, 106, 228)];
    [Subjects1 addTarget:self action:@selector(SubjectsClick1:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects1, 40);
    
    UIButton *Subjects2 = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f*3 +160, 200, 80, 80) andTitle:@"操作题" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:rgb(52, 163, 30)];
    [Subjects2 addTarget:self action:@selector(SubjectsClick2:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects2, 40);
    
    UIButton *Subjects3 = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f, 300, 80, 80) andTitle:@"我的收藏" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:rgb(211, 11, 21)];
    [Subjects3 addTarget:self action:@selector(SubjectsClick3:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects3, 40);
    
    UIButton *Subjects4 = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f*2 +80, 300, 80, 80) andTitle:@"我的错题" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:[UIColor orangeColor]];
    [Subjects4 addTarget:self action:@selector(SubjectsClick4:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects4, 40);
    
    UIButton *Subjects5 = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME((SCREEN_WIDTH - 240)/4.f*3 +160, 300, 80, 80) andTitle:@"初始化" andFont:SYSTEMFONT(14)andTitleColor:[UIColor whiteColor] andBackgroundColor:rgb(180, 180, 180)];
    [Subjects5 addTarget:self action:@selector(SubjectsClick5:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(Subjects5, 40);

    
    [self.view addSubview:Subjects];
    [self.view addSubview:Subjects1];
    [self.view addSubview:Subjects2];
    [self.view addSubview:Subjects3];
    [self.view addSubview:Subjects4];
    [self.view addSubview:Subjects5];
}


-(void)SubjectsClick:(UIButton *)sender
{
    [self PushViewControllerByClassName:@"ExamVC" info:nil];
}


-(void)SubjectsClick1:(UIButton *)sender
{
    [self PushViewControllerByClassName:@"SubjectsList" info:nil];

}

-(void)SubjectsClick2:(UIButton *)sender
{
//    NSDictionary *dic = @{@"type":@"2"};
    [self PushViewControllerByClassName:@"operationVC" info:nil];
}

-(void)SubjectsClick3:(UIButton *)sender
{
    NSDictionary *dic = @{@"type":@"1"};
    [self PushViewControllerByClassName:@"SubjectsVC" info:dic];
}

-(void)SubjectsClick4:(UIButton *)sender
{
    NSDictionary *dic = @{@"type":@"2"};
    [self PushViewControllerByClassName:@"SubjectsVC" info:dic];
}

-(void)SubjectsClick5:(UIButton *)sender
{
    NSDictionary *dic = [[NSDictionary alloc] init];
    NSDictionary *dic1 = [[NSDictionary alloc] init];
    DEFAULTS_SET_OBJ(dic, @"follow");
    DEFAULTS_SET_OBJ(dic1, @"error");
    [ProgressHUDHandler showHudTipStr:@"清除完成"];
    
    self.followLab.text = [NSString stringWithFormat:@"收藏:%ld题",dic.count];
    self.errorLab.text = [NSString stringWithFormat:@"错题:%ld题",dic1.count];
    self.completeLab.text = [NSString stringWithFormat:@"完成:%ld题",dic1.count];
    self.circle.progress = 0.0;

    for (int i = 0; i < 6; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = [[NSDictionary alloc] init];
        DEFAULTS_SET_OBJ(dic, str);
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
