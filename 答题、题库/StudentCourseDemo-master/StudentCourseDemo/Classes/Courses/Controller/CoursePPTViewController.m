//
//  CoursePPTViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/3.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursePPTViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Config.h"
#import "Common.h"
#import "CourseListViewCelL.h"
#import "CoursePPTObject.h"
#import "CoursePPTListJsonHandler.h"
#import "CoursePPTListViewCell.h"

@interface CoursePPTViewController () <CoursePPTListJsonHandlerDelegate>
{
    CoursePPTListJsonHandler *listHandler;
    CoursePPTObject *cpo;
    
    int currentPageIndex;
    int currentPageSize;
    RefreshFooterView *_footer;
    BOOL noMore;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;

@end


@implementation CoursePPTViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // 需要隐藏的地方，加入隐藏当前提示
    [SVProgressHUD dismiss];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float tableViewHeigh = self.view.bounds.size.height;
    listHandler.ID = @"more";
    cpo = [[CoursePPTObject alloc] init];
    currentPageIndex = 1;
    currentPageSize = 10;
    noMore = NO;
    if ([Common isIOS7]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    } else{
        tableViewHeigh -= k_NavigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.title =@"PPT列表";
    self.listData = [[NSMutableArray alloc] init];
    // 设置标题颜色
    [self changNavBarTitleColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeigh) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [self.view addSubview:tableView];
        tableView;
    });
    _footer = [RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
    _footer.delegate = self;
    
    listHandler = [[CoursePPTListJsonHandler alloc] init
                   ];
    listHandler.delegate = self;
//    NSLog(@"viewDidLoad");
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(coursePPtGoBack)]) {
        [self.delegate coursePPtGoBack];
    }
}

// 返回又重置
-(void)reset
{
    currentPageIndex=1;
    [self.listData removeAllObjects];
    [self.tableView removeFromSuperview];
    [self.tableView reloadData];
}

- (void)changNavBarTitleColor
{
    UIColor *cc = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    _footer.status = FooterRefreshStateNormal;
}

#pragma mark CoursePPTListJsonHandler delegate
- (void)CoursePPTListHandler:(CoursePPTListJsonHandler *)handler withResult:(NSString *)result
{
//    NSLog(@"1");
//    NSLog(@"CoursePPTListHandler");
    NSArray *resultArr = [result JSONValue];
    if (!resultArr) {
        return;
    }
    if ([handler.ID isEqualToString:@"more"]) {
        NSArray *arr = [CoursePPTObject initWithArray:resultArr];
        if (arr.count == 0) {
            noMore = YES;
        }
        [self.listData addObjectsFromArray:arr];
        currentPageIndex++;
        [self reloadTableView];
        
    }
}


#pragma mark footer refresh delegate
- (void)refreshFooterBegin:(RefreshFooterView *)view
{
//     NSLog(@"refreshFooterBegin");
    listHandler.ID = @"more";
//    //加载更多
//    if (self.listData.count==0) {
//        return;
//    }
    [listHandler handlerCoursePPTObject:_coursesObj currentPageIndex:currentPageIndex pageSize:currentPageSize];
}

#pragma mark tableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.listData.count ) {
        return k_RefreshFooterViewHeight;
    }
    return k_CoursePPTListCell_Height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.listData.count) {
        // 底部刷新
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
        [_footer setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [cell.contentView addSubview:_footer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *ID = @"cell";
    CoursePPTListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CoursePPTListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
//    NSLog(@"cellForRowAtIndexPath");
    
    CoursePPTObject *pptObj = [self.listData objectAtIndex:indexPath.row];
    cell.coursePPT = pptObj;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.listData.count + 1;
    }
    return self.listData.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"willDisplayCell");
    if ([indexPath row] == self.listData.count) {
        FooterRefreshState status;
        status=FooterRefreshStateNormal;
        if (noMore) {
            status = FooterRefreshStateDiseable;
        }
        _footer.status = status;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.listData.count) {
        return ;
    }
//    self.delegate = self;
    // 从PPT页面至内容页面
    CoursePPTObject *coursePPtObj = [self.listData objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(coursePPtHome:selectedPPtObj:)]) {
        [self.delegate coursePPtHome:self selectedPPtObj:coursePPtObj];
    }
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
//    int index = indexPath.row;
//    CoursePPTObject *obj = nil;
//    if (tableView == self.tableView) {
//        obj = [self.listData objectAtIndex:index];
//    }
//    
//    Load WebView
}

- (void)setCoursesObj:(CoursesObject *)courseObj
{
    [self.view addSubview:self.tableView];
  
    _coursesObj=courseObj;
//    self.title=self.authorObj.name;
//    _footer.status=FooterRefreshStateNormal;
//    [self initFavBtn];
    if (self.listData.count==0) {
        listHandler.ID = @"more";
//        NSLog(@"123");
        [listHandler handlerCoursePPTObject:_coursesObj currentPageIndex:currentPageIndex pageSize:currentPageSize];
    }
    
}

@end
