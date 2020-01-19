//
//  SFIMWrongsView.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import "SFIMWrongsView.h"
#import "UIButton+HPExtension.h"
#import "SFIMAnswerCutdownView.h"
#import "SFIMWrongCollectionViewCell.h"
#import "SFIMCollaborationModuleDefine.h"

static NSString *const cellIDCheckWrong = @"CheckWrongCellID";

@interface SFIMWrongsView ()<UICollectionViewDataSource, UICollectionViewDelegate, SFIMWrongCollectionViewCellDelegate>

@property (nonatomic, strong) UIButton *backHomeButton;
@property (nonatomic, strong) SFIMAnswerCutdownView *cutdownView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SFIMWrongsView

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
//    [self addSubview:self.bottomView];
    //倒计时view
    [self addSubview:self.cutdownView];
    [self.cutdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(- 20);
        make.height.mas_equalTo(30);
    }];
    //返回首页button
    [self addSubview:self.backHomeButton];
    [self.backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(- 24);
        make.width.equalTo(@200);
        make.height.mas_equalTo(25);
    }];
    // collectionView
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cutdownView.mas_bottom).offset(5);
        make.bottom.equalTo(self).offset(- 49);
        make.right.left.equalTo(self);
    }];
}


#pragma mark - 内部逻辑实现

#pragma mark - 代理协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFIMWrongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIDCheckWrong forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.isFirst = (indexPath.row == 0);
    cell.isTheLast = (indexPath.row == self.dataArray.count - 1);
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cutdownView.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1, self.dataArray.count];
}


#pragma mark - 代理协议 - DJTestQuestionCellDelegate
/** 上一题 */
- (void)sfimQuestionCellTapLastQuestion:(SFIMWrongCollectionViewCell *)cell {
    //
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    NSIndexPath *lastP = [NSIndexPath indexPathForItem:currentP.item-1 inSection:currentP.section];
    [self.collectionView scrollToItemAtIndexPath:lastP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

/** 下一题 */
- (void)sfimQuestionCellTapNextQuestion:(SFIMWrongCollectionViewCell *)cell {
    
    NSIndexPath *currentP = [self.collectionView indexPathForCell:cell];
    
    // 作答到最后一题
    if (currentP.item+1 >= self.dataArray.count) {
        self.backHomeBlock();
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


#pragma mark - Actions

- (void)clickedBackHomeButton {
    if (self.backHomeBlock) {
        self.backHomeBlock();
    }
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
        layout.itemSize = CGSizeMake(self.width, self.height - 55 - 49);
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 11, self.width, self.height - 11 - HP_SCALE_H(40)) collectionViewLayout:layout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor hex:@"f5f5f5"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.pagingEnabled = true;
        _collectionView.scrollEnabled = false;
        [_collectionView registerClass:[SFIMWrongCollectionViewCell class] forCellWithReuseIdentifier:cellIDCheckWrong];
    }
    return _collectionView;
}

- (UIButton *)backHomeButton {
    if (!_backHomeButton) {
        _backHomeButton = [[UIButton alloc] init];
        [_backHomeButton setTitleColor:[UIColor sfim_colorWithHexString:@"#007AFF"] forState:0];
        [_backHomeButton setImage:SFIM_COLLABORATION_RESOURCES_IMAGE(@"back_home_image") forState:0];
        [_backHomeButton setTitle:@"返回学院首页" forState:0];
        _backHomeButton.titleLabel.font = [UIFont sfim_mediumFontWithSize:16];
        [_backHomeButton addTarget:self action:@selector(clickedBackHomeButton) forControlEvents:UIControlEventTouchDown];
        [_backHomeButton layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _backHomeButton;
}


@end
