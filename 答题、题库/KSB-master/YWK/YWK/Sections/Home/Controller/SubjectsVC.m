//
//  SubjectsVC.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/23.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "SubjectsVC.h"
#import "SubjectCell.h"
#import "HWProgressView.h"

@interface SubjectsVC ()

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UISlider *progressView;

@property (nonatomic, strong) UILabel *indexLab;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSMutableArray *titleArr;//题目数据源

@property (nonatomic, strong) NSMutableArray *answerArr;//答案数据源

@property (nonatomic, strong) NSMutableArray *rightAnswer;

@property (nonatomic, strong) NSMutableArray *answerExplain;

@property (nonatomic, assign) NSInteger index; //题目标记

@property (nonatomic, strong) SubjectCell *CellA;

@property (nonatomic, strong) SubjectCell *CellB;

@property (nonatomic, strong) SubjectCell *CellC;

@property (nonatomic, strong) SubjectCell *CellD;

@property (nonatomic, strong) UILabel *answerLab;

@property (nonatomic, strong) UILabel *ExplainLab;

@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger index1;

@property (nonatomic, assign) BOOL isShowAnswer;

@property (nonatomic, strong) UIButton *answerBtn;

@end

@implementation SubjectsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArr = [[NSMutableArray alloc] init];
    self.answerArr = [[NSMutableArray alloc] init];
    self.rightAnswer = [[NSMutableArray alloc] init];
    self.answerExplain = [[NSMutableArray alloc] init];
    self.dataDic = [[NSMutableDictionary alloc] init];
    self.index = 0;
    self.isShowAnswer = 0;
    
    
    NSDictionary *dic;
    
    if ([self.myDict[@"type"] isEqualToString:@"1"]) {
        dic = DEFAULTS_GET_OBJ(@"follow");
        self.navigationItem.title = @"我的收藏";

    }else{
        dic = DEFAULTS_GET_OBJ(@"error");
        self.navigationItem.title = @"错题库";

    }
    
    
    for (NSDictionary *dic1 in [dic allValues]) {
        NSLog(@"%@",describe(dic1));
        [self.titleArr addObject:dic1[@"title"]];
        NSArray *arr = dic1[@"answer"];
        [self.answerArr addObject:arr];
        [self.answerExplain addObject:dic1[@"explain"]];
        [self.rightAnswer addObject:dic1[@"right"]];
    }
    
    
    if (self.titleArr.count > 0 ) {
        [self.view addSubview:self.tableView];
    }
    [self initUI];
    
}

-(void)initUI
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = rgb(240, 240, 240);
    
    self.progressView = [[UISlider alloc] initWithFrame:CGRectMake(30, 365, SCREEN_WIDTH-30, 10)];
    [self.progressView  setThumbImage:[UIImage imageNamed:@"打叉"] forState:UIControlStateNormal];
    self.progressView.minimumValue = 0;
    self.progressView.maximumValue = self.titleArr.count -1;
    [self.progressView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.progressView];
    
    self.indexLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                          andText:[NSString stringWithFormat:@"1/%ld",self.answerArr.count]
                                     andTextColor:[UIColor blackColor]
                                       andBgColor:[UIColor clearColor]
                                          andFont:SYSTEMFONT(14)
                                 andTextAlignment:NSTextAlignmentCenter];
    
    UIButton *leftBtn = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME(0, 0, 0, 0) andTitle:@"上一题" andFont:SYSTEMFONT(14) andTitleColor:[UIColor blackColor] andBackgroundColor:[UIColor clearColor]];
    UIImage *leftImg = [UIImage imageNamed:@"返回-(1)"];
    [leftBtn setImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME(0, 0, 0, 0) andTitle:@"下一题" andFont:SYSTEMFONT(14) andTitleColor:[UIColor blackColor] andBackgroundColor:[UIColor clearColor]];
    UIImage *rightImg = [UIImage imageNamed:@"返回R"];
    [rightBtn setImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *answerBtn = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME(0, 0, 0, 0) andTitle:@"" andFont:SYSTEMFONT(14) andTitleColor:[UIColor blackColor] andBackgroundColor:[UIColor clearColor]];
    UIImage *answerImg = [UIImage imageNamed:@"矢量智能对象"];
    [answerBtn setImage:answerImg forState:UIControlStateNormal];
    [answerBtn addTarget:self action:@selector(answerBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.answerBtn = answerBtn;
    
    UIButton *followBtn = [UIButton createButtonWithButtonType:UIButtonTypeSystem andFrame:VIEWFRAME(0, 0, 0, 0) andTitle:@"" andFont:SYSTEMFONT(14) andTitleColor:[UIColor blackColor] andBackgroundColor:[UIColor clearColor]];
    UIImage *followImg = [UIImage imageNamed:@"矩形-1-拷贝"];
    [followBtn setImage:followImg forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(followBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:leftBtn];
    [view addSubview:rightBtn];
    [view addSubview:answerBtn];
    [view addSubview:followBtn];
    [view addSubview:self.progressView];
    [view addSubview:self.indexLab];
    
    
    [self.view addSubview:view];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(20);
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(view.mas_top).offset(5);
        make.height.mas_equalTo(@(15));
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.mas_equalTo(@(80));
    }];
    
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 16));
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.centerY.equalTo(self.indexLab.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(15, 30));
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.centerY.equalTo(self.indexLab.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(15, 30));
    }];
    
    [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.indexLab.mas_centerY);
        make.right.equalTo(self.indexLab.mas_left).offset(-25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.indexLab.mas_centerY);
        make.left.equalTo(self.indexLab.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-44) style:UITableViewStyleGrouped];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerClass:[SubjectCell class] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        
    }
    return _tableView;
}


- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 530.0000/667*SCREEN_HIGHT)];
        _headView.backgroundColor = [UIColor whiteColor];
        NSString *str;
        if (self.titleArr.count == 0) {
            str = @"";
        }else{
            str = self.titleArr[self.index];
        }

        
        
        UILabel *content = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                                 andText:str
                                            andTextColor:[UIColor blackColor]
                                              andBgColor:[UIColor clearColor]
                                                 andFont:SYSTEMFONT(14)
                                        andTextAlignment:NSTextAlignmentLeft];
        content.numberOfLines = 0;
        CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:str font:SYSTEMFONT(14)];
        
        _headView.frame = VIEWFRAME(0, 0, SCREEN_WIDTH, height+10);
        
        [_headView addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView.mas_left).offset(15);
            make.right.equalTo(_headView.mas_right).offset(-15);
            make.top.equalTo(_headView.mas_top).offset(5);
            make.height.mas_equalTo(@(height));
        }];
        
        self.titleLab = content;
    }
    return _headView;
}



#pragma mark -- UITabelViewDelegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = self.answerArr[self.index];
    SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillWithTitle:arr[indexPath.row] index:indexPath.row];
    cell.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:{
            self.CellA = cell;
        }
            break;
        case 1:{
            self.CellB = cell;
        }
            break;
            
        case 2:{
            self.CellC = cell;
        }
            break;
            
        case 3:{
            self.CellD = cell;
        }
            break;
            
            
        default:
            break;
    }
    
    
    NSNumber *i = [self.dataDic valueForKey:[NSString stringWithFormat:@"%ld",self.index]];
    if ([i integerValue] > 0) {
        
        NSString *answer = self.rightAnswer[self.index];
        NSInteger right = [self right:answer];
        NSString *select;
        
        switch ([i integerValue] - 1) {
            case 0:{
                select = @"A";
            }break;
                
            case 1:{
                select = @"B";
            }break;
                
            case 2:{
                select = @"C";
            }break;
                
            case 3:{
                select = @"D";
            }break;
                
                
            default:
                break;
        }
        
        if ([answer isEqualToString:select]) {
            
            if (indexPath.row == [i integerValue] - 1) {
                [cell isRightWithIndex:indexPath.row];
                self.type = 1;
                self.index1 = [i integerValue] - 1;
                return cell;
            }
            
        }else{
            self.type = 2;
            self.index1 = [i integerValue] - 1;
            if (indexPath.row == [i integerValue] - 1) {
                [cell isWrong];
                return cell;
            }
            
            if (indexPath.row == right) {
                [cell isRightWithIndex:indexPath.row];
                return cell;
            }
        }
        
    }
    
    if (self.isShowAnswer) {
        NSString *answer = self.rightAnswer[self.index];
        NSInteger right = [self right:answer];
        if (indexPath.row == right) {
            self.type = 4;
            [cell isRightWithIndex:indexPath.row];
            return cell;
        }
    }
    
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.footView = view;
    self.answerLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                           andText:@""
                                      andTextColor:[UIColor blackColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(14)
                                  andTextAlignment:NSTextAlignmentLeft];
    
    self.ExplainLab = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                            andText:@""
                                       andTextColor:[UIColor blackColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(14)
                                   andTextAlignment:NSTextAlignmentLeft];
    self.ExplainLab.numberOfLines = 0;
    
    [view addSubview:self.answerLab];
    [view addSubview:self.ExplainLab];
    
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:self.answerExplain[self.index] font:SYSTEMFONT(14)];
    
    [self.answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(10);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    [self.ExplainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(self.answerLab .mas_bottom).offset(10);
        make.right.equalTo(view.mas_right).offset(-15);
        make.height.mas_equalTo(height);
    }];
    
    
    if (self.type == 1) {
        self.answerLab.textColor = [UIColor colorWithHexColorString:@"4c9038"];
        self.answerLab.text = [NSString stringWithFormat:@"答对了,正确答案:%@",[self whichIsRight:self.index1]];
        self.ExplainLab.text = self.answerExplain[self.index];
    }else if (self.type == 2){
        NSString *answer = self.rightAnswer[self.index];
        NSInteger right = [self right:answer];
        self.answerLab.textColor = [UIColor redColor];
        self.answerLab.text = [NSString stringWithFormat:@"答错了,正确答案是%@,您的答案是:%@",[self whichIsRight:right],[self whichIsRight:self.index1]];
        self.ExplainLab.text = self.answerExplain[self.index];
    }else if (self.type == 3){
        self.answerLab.text = @"";
        self.answerLab.text = @"";
    }else if (self.type == 4){
        self.answerLab.textColor = [UIColor redColor];
        self.answerLab.text = [NSString stringWithFormat:@"未回答,正确答案:%@",[self whichIsRight:self.index1]];
        self.ExplainLab.text = self.answerExplain[self.index];
    }
    
    
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShowAnswer) {
        return;
    }
    
    NSNumber *i = [self.dataDic valueForKey:[NSString stringWithFormat:@"%ld",self.index]];
    if ([i integerValue] > 0) {
        return;
    }
    
    
    
    NSString *answer = self.rightAnswer[self.index];
    [self selectWithIndex:indexPath.row answer:answer];
    [self.dataDic setValue:@(indexPath.row + 1) forKey:[NSString stringWithFormat:@"%ld",self.index]];
    
    
    
}
-(NSInteger)right:(NSString *)answer
{
    if ([answer isEqualToString:@"A"]) {
        return 0;
    }
    if ([answer isEqualToString:@"B"]) {
        return 1;
    }
    if ([answer isEqualToString:@"C"]) {
        return 2;
    }
    if ([answer isEqualToString:@"D"]) {
        return 3;
    }
    return 0;
}



