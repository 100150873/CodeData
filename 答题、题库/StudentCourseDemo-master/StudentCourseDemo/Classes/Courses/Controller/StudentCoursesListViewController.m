//
//  StudentCoursesListViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/2.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "StudentCoursesListViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "Config.h"
#import "Common.h"
#import "CourseListViewCelL.h"
#import "CoursePPTViewController.h"
#import "RESideMenu.h"

@interface StudentCoursesListViewController () <CoursesCellDelegate>
{
//    UISearchDisplayController *searchDisplay;
//    UISearchBar *searchBar;
    CourseListJsonHandler *listHandler;
    CoursesObject *cvo;
    //刷新
    int currentPageIndex;
    int currentPageSize;
//    //查找
//    int searchPageIndex;
//    int searchPageSize;
    RefreshFooterView *_footer;
    BOOL noMore;
//    BOOL temp;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;
//@property (nonatomic,strong) NSMutableArray *searchListData;
//@property (nonatomic,strong) NSString   *searchText;
@end
@implementation StudentCoursesListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //需要隐藏的地方,加入隐藏当前提示
    [SVProgressHUD dismiss];
    [super viewWillAppear:animated];
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    float tableViewHeith = self.view.bounds.size.height;
    //NSLog(@"%lf",tableViewHeith);
    //NSLog(@"1");
    listHandler.ID=@"more";
    cvo = [[CoursesObject alloc] init];
    cvo.ClassID = 22;
//    cvo.CourseName = @"哈哈";
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=YES;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
        //        NSLog(@"123");
        
    }
    else{
        tableViewHeith-=k_NavigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //刷新
//    cvo.ClassID=22;
    currentPageIndex = 1;
    currentPageSize = 5;
//    //查找
//    searchPageIndex = 1;
//    searchPageSize = 100;
    self.listData = [[NSMutableArray alloc] init];
//    self.searchListData = [[NSMutableArray alloc] init];
    self.title =  @"在线学习";
    [self changeNavBarTitleColor];
//    //navbar
//    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    
//    self.navigationItem.leftBarButtonItem=back;
    
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [self.view addSubview:tableView];
        tableView;
    });
    
    _footer=[RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
//    _footer.status=FooterRefreshStateNormal;
    _footer.delegate=self;
    
    listHandler = [[CourseListJsonHandler alloc] init];
    listHandler.delegate=self;
    noMore=NO;
    // NSLog(@"1231");
    
    
//    searchBar = [[UISearchBar alloc] init];
//    [searchBar sizeToFit];
//    searchBar.placeholder=@"搜索其他课程";
//    //[searchBar setBackgroundImage:[[UIImage alloc] init]];
//    [searchBar setTranslucent:YES];
//    searchBar.delegate = self;
//    self.tableView.tableHeaderView=searchBar;
//    searchDisplay = [[UISearc/Users/lmj/Desktop/开发/StudentCourseDemo/StudentCourseDemo/Classes/Courses/Controller/StudentCoursesListViewController.mhDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchDisplay.delegate = self;
//    searchDisplay.searchResultsDataSource = self;
//    searchDisplay.searchResultsDelegate = self;
    //[self getlistDataFraomWeb];
}


- (void)showMenu
{
    NSLog(@"showMenu");
    [self.sideMenuViewController presentMenuViewController];
}



-(void)changeNavBarTitleColor
{
    UIColor *cc = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
-(void)successLoadList
{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
//    _footer.status=FooterRefreshStateNormal;
    
}
- (void)reloadTableView
{
    [self.tableView reloadData];
    //     结束刷新状态
//    [_header endRefreshing];
    _footer.status=FooterRefreshStateNormal;
    
}
//- (void)goBack
//{
//    NSLog(@"goBack");
//}

#pragma 获取数据代理
- (void)CourseListJsonHandler:(CourseListJsonHandler *)handler withResult:(NSString *)result
{
//    NSLog(@"VideoListJsonhandler");
    NSArray *resultArr=[result JSONValue];
    // NSLog(@"result---%@",[result JSONValue]);
    //  NSLog(@"VideoListJsonhandler---");
    // NSLog(@"resultArr--%@",resultArr);
    if (!resultArr) {
        return;
    }
    //    if ([handler.ID isEqualToString:@"refresh"]) {
    //
    //        self.listData=[NSMutableArray arrayWithArray:[CoursesVideoObject initArrayWithJson:resultArr]];
    //        currentPageIndex=1;
    //        [self reloadTableView];
    //
    //    }
    if ([handler.ID isEqualToString:@"more"]) {
        // NSLog(@"more");
        NSArray *arr=[CoursesObject initArrayWithJson:resultArr];
        if (arr.count==0) {
            noMore=YES;
        }
        [self.listData addObjectsFromArray:arr];
        currentPageIndex++;
//        NSLog(@"currentPageIndex---%d",currentPageIndex);
        [self reloadTableView];
        
    }
//    if ([handler.ID isEqualToString:@"search"]) {
//        // NSLog(@"search");
//        NSArray *arr=[CoursesObject initArrayWithJson:resultArr];
//        if (arr.count==0) {
//            noMore=YES;
//        }
//        [self.searchListData removeAllObjects];
//        [self.searchListData addObjectsFromArray:arr];
//        // searchPageIndex++;
//        // NSLog(@"searchPageIndex---%d",searchPageIndex);
//        [self successLoadList];
//        [searchDisplay.searchResultsTableView reloadData];
//
//    }
    
    
}
#pragma footer refresh delegate

-(void)refreshFooterBegin:(RefreshFooterView *)view
{
//    NSLog(@"refreshFooterBegin");
    //    //查询
    //    if ([listHandler.ID isEqualToString:@"search"]){
    //        [listHandler searchListWithVideoName:_searchText searchPageIndex:searchPageIndex pageSize:searchPageSize];
    //        return ;
    //    }
    //
    // 刷新
    listHandler.ID=@"more";
    // Demo阶段先预设ClassID的值为22，正式用学生登录的ClassID
    
    [listHandler handlerCourseObject:cvo currentPageIndex:currentPageIndex pageSize:currentPageSize];
    // [self getlistDataFraomWeb];
    
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        if ([indexPath row]==self.listData.count) {
            return k_RefreshFooterViewHeight;
        }
    }
    
    return k_CourseListCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView==self.tableView)
        return self.listData.count+1;
