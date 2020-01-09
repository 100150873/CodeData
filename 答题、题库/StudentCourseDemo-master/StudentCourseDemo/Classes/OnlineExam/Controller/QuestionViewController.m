//
//  QuestionViewController.m
//  QuestionDemo
//
//  Created by lmj on 15-10-5.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "QuestionViewController.h"
#import "AFNetworking.h"

#import "SVProgressHUD.h"

#import "ProblemPaperObject.h"
#import "Config.h"



#import "ProblemPaperObject.h"
#import "ProblemsLibObject.h"
#import "Common.h"
#import "HttpConfig.h"

@interface QuestionViewController ()
{
    UIActivityIndicatorView *actView;
    UILabel *loadingLabel;

    //完成按钮
    UIButton *commentBtn;
    UIView *loadingView;
    UIToolbar *toolBar;
    UIButton *favBtn;
    BOOL isFav;
    BOOL isFirstLoad;//解决web黑色
    UISlider* Slide;
    
    
    
}

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation QuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstLoad=YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    //webview
    float webViewHeith= self.view.bounds.size.height-k_ToolBarHeight;
    float webViewY=0;
    if (![Common isIOS7]) {
        webViewHeith-=k_NavigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_detail_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //这行代码挡住了Slide,slide控件放在它addsub出现之后即可
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,webViewY,self.view.bounds.size.width,webViewHeith)];
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
    
    
    // 伸缩内容至适应屏幕尺寸
    self.webView.scalesPageToFit = YES;
    [self.webView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    self.webView.delegate=self;
    
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
    //
    commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnBg=[UIImage imageNamed:@"comment_icon.png"];
    btnBg=[btnBg stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [commentBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    self.navigationItem.rightBarButtonItem=right;
    
    
    //toolbar
    toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, webViewHeith, self.view.bounds.size.width, k_ToolBarHeight)];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    [self.view addSubview:toolBar];
    
    
    
    
    //加载显示 这行代码会导入Url显示不出来,已解决，可以使用
    loadingView=[[UIView alloc] initWithFrame:self.webView.frame];
    [loadingView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center=self.webView.center;
    loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.webView.bounds.size.width, 30)];
    loadingLabel.center=CGPointMake(self.webView.center.x, self.webView.center.y+30);
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [loadingLabel setFont:[UIFont systemFontOfSize:12]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:actView];
    [loadingView addSubview:loadingLabel];
    [self vSlide];
    // NSLog(@"videDid--slide");

}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(questionViewControllerBack:)]) {
        [self.delegate questionViewControllerBack:self];
        
    }
}
-(void)showComment
{
    
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"paperSubmit(<%=lbproblemCount.Text%>)"];
    //  [self.webView stringByEvaluatingJavaScriptFromString:@"ClickbtOk();"];
    NSString *js_result=[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('lbproblemCount2')[0].value;"];
    //NSLog(@"js_result%@",js_result);
    NSString *problemCount=@"paperSubmit";
    
    
    problemCount = [problemCount stringByAppendingFormat:@"(%@);",js_result];
    //NSLog(@"problemCount%@",problemCount);
    
    [self.webView stringByEvaluatingJavaScriptFromString:problemCount];
    //    if (self.delegate&&[self.delegate respondsToSelector:@selector(postShowViewControllerComment:)]) {
    //        [self.delegate postShowViewControllerComment:self];
    //
    //    }

}
-(void)reset
{
    self.isFromAuthorHome=NO;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView removeFromSuperview];
    
}
-(void)startLoading
{
    
    [self.view addSubview:self.webView];
    [self.view addSubview:loadingView];
    [actView startAnimating];
    [loadingLabel setText:@"正在加载..."];
    [self.view bringSubviewToFront:toolBar];

}
-(void)endLoading
{
    
    [actView stopAnimating];
    [loadingView removeFromSuperview];
    
    
}
-(void)setComment
{
    
    NSString *comment=[NSString stringWithFormat:@"完成"];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    CGSize size=[comment sizeWithFont:[UIFont systemFontOfSize:12]];
    [commentBtn setFrame:CGRectMake(commentBtn.frame.origin.x, commentBtn.frame.origin.y, size.width+20, 44)];
    [commentBtn setTitle:comment forState:UIControlStateNormal];
    
    
}
-(void)setTabBarItems
{
    //是否已收藏 右1
//    isFav=[[DBManager share] postIsInFavorites:[self.postObj.PpID stringValue]];
    NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
    favBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(handleFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favItem=[[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
    
    //分享
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sharePost) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    //顶部
    UIButton *topBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [topBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(handletop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *topItem=[[UIBarButtonItem alloc] initWithCustomView:topBtn];
    
    //底部
    UIButton *bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"go-bottom.png"] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(handlebottom) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bottonItem=[[UIBarButtonItem alloc] initWithCustomView:bottomBtn];
    
    
    
    //blank
    UIBarButtonItem *blank=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:shareItem,topItem,blank,bottonItem,favItem, nil]];
}
//分享
-(void)sharePost
{
    
}

-(void)handletop
{
    
    if ([self.webView subviews]) {
        UIScrollView* scrollView = [[self.webView subviews] objectAtIndex:0];
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    
}
//底部
-(void)handlebottom
{
    NSInteger height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %d);", height];
    [self.webView stringByEvaluatingJavaScriptFromString:javascript];
    
}
-(void)handleFav
{
    
}

- (void)setProObj:(ProblemPaperObject *)proObj
{
    
    [self startLoading];
    _proObj=proObj;
    NSLog(@"_proObj.CategoryURL---!%@",_proObj.CategoryURL);
    //完成按钮
    [self setComment];
    [self setTabBarItems];
    NSURL *url = [NSURL URLWithString:k_InitCategoryURL(_proObj.CategoryURL)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    if (!isFirstLoad) {
        [self endLoading];
    }
}

/**
 *  Slide
 */
- (void)vSlide{
    
    Slide = [[UISlider alloc] initWithFrame:CGRectMake(0, 50, 1000, 20)];
    [Slide addTarget:self action:@selector(SlideChange) forControlEvents:UIControlEventValueChanged];
    Slide.maximumValue = 1000.0f;
    Slide.minimumValue =250.0f;
    Slide.value = 10.0f;
    [self.view addSubview:Slide];
    // NSLog(@"vSlide--slide");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma scrollview delegate
//这个方法控制Url是否有Http://前缀如果有的话不能显示这个url
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
    //获得当前网页的标题
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

-(void)SlideChange
{
    // Slide.value = 250.0f;
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",Slide.value];
    [_webView stringByEvaluatingJavaScriptFromString:str1];
    
}



@end