-(NSString *)whichIsRight:(NSInteger)right
{
    switch (right) {
        case 0:{
            return @"A";
        }break;
            
        case 1:{
            return @"B";
        }break;
            
        case 2:{
            return @"C";
        }break;
            
        case 3:{
            return @"D";
        }break;
            
        default:
            break;
    }
    return @"";
}


-(void)selectWithIndex:(NSInteger)index answer:(NSString *)answer
{
    
    
    NSInteger i =0;
    switch (index) {
        case 0:{
            if ([answer isEqualToString:@"A"]) {
                [self.CellA isRightWithIndex:index];
                self.answerLab.textColor = [UIColor colorWithHexColorString:@"4c9038"];
                self.answerLab.text = @"答对了,正确答案:A";
                
            }else{
                [self.CellA isWrong];
                self.answerLab.textColor = [UIColor redColor];
                self.answerLab.text = [NSString stringWithFormat:@"答错了,正确答案是%@,您的答案是:A",   [self isRight:answer]];
                i=1;
            }
            
        }
            break;
        case 1:{
            if ([answer isEqualToString:@"B"]) {
                [self.CellB isRightWithIndex:index];
                self.answerLab.textColor = [UIColor colorWithHexColorString:@"4c9038"];
                self.answerLab.text = @"答对了,正确答案:B";
                
            }else{
                [self.CellB isWrong];
                
                self.answerLab.textColor = [UIColor redColor];
                self.answerLab.text = [NSString stringWithFormat:@"答错了,正确答案是%@,您的答案是:B",   [self isRight:answer]];
                i=1;
            }
            
        }
            break;
            
        case 2:{
            if ([answer isEqualToString:@"C"]) {
                [self.CellC isRightWithIndex:index];
                self.answerLab.textColor = [UIColor colorWithHexColorString:@"4c9038"];
                self.answerLab.text = @"答对了,正确答案:C";
                
                
            }else{
                
                self.answerLab.textColor = [UIColor redColor];
                self.answerLab.text = [NSString stringWithFormat:@"答错了,正确答案是%@,您的答案是:C",   [self isRight:answer]];
                
                [self.CellC isWrong];
                i=1;
            }
            
        }
            break;
            
        case 3:{
            if ([answer isEqualToString:@"D"]) {
                [self.CellD isRightWithIndex:index];
                self.answerLab.textColor = [UIColor colorWithHexColorString:@"4c9038"];
                self.answerLab.text = @"答对了,正确答案:D";
                
            }else{
                
                self.answerLab.textColor = [UIColor redColor];
                self.answerLab.text = [NSString stringWithFormat:@"答错了,正确答案是%@,您的答案是:D",   [self isRight:answer]];
                
                [self.CellD isWrong];
                i=1;
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    self.ExplainLab.text = self.answerExplain[self.index];
    if (i == 1) {
        
        NSDictionary *dic1 = DEFAULTS_GET_OBJ(@"follow");
        
        
        NSNumber * type = self.myDict[@"type"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *usersDic = [[NSMutableDictionary alloc] initWithDictionary:dic1];
        [dic setObject:self.titleArr[self.index] forKey:@"title"];
        NSArray *arr = self.answerArr[self.index];
        [dic setObject:arr forKey:@"answer"];
        [dic setObject:self.answerExplain[self.index] forKey:@"explain"];
        [dic setObject:self.rightAnswer[self.index] forKey:@"right"];
        [usersDic setObject:dic forKey: [NSString stringWithFormat:@"%ld-%ld",[type integerValue],self.index]];
        DEFAULTS_SET_OBJ(usersDic, @"error");
        NSLog(@"%@",describe(usersDic));
        
    }
    
}



-(NSString *)isRight:(NSString *)answer
{
    if ([answer isEqualToString:@"A"]) {
        [self.CellA isRightWithIndex:0];
        return @"A";
    }
    
    if ([answer isEqualToString:@"B"]) {
        [self.CellB isRightWithIndex:1];
        return @"B";
        
    }
    
    
    if ([answer isEqualToString:@"C"]) {
        [self.CellC isRightWithIndex:2];
        return @"C";
        
    }
    
    
    if ([answer isEqualToString:@"D"]) {
        [self.CellD isRightWithIndex:3];
        return @"D";
        
    }
    return @"";
    
}


-(void)leftBtnClick:(UIButton *)sender
{
    if (self.titleArr.count == 0) {
        return;
    }

    if (self.index == 0) {
        [ProgressHUDHandler showHudTipStr:@"已经是第一题了"];
        return;
    }
    self.index -= 1;
    self.indexLab.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.answerArr.count];
    self.progressView.value = self.index;
    self.titleLab.text = self.titleArr[self.index];
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:self.titleArr[self.index] font:SYSTEMFONT(14)];
    self.headView.frame = VIEWFRAME(0, 0, SCREEN_WIDTH, height+10);
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.right.equalTo(_headView.mas_right).offset(-15);
        make.top.equalTo(_headView.mas_top).offset(5);
        make.height.mas_equalTo(@(height));
        
    }];
    
    self.type =3;
    [self.tableView reloadData];
    
}