//    else
//        return self.searchListData.count;
    return self.listData.count;
}
//启动刷新
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//        NSLog(@"[indexPath row]---%d",[indexPath row]);
//    NSLog(@"self.listData.count---%d",self.listData.count);
    if ([indexPath row]==self.listData.count)
    {
        //        NSLog(@"willDisplayCell2");
//        NSLog(@"self.listData.count--%d",self.listData.count);
        FooterRefreshState status;
        status=self.listData.count>10?FooterRefreshStateNormal:FooterRefreshStateRefreshing;
//        NSLog(@"noMore1---%hhd",noMore);
//        status =FooterRefreshStateRefreshing;
        if (noMore == YES) {
//            NSLog(@"noMore2---%hhd",noMore);
            status=FooterRefreshStateDiseable;
        }
//        status = FooterRefreshStateRefreshing;
        _footer.status=status;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tableView)
    {
        if ([indexPath row]==self.listData.count) {
            //底部刷新
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
            [_footer setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
            [cell.contentView addSubview:_footer];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    static NSString *cellIdentifier = @"Cell";
    
    CourseListViewCelL *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CourseListViewCelL alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        // 注意。。。不添加代理则无法使用代理方法
        cell.delegate = self;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subs_add.png"]];
    }
    
    CoursesObject *obj=nil;
    if (tableView==self.tableView)
    {
        obj=[self.listData objectAtIndex:indexPath.row];
    }
//    else
//    {
//        obj=[self.searchListData objectAtIndex:indexPath.row];
//    }
    //调用SetVideo方法
    cell.tag = indexPath.row;
    cell.courses=obj;
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"canEditRowAtIndexPath");
    //    if (tableView==self.tableView)
    //    {
    //        if ([indexPath row]==self.listData.count)
    //        {
    //            if(temp !=true)
    //            {
    //
    //            }
    //            return NO;
    //        }
    //    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row;
    CoursesObject *obj=nil;
    if (tableView==self.tableView) {
        obj=[self.listData objectAtIndex:index];
    }
//    else
//    {
//        obj=[self.searchListData objectAtIndex:index];
//    }
//    [[DBManager share] insertVideo:obj];
    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
}
#pragma mark --CourseListViewCell delegate
- (void)coursesListPptFocus:(int)index;
{
    CoursesObject *obj = [self.listData objectAtIndex:index];
    // 设置第一响应
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPPTHomeView:)]) {
        [self.delegate showPPTHomeView:obj];
    }
    
    
//    CoursePPTViewController *coursePPtVC = [[CoursePPTViewController alloc] init];
//    CoursesObject *obj = [self.listData objectAtIndex:index];
//    CoursePPTObject *pptObj =[[CoursePPTObject alloc] init];
//    pptObj.CourseID = obj.CourseID;
//    NSLog(@"obj---");
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(showAuthorHomeView:)]) {
//        [self.delegate showPPTHomeView:obj.CourseID];
//    }
//    CoursesObject *obj=[self.listData objectAtIndex:index];
    
//    [coursePPtVC setCoursePPtObj:pptObj];
//    UINavigationController *nav = [[UINavigationController alloc] init];
//    CoursePPTViewController *coursePptVC = [[CoursePPTViewController alloc] init];
//    [nav pushViewController:coursePPtVC animated:YES];
//    [self presentViewController:nav animated: YES completion:nil];

    
//    [[DBManager share] delVideo:[NSString stringWithFormat:@"%@",obj.VideoID]];
//    [self.listData removeObjectAtIndex:index];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)coursesListVideoFocus:(int)index
{
    CoursesObject *obj = [self.listData objectAtIndex:index];
    // 设置响应
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideoHomeView:)]) {
        [self.delegate showVideoHomeView:obj];
    }
    
}


@end
