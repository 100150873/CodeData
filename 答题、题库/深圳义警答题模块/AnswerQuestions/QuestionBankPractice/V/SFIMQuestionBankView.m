//
//  SFIMQuestionBankView.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/15.
//

#import "SFIMQuestionBankView.h"

#import "UIButton+HPExtension.h"
#import "SFIMAnswerCutdownView.h"
#import "SFIMQuestionBankCollectionViewCell.h"
#import "SFIMCollaborationModuleDefine.h"

static NSString *const cellIDQuestionBank = @"QuestionBankCellID";

@interface SFIMQuestionBankView ()<UICollectionViewDataSource, UICollectionViewDelegate, SFIMQuestionBankCollectionViewCellDelegate>

@property (nonatomic, strong) SFIMAnswerCutdownView *cutdownView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SFIMQuestionBankView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor hex:@"f5f5f5"];
        _dataArray = [NSArray array];
        [self createInterface];
    }
    return self;
}


#pragma mark - 视图布局

- (void)createInterface {
    self.backgroundColor = [UIColor whiteColor];
    //倒计时view
    [self addSubview:self.cutdownView];
    [self.cutdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(- 20);
        make.height.mas_equalTo(30);
    }];
    // collectionView
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutdownView.mas_bottom).offset(5);
        make.bottom.equalTo(self);
        make.right.left.equalTo(self);
    }];
}


#pragma mark - 内部逻辑实现

#pragma mark - 代理协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFIMQuestionBankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIDQuestionBank forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.isTheLast = (indexPath.row == self.dataArray.count - 1);
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cutdownView.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1, self.dataArray.count];
}


#pragma mark - 代理协议 - DJTestQuestionCellDelegate

/** 下一题 */
- (void)sfimQuestionBankCellTapNextQuestion:(SFIMQuestionBankCollectionViewCell *)cell {
    
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    
    // 作答到最后一题
    if (currentP.item+1 >= self.dataArray.count) {
        if (self.backHomeBlock) {
            self.backHomeBlock();
        }
        return;
    }
    
    NSIndexPath *nextP = [NSIndexPath indexPathForItem:currentP.item+1 inSection:currentP.section];
    [self.collectionView scrollToItemAtIndexPath:nextP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


#pragma mark - 数据请求 / 数据处理

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [_collectionView reloadData];
}


#pragma mark - 懒加载

- (SFIMAnswerCutdownView *)cutdownView {
    if (!_cutdownView) {
        NSBundle *bundle = [NSBundle sfim_subBundleWithBundleName:@"SFIMCollaborationModule" targetClass:[self class]];
        NSArray *views = [bundle loadNibNamed:NSStringFromClass([SFIMAnswerCutdownView class]) owner:nil options:nil];
        _cutdownView = views.firstObject;
        [_cutdownView hideCutdown];
    }
    return _cutdownView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(self.width, self.height - 55);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor hex:@"f5f5f5"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.pagingEnabled = true;
        _collectionView.scrollEnabled = false;
        [_collectionView registerClass:[SFIMQuestionBankCollectionViewCell class] forCellWithReuseIdentifier:cellIDQuestionBank];
    }
    return _collectionView;
}

@end