-(void)rightBtnClick:(UIButton *)sender
{
    if (self.titleArr.count == 0) {
        return;
    }

    if (self.index == self.titleArr.count - 1) {
        [ProgressHUDHandler showHudTipStr:@"已经是最后一题了"];
        return;
    }
    self.index += 1;
    self.indexLab.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.answerArr.count];
    self.progressView.value = self.index;
    self.titleLab.text = self.titleArr[self.index];
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:self.titleArr[self.index] font:SYSTEMFONT(14)];
    self.headView.frame = VIEWFRAME(0, 0, SCREEN_WIDTH, height+10);
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.right.equalTo(_headView.mas_right).offset(-15);
        make.top.equalTo(_headView.mas_top).offset(5);
        make.height.mas_equalTo(@(height));
        
    }];
    self.type =3;
    [self.tableView reloadData];
}


-(void)sliderAction:(UISlider *)slider
{
    if (self.titleArr.count == 0) {
        return;
    }
    NSInteger i = (NSInteger)slider.value;
    self.index = i;
    slider.value = i;
    self.indexLab.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.answerArr.count];
    self.titleLab.text = self.titleArr[self.index];
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:self.titleArr[self.index] font:SYSTEMFONT(14)];
    self.headView.frame = VIEWFRAME(0, 0, SCREEN_WIDTH, height+10);
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headView.mas_left).offset(15);
        make.right.equalTo(_headView.mas_right).offset(-15);
        make.top.equalTo(_headView.mas_top).offset(5);
        make.height.mas_equalTo(@(height));
        
    }];
    self.type =3;
    
    [self.tableView reloadData];
}


