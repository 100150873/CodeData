//
//  CourseVideoViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CourseVideoViewController.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "JSON.h"
#import "Config.h"
#import "RESideMenu.h"
#import "CourseVideoListViewCell.h"
#import "CoursesObject.h"
@interface CourseVideoViewController () <CourseVideoListJsonHandlerDelegate>
{
    CourseVideoListJsonHandler *listHandler;
//    CourseVideoObject *cvo;
    CoursesObject *cvo;
    // 刷新
    int currentPageIndex;
    int currentPageSize;
    RefreshFooterView *_footer;
    BOOL noMore;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;

@end

@implementation CourseVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float tableViewHeigh = self.view.bounds.size.height;
    listHandler.ID = @"more";
    cvo = [[CoursesObject alloc] init];
    
    if ([Common isIOS7]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    } else{
        tableViewHeigh -= k_NavigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    // 刷新
    currentPageIndex = 1;
    currentPageSize = 5;
    self.listData = [[NSMutableArray alloc] init];
    self.title = @"视频播放";
    [self changeNavBarTitleColor];
    
    // navbar LeftBar
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeigh) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        tableView;
    });
    _footer = [RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
    _footer.delegate = self;
    noMore = NO;
    listHandler = [[CourseVideoListJsonHandler alloc] init
                   ];
    listHandler.delegate = self;

}

//// 返回又重置
//-(void)reset
//{
//    currentPageIndex=1;
//    [self.listData removeAllObjects];
//    [self.tableView removeFromSuperview];
//    [self.tableView reloadData];
//}
- (void)goBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(courseVideoGoBack)]) {
        [self.delegate courseVideoGoBack];
    }
}

- (void)reset
{
    currentPageIndex = 1;
    [self.listData removeAllObjects];
    [self.tableView removeFromSuperview];
    [self.tableView reloadData];
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

-(void)changeNavBarTitleColor
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

#pragma mark CourseVideoListJsonHandler delegate
- (void)CourseVideoListJsonHandler:(CourseVideoListJsonHandler *)handler withResult:(NSString *)result;
{
    NSArray *resultArr = [result JSONValue];
    if (!resultArr) {
        return;
    }
    if ([handler.ID isEqualToString:@"more"]) {
        NSArray *arr =[CourseVideoObject initWithArray:resultArr];
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
    listHandler.ID = @"more";
    [listHandler handlerCourseVideoObject:cvo cuurentPageIndex:currentPageIndex pageSize:currentPageSize];
}

#pragma mark UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if ([indexPath row] == self.listData.count) {
            return k_RefreshFooterViewHeight;
        }
    }
    return k_CoursesVideoListCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.listData.count + 1;
    }
    return  self.listData.count;
}

// 启动刷新
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.listData.count) {
        FooterRefreshState status;
        status=FooterRefreshStateNormal;
        if (noMore == YES) {
            status = FooterRefreshStateDiseable;
        }
        _footer.status = status;
    }
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
    
    static NSString *ID = @"Cell";
    CourseVideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CourseVideoListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subs_add.png"]];
    }
    CourseVideoObject *obj = [self.listData objectAtIndex:indexPath.row];
    cell.coursesVideo = obj;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.listData.count) {
        return;
    }
    
    // 从视频页面至播放页面
    CourseVideoObject *courseVideoObj = [self.listData objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CourseVideoPlayShow:selectedCourseVideoObject:)]) {
        [self.delegate CourseVideoPlayShow:self selectedCourseVideoObject:courseVideoObj];
    }
}


- (void)setCourseObj:(CoursesObject *)courseObj
{
    [self.view addSubview:self.tableView];
    _courseObj = courseObj;
    if (self.listData.count == 0) {
        listHandler.ID = @"more";
        [listHandler handlerCourseVideoObject:_courseObj cuurentPageIndex:currentPageIndex pageSize:currentPageSize];
    }
}


@end
