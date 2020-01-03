//
//  ZCShopCategoryVC.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "ZCShopCategoryVC.h"

#import "TableViewHeaderView.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"

#import "ZCBusinessCategoryModel.h"

#import "RuleMatchingTool.h"

static float kLeftTableViewWidth = 90.f;

@interface ZCShopCategoryVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *leftDataSource;
@property (nonatomic, strong) NSMutableArray *rightDataSource;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation ZCShopCategoryVC
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商家类型";
    self.view.backgroundColor = [UIColor whiteColor];

    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self rightItemTitle:@"联系客服" color:ZCGeneralColor.mainTitleColor font:ZCGeneralFont.font_13 action:@selector(clickRightItem:)];
    [self fetchGoodCategoryRequest];
}

#pragma mark - =======Network=========

/**
 获取商家商品分类
 */
- (void)fetchGoodCategoryRequest {
    
    [ZCNetworkManager requestNetworkDataWithParameters:@{ @"CodeType" : @6 } port:BaseData_API resultBlock:^(BOOL success, ZCNetworkCommonModel *response) {
        if (success) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   
                        NSMutableArray <ZCBusinessCategoryModel *> *listData = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[ZCBusinessCategoryModel class] json:response.BusinessData]];
                        
                        for (ZCBusinessCategoryModel *category in listData) {
                            if (category.ParentValue.integerValue == 0) {
                                [self.leftDataSource addObject:category];
                            }
                        }
                        
                        [listData removeObjectsInArray:self.leftDataSource];
                        
                        for (ZCBusinessCategoryModel *parentItem in self.leftDataSource) {
                            NSMutableArray *section = [[NSMutableArray alloc] init];
                            
                            for (ZCBusinessCategoryModel *subItem in listData) {
                                if ([subItem.ParentValue isEqualToString:parentItem.Value]) {
                                    [section addObject:subItem];
                                }
                            }
                            
                            [self.rightDataSource addObject:section];
                        }
                        
                        // 回到主线程
                        dispatch_async(dispatch_get_main_queue(), ^{

                            [self.view addSubview:self.leftTableView];
                            [self.view addSubview:self.rightTableView];
                            
                            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                            animated:YES
                                                      scrollPosition:UITableViewScrollPositionNone];
                        });
                    });
        }
        else {
            [ZCProgressHUD showErrorString:response.ErrorMessage];
        }
    }];
}

#pragma mark - =======Action=========
- (void)clickRightItem:(UIBarButtonItem *)item {
    
    [ZCGeneralTool callWithPhone:[OSCommonDataHelper getServiceTel]];
}


#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView) {
        return 1;
    }
    else {
        return self.leftDataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView) {
        return self.leftDataSource.count;
    }
    else {
        return [self.rightDataSource[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView) {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        ZCBusinessCategoryModel *model = self.leftDataSource[indexPath.row];
        cell.name.text = model.Text;
        [cell showSeparator:NO];
        
        return cell;
    }
    else {
        
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        ZCBusinessCategoryModel *model = self.rightDataSource[indexPath.section][indexPath.row];
        cell.title = model.Text;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView) {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        ZCBusinessCategoryModel *model = self.leftDataSource[section];
        view.name.text = model.Text;
        return view;
    }
    return nil;
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && !_isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && _isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating)) {
    
        if (section + 1 < self.leftDataSource.count) {
            [self selectRowAtIndexPath:section + 1];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView) {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
    else {
        ZCBusinessCategoryModel *model = self.rightDataSource[indexPath.section][indexPath.row];
        !self.selectedCategoryBlock ? : self.selectedCategoryBlock(model.Value,model.Text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;

    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - Getters

- (NSMutableArray *)leftDataSource
{
    if (!_leftDataSource)
    {
        _leftDataSource = [NSMutableArray array];
    }
    return _leftDataSource;
}

- (NSMutableArray *)rightDataSource
{
    if (!_rightDataSource)
    {
        _rightDataSource = [NSMutableArray array];
    }
    return _rightDataSource;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, kScreenHeight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 50;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, 0, kScreenWidth, kScreenHeight)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 50;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    }
    return _rightTableView;
}

@end