-(void)followBtn:(UIButton *)sender
{
    if (self.titleArr.count == 0) {
        return;
    }

    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuestionFollow" ofType:@"plist"];
    //    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    //    NSNumber * type = self.myDict[@"type"];
    //    NSDictionary *dic1 = [usersDic valueForKey:[NSString stringWithFormat:@"%ld-%ld",[type integerValue],self.index]];
    //    if (dic1.count != 0) {
    //        [ProgressHUDHandler showHudTipStr:@"你已经收藏过本题"];
    //    }else{
    //        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //        [dic setObject:self.titleArr[self.index] forKey:@"title"];
    //        NSArray *arr = self.answerArr[self.index];
    //        [dic setObject:arr forKey:@"answer"];
    //        [dic setObject:self.answerExplain[self.index] forKey:@"explain"];
    //        [usersDic setObject:dic forKey: [NSString stringWithFormat:@"%ld-%ld",[type integerValue],self.index]];
    //        BOOL i = [usersDic writeToFile:plistPath atomically:YES];
    //
    //        if (i) {
    //            [ProgressHUDHandler showHudTipStr:@"收藏成功"];
    //        }
    //    }
    //
    //    NSLog(@"%@",plistPath);
    
    
    
    NSDictionary *dic = DEFAULTS_GET_OBJ(@"follow");
    NSNumber * type = self.myDict[@"type"];
    NSDictionary *dic1 = [dic valueForKey:[NSString stringWithFormat:@"%ld-%ld",[type integerValue],self.index]];
    if (dic1.count != 0) {
        [ProgressHUDHandler showHudTipStr:@"你已经收藏过本题"];
    }else{
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *usersDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [dic setObject:self.titleArr[self.index] forKey:@"title"];
        NSArray *arr = self.answerArr[self.index];
        [dic setObject:arr forKey:@"answer"];
        [dic setObject:self.answerExplain[self.index] forKey:@"explain"];
        [dic setObject:self.rightAnswer[self.index] forKey:@"right"];
        [usersDic setObject:dic forKey: [NSString stringWithFormat:@"%ld-%ld",[type integerValue],self.index]];
        DEFAULTS_SET_OBJ(usersDic, @"follow");
        [ProgressHUDHandler showHudTipStr:@"收藏成功"];
        
    }
    
}

-(void)answerBtn:(UIButton *)sender
{
    
    if (self.isShowAnswer) {
        self.isShowAnswer =NO;
        UIImage *answerImg = [UIImage imageNamed:@"矢量智能对象"];
        [sender setImage:answerImg forState:UIControlStateNormal];
        self.type =3;
        
    }else{
        self.isShowAnswer = YES;
        UIImage *answerImg = [UIImage imageNamed:@"笔"];
        [sender setImage:answerImg forState:UIControlStateNormal];
        
    }
    [self.tableView reloadData];
    
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
