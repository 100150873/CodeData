//
//  CoursePPtShowViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/7.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "CoursePPtShowViewController.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "HttpConfig.h"
#define k_ToolBarHeight 44.0f

@interface CoursePPtShowViewController ()
{
    UIActivityIndicatorView *actView;
    UILabel *loadingLabel;
    UIView *loadingView;
    UIToolbar *toolBar;
    UIButton *favBtn;
    BOOL isFav;
    // 解决Web黑色
    BOOL isFirstLoad;
}
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CoursePPtShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstLoad = YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // webView
    float webViewHeight = self.view.bounds.size.height - k_ToolBarHeight;
    float webViewY = 0;
    if (![Common isIOS7]) {
        webViewHeight -= k_NavigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_detail_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, webViewY, self.view.bounds.size.width, webViewHeight)];
    if ([Common isIOS7]) {
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(20+k_NavigationBarHeigh, 0, 0, 0);
        self.webView.scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(20+k_NavigationBarHeigh, 0, 0, 0);
    }
    else
    {
        // remove shadow view when drag web view
        for (UIView *subView in [self.webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
    }

//    if (![Common isIOS7]) {
//        self.webView.scrollView.contentInset = UIEdgeInsetsMake(20 + k_NavigationBarHeigh, 0, 0, 0);
//        self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(20 + k_NavigationBarHeigh, 0, 0, 0);
//    } else{
//        for (UIView *subView in [self.webView subviews]) {
//            if ([subView isKindOfClass:[UIScrollView class]]) {
//                for (UIView *shadowView in [subView subviews]) {
//                    if ([shadowView isKindOfClass:[UIImageView class]]) {
//                        shadowView.hidden = YES;
//                    }
//                }
//            }
//        }
//    }
    
    [self.webView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    // 自动缩放页面以适应屏幕
    [self.webView setScalesPageToFit:NO];
    self.webView.delegate = self;
    
    // navBarBack
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // toolBar
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, webViewY, self.view.bounds.size.width, k_ToolBarHeight)];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    [self.view addSubview:toolBar];
    
    // 加载显示菊花
    loadingView = [[UIView alloc] initWithFrame:self.webView.frame];
    [loadingView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center = self.webView.center;
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.webView.bounds.size.width,30)];
    loadingLabel.center = CGPointMake(self.webView.center.x, self.webView.center.y + 30);
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [loadingLabel setFont:[UIFont systemFontOfSize:12]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:loadingLabel];
    [loadingView addSubview:actView];
}

-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CoursePPtShowViewControllerBack:)]) {
        [self.delegate CoursePPtShowViewControllerBack:self];
        
    }
}

- (void)reset
{
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView removeFromSuperview];
}

- (void)startLoading
{
    [self.view addSubview:self.webView];
    [self.view addSubview:loadingView];
    [actView startAnimating];
    [loadingLabel setText:@"正在加载..."];
    [self.view bringSubviewToFront:toolBar];
}

- (void)endLoading
{
    [actView stopAnimating];
    [loadingView removeFromSuperview];
}

- (void)setTabBarItems
{
    
}

- (void)setCoursePPtObj:(CoursePPTObject *)coursePPtObj
{
    [self startLoading];
    _coursePPtObj = coursePPtObj;
    self.title = _coursePPtObj.PPTName;
    [self setTabBarItems];
//    NSURL *url = [NSURL URLWithString:@"http://qxw1098930026.my3w.com/login.aspx"];

    NSURL *url = [NSURL URLWithString:k_InitUrl(_coursePPtObj.PPTPath)];
    NSLog(@"k_InitUrl---%@",k_InitUrl(_coursePPtObj.PPTPath));
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    if (!isFirstLoad) {
        [self endLoading];
    }
    
}
#pragma mark - 
#pragma mark scrollview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if ([[request.URL absoluteString] hasPrefix:@"http://"]) {
//        return NO;
//    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isFirstLoad) {
        [self endLoading];
        isFirstLoad=NO;
    }
}


@end
