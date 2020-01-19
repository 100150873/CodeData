//
//  PTQuestionView.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "PTQuestionView.h"
//#import "SFIMCutdownQuestionView.h"
#import "UIButton+HPExtension.h"
#import "SFIMAnswerCutdownView.h"
#import "PTQuestionCell.h"
#import "SFIMCollaborationModuleDefine.h"

static NSString *const cellIDTestQuestion = @"testQuestionCellID";

@interface PTQuestionView ()<UICollectionViewDataSource, UICollectionViewDelegate, PTQuestionCellDelegate>
//@property (nonatomic, strong) SFIMCutdownQuestionView *bottomView;
@property (nonatomic, strong) UIButton *submitPapersButton;
@property (nonatomic, strong) SFIMAnswerCutdownView *cutdownView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PTQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor hex:@"f5f5f5"];
        _dataArray = [NSArray array];
        [self createInterface];
        self.recordAnswer = [NSMutableArray array];
    }
    return self;
}


#pragma mark - 视图布局

- (void)createInterface {
    self.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.bottomView];
    //倒计时view
    [self addSubview:self.cutdownView];
    [self.cutdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(- 20);
        make.height.mas_equalTo(30);
    }];
    //交卷button
    [self addSubview:self.submitPapersButton];
    [self.submitPapersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(- 24);
        make.width.equalTo(@200);
        make.height.mas_equalTo(25);
    }];
    // collectionView
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutdownView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(- 90);
        make.right.left.equalTo(self);
    }];
//    HPWeakSelf(self)
//    self.bottomView.SFIMCutdownQuestionViewSubmitBlock = ^{
//        DEBUGLog(@"点击 交卷");
//        weakself.SubmitAnswerBlock();
//    };
}


#pragma mark - 内部逻辑实现

#pragma mark - 代理协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PTQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIDTestQuestion forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.isFirst = true;
    }else {
        cell.isFirst = false;
    }
    cell.delegate = self;
    
    if (self.recordAnswer.count <= indexPath.item) {
        // 做新题
        
    }else {
        // 重做的题
        cell.haveSelectChoices = [self.recordAnswer safeObjectAtIndex:indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self.bottomView setCountString:[NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1, self.dataArray.count]];
    self.cutdownView.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1, self.dataArray.count];
}


#pragma mark - 代理协议 - DJTestQuestionCellDelegate
/** 上一题 */
- (void)PTQuestionCellTapLastQuestion:(PTQuestionCell *)cell {
    
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    NSIndexPath *lastP = [NSIndexPath indexPathForItem:currentP.item-1 inSection:currentP.section];
    [self.collectionView scrollToItemAtIndexPath:lastP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

/** 下一题 */
- (void)PTQuestionCellTapNextQuestion:(PTQuestionCell *)cell {
    
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    
    // 作答到最后一题
    if (currentP.item+1 >= self.dataArray.count) {
        self.SubmitAnswerBlock();
        return;
    }
    
    NSIndexPath *nextP = [NSIndexPath indexPathForItem:currentP.item+1 inSection:currentP.section];
    [self.collectionView scrollToItemAtIndexPath:nextP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

/** 更新选中的选项数据 */
- (void)PTQuestionCellUpdateSelectChoices:(NSArray *)choiceArray cell:(PTQuestionCell *)cell {
    
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    // 记录做题的答案
    if (self.recordAnswer.count <= currentP.item) {
        // 做新题
        [self.recordAnswer addObject:choiceArray];
    }else {
        // 重做的题
        [self.recordAnswer replaceObjectAtIndex:currentP.item withObject:choiceArray];
    }
}

#pragma mark - 数据请求 / 数据处理
- (void)setTimeCounting:(NSString *)timeCounting {
    
    _timeCounting = timeCounting;
    self.cutdownView.timeLabel.text = timeCounting;
//    [self.bottomView setTimeString:timeCounting];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [_collectionView reloadData];
}


#pragma mark - Actions

- (void)clickedSubmitPapersButton {
    if (self.SubmitAnswerBlock) {
        self.SubmitAnswerBlock();
    }
}


#pragma mark - 懒加载

- (SFIMAnswerCutdownView *)cutdownView {
    if (!_cutdownView) {
        NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMAnswerCutdownView class]) owner:nil options:nil];
        _cutdownView = views.firstObject;
    }
    return _cutdownView;
}

//- (SFIMCutdownQuestionView *)bottomView {
//    if (!_bottomView) {
//        _bottomView = [[SFIMCutdownQuestionView alloc] initWithFrame:CGRectMake(0, self.height - HP_SCALE_H(40), self.width, HP_SCALE_H(40))];
//    }
//    return _bottomView;
//}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(self.width, self.height - 55 - HP_SCALE_H(49));
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 11, self.width, self.height - 11 - HP_SCALE_H(40)) collectionViewLayout:layout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor hex:@"f5f5f5"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.pagingEnabled = true;
        _collectionView.scrollEnabled = false;
        [_collectionView registerClass:[PTQuestionCell class] forCellWithReuseIdentifier:cellIDTestQuestion];
    }
    return _collectionView;
}

- (UIButton *)submitPapersButton {
    if (!_submitPapersButton) {
        _submitPapersButton = [[UIButton alloc] init];
//        [_submitPapersButton setTitleColor:[UIColor sfim_colorFromString:@"#007AFF"] forState:0];
        [_submitPapersButton setTitleColor:[UIColor sfim_colorWithHexString:@"#007AFF"] forState:0];
        [_submitPapersButton setImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"submit_papers_image") forState:0];
        [_submitPapersButton setTitle:@"交卷" forState:0];
        [_submitPapersButton addTarget:self action:@selector(clickedSubmitPapersButton) forControlEvents:UIControlEventTouchDown];
        [_submitPapersButton layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _submitPapersButton;
}

@end
