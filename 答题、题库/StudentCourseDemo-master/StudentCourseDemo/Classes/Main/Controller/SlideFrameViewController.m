//
//  SlideFrameViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "SlideFrameViewController.h"
#import "Common.h"

@interface SlideFrameViewController ()
{
    // 框架数据
    UIViewController *currentVC;
    int currentIndex;
    UIViewController *_willShowCTR;
    float showTime;
    float autoShowDistance;
    
    // 业务数据
    RESideMenu *slideMenuVC;
    UINavigationController *containerNavVC;
    
    // 在线学习课程列表
    UINavigationController *studentCourseNavVC;
    StudentCoursesListViewController *studentCourseVC;
    //左上角导航菜单图标
    UIButton *showmenuBtn;
    
    // 在线课程ppt列表
    UINavigationController *coursePPtNavVC;
    CoursePPTViewController *coursePPtVC;
    
    // 在线课程展示ppt内容
    UINavigationController *coursePPtShowNavVC;
    CoursePPtShowViewController *coursePPtShowVC;
    
    // 在线课程视频列表
    UINavigationController *courseVideoNavVC;
    CourseVideoViewController *courseVideoVC;
    
    // 在线测试列表
    QuestionViewController *questVC;
    UINavigationController *questNavVC;
    
    IndexSlideViewController *onlineListVC;
    
}
@end

@implementation SlideFrameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    showTime = 0.5;
    autoShowDistance = 80;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizedBase:)];
    // 在线学习列表
    studentCourseVC = [[StudentCoursesListViewController alloc] init];
    studentCourseVC.delegate = self;
    containerNavVC = [[UINavigationController alloc] initWithRootViewController:studentCourseVC];
    
    LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] init];
    leftMenuVC.delegate = self;
    slideMenuVC = [[RESideMenu alloc] initWithContentViewController:containerNavVC menuViewController:leftMenuVC];
    slideMenuVC.backgroundImage = [UIImage imageNamed:@"menubg.png"];
    slideMenuVC.delegate = self;
    
    slideMenuVC.parallaxEnabled = NO;
    // 菜单错放
    slideMenuVC.menuViewScaleValue = 1.0f;
    slideMenuVC.menuViewAlphaChangeable = NO;
    // 菜单背景缩放
    slideMenuVC.scaleBackgroundImageView =NO;
    if ([Common IOSVersion] < 7.0) {
        slideMenuVC.scaleContentView = NO;
    }

    [self addChildViewController:slideMenuVC];
    [self.view addSubview:slideMenuVC.view];
    [self changeCurrentVC:slideMenuVC fromVC:nil];
    
    showmenuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [showmenuBtn setBackgroundImage:[UIImage imageNamed:@"top_navigation_menuicon.png"] forState:UIControlStateNormal];
    [showmenuBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    containerNavVC.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];
    
    // 课程PPT列表
    coursePPtVC = [[CoursePPTViewController alloc] init];
    coursePPtVC.delegate = self;
    coursePPtNavVC = [[UINavigationController alloc] initWithRootViewController:coursePPtVC];
    [self addChildViewController:coursePPtNavVC];
    
    // 内容PPT
    coursePPtShowVC = [[CoursePPtShowViewController alloc] init];
    coursePPtShowVC.delegate = self;
    coursePPtShowNavVC = [[UINavigationController alloc] initWithRootViewController:coursePPtShowVC];
    [self addChildViewController:coursePPtShowNavVC];
    
    // 在线课程视频列表
    courseVideoVC = [[CourseVideoViewController alloc] init];
    courseVideoVC.delegate = self;
    courseVideoNavVC = [[UINavigationController alloc] initWithRootViewController:courseVideoVC];
    [self addChildViewController:courseVideoNavVC];
    
    // 在线测试列表
    questVC =[ [QuestionViewController alloc] init];
    questVC.delegate = self;
    questNavVC = [[UINavigationController alloc] initWithRootViewController:questVC];
    [self addChildViewController:questNavVC];
    
    // 在线测评菜单栏列表
    // 分类列表
    onlineListVC = [[IndexSlideViewController alloc] initWithIsIndex:NO];
    onlineListVC.delegate = self;
    [self addChildViewController:onlineListVC];
    
}

- (void)showLeftMenu
{
    [slideMenuVC presentMenuViewController];
}


#pragma mark -
#pragma mark leftMenu selected delegate
-(void)leftMenuChangeSelected:(int)index
{
    switch (index) {
        case 0:
            containerNavVC.viewControllers = [NSArray arrayWithObjects:studentCourseVC, nil];
            break;
        case 1:
            containerNavVC.viewControllers = [NSArray arrayWithObjects:onlineListVC, nil];
        default:
            break;
    }
    containerNavVC.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showmenuBtn];
}

#pragma QuestionListViewControllerDelegate
//从普通列表页到内容页
-(void)QuestionlistViewContoller:(QuestionListViewController *)listVCT selectedPostObject:(ProblemPaperObject *)proObj;
{
    
    [questVC setProObj:proObj];
    //[commVC setPostObj:postObj];
    [questNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewController:questNavVC
               fromViewController:currentVC
                         duration:showTime
                        showRight:YES];
    
}


#pragma mark StudentCoursesListViewControllerDelegate
// 从StudentCoursesListView在线学习列表到CoursePPTViewController课程PPT列表
- (void)showPPTHomeView:(CoursesObject *)obj
{
    // 先设置CoursePPT setCoursePPT方法传入CourseID
    [coursePPtVC setCoursesObj:obj];
    [self switchShowViewController:coursePPtNavVC fromViewController:currentVC duration:showTime showRight:YES];
}

// 从StudentCoursesListView在线学习列表到CoursesVideoViewController课程PPT列表
- (void)showVideoHomeView:(CoursesObject *)obj
{
    // 先设置CoursePPT setCoursePPT方法传入CourseID
    [courseVideoVC setCourseObj:obj];
//    [courseVideoVC setCourseVideoObj:obj];
    [self switchShowViewController:courseVideoNavVC fromViewController:currentVC duration:showTime showRight:YES];
}
#pragma mark CoursePPTViewControllerDelegate 
//从ppt列表返回到在线学习课程列表
- (void)coursePPtGoBack
{
    [self switchShowViewController:coursePPtVC.leftVC fromViewController:currentVC duration:showTime showRight:NO];
}

#pragma mark CoursePPTViewControllerDelegate
// 从ppt列表到ppt内容页
- (void)coursePPtHome:(CoursePPTViewController *)courseHome selectedPPtObj:(CoursePPTObject *)coursePPtObj
{
    [coursePPtShowVC setCoursePPtObj:coursePPtObj];
    [coursePPtShowNavVC.view setFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self switchShowViewController:coursePPtShowNavVC fromViewController:currentVC duration:showTime showRight:YES];
}

#pragma mark CoursePPtShowViewControllerDelegate
// 从ppt内容页返回到ppt列表
- (void)CoursePPtShowViewControllerBack:(CoursePPtShowViewController *)CoursesPPtShowVC;
{
    [self switchShowViewController:coursePPtShowVC.leftVC fromViewController:currentVC duration:showTime showRight:NO];
}

#pragma mark CourseVideoListControllerDelegate
// 从视频列表返回到在线学习课程列表
- (void)courseVideoGoBack
{
    [self switchShowViewController:courseVideoVC.leftVC fromViewController:currentVC duration:showTime showRight:NO];
}

#pragma mark QuestionViewControllerDelegate
- (void)questionViewControllerBack:(QuestionViewController *)quesVC {
    [self switchShowViewController:quesVC.leftVC fromViewController:currentVC duration:showTime showRight:NO];
}

#pragma mark -
#pragma mark 框架方法
- (void)addPanGesture
{
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)removePanGesture
{
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
}


- (void)changeCurrentVC:(UIViewController *)vc fromVC:(UIViewController *)fromVC
{
    [self.view bringSubviewToFront:fromVC.view];
    if ([vc respondsToSelector:@selector(leftVC)] || [vc respondsToSelector:@selector(rightVC)]) {
        [self addPanGesture];
    } else{
        [self removePanGesture];
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UIViewController *child = [(UINavigationController *)vc topViewController];
        if ([child respondsToSelector:@selector(leftVC)] || [child respondsToSelector:@selector(rightVC)]) {
            [self addPanGesture];
        } else{
            [self removePanGesture];
        }
    }
    currentVC = vc;
    currentIndex = [self.childViewControllers indexOfObject:currentVC];
    
    if (fromVC == coursePPtShowNavVC) {
        if (vc == slideMenuVC || (vc == coursePPtNavVC)) {
            // 返回后，重置url
            [coursePPtShowVC reset];
            
//            [courseV]
        }
    }
    
    if (vc==slideMenuVC) {
        [coursePPtVC reset];
        [courseVideoVC reset];
//        [authorHomeVC reset];
//        [postVC reset];
//        [commVC reset];
    }
    
}

- (void)switchShowViewController:(UIViewController *)toVC fromViewController:(UIViewController *)fromVC duration:(NSTimeInterval)duration showRight:(BOOL)showRight
{
    toVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    toVC.view.layer.shadowOpacity = 0.7;
    CGFloat rectWidth = 5.0;
    CGFloat rectHeight = toVC.view.frame.size.height;
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    CGPathMoveToPoint(shadowPath,NULL, 0.0, 0.0);
    CGPathAddRect(shadowPath, NULL, CGRectMake(0.0 - rectWidth, 0.0, rectWidth, rectHeight));
    CGPathAddRect(shadowPath, NULL, CGRectMake(toVC.view.frame.size.width, 0.0, rectWidth, rectHeight));
    toVC.view.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    if (duration == showTime) {
        // 根据动画时间确定是否非手势
        toVC.view.center = CGPointMake(self.view.frame.size.width * (showRight? 1.5 : -1), fromVC.view.center.y);
    }
    [self transitionFromViewController:fromVC
                      toViewController:toVC
                              duration:duration
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                fromVC.view.center=CGPointMake(self.view.center.x*(showRight?-1:1.5), fromVC.view.center.y);
                                toVC.view.center=CGPointMake(self.view.center.x, toVC.view.center.y);
                                
                            } completion:^(BOOL finished) {
                                toVC.view.layer.shadowColor=[UIColor clearColor].CGColor;
                                toVC.view.layer.shadowOpacity = 0.0;
                                toVC.view.layer.shadowPath=NULL;
                                [self changeCurrentVC:toVC fromVC:fromVC];
                            }];
    if (showRight) {
        BaseViewController *currentBaseVC = nil;
        if ([toVC isKindOfClass:[UINavigationController class]]) {
            currentBaseVC = (BaseViewController *)[(UINavigationController *)toVC topViewController];
        } else{
            currentBaseVC = (BaseViewController *)toVC;
        }
        currentBaseVC.leftVC = fromVC;
    }
    
}

#pragma mark Gesture recognizer
- (void)panGestureRecognizedBase:(UIPanGestureRecognizer *)recognizer
{
    BOOL showRight = NO;
    BaseViewController *currentBaseVC = (BaseViewController *)currentVC;
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentBaseVC = (BaseViewController *)[(UINavigationController *)currentVC topViewController];
    }
    CGPoint point = [recognizer velocityInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {

    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.view.center.x + point.x * 0.01 > self.view.bounds.size.width * 0.5) {
            // 向右滑动准备显示左边VC
            if (_willShowCTR) {
                if (_willShowCTR != currentBaseVC.leftVC && currentVC.view.frame.origin.x > 0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR = nil;
                } else{
                    _willShowCTR = currentBaseVC.leftVC;
                }
                if (_willShowCTR.view.superview != self.view) {
                    [_willShowCTR.view setFrame:CGRectMake(- self.view.frame.size.width * 0.5, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    [self.view sendSubviewToBack:_willShowCTR.view];
                    currentVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
                    currentVC.view.layer.shadowRadius = 5.0;
                    currentVC.view.layer.shadowOpacity = 0.7;
                }
            }
        }
        
        if (self.view.center.x + point.x * 0.01 < self.view.bounds.size.width * 0.5) {
            // 向左滑动准备显示右边的VC
            if (_willShowCTR) {
                if (_willShowCTR != currentBaseVC.rightVC && currentVC.view.frame.origin.x  < 0) {
                    [_willShowCTR.view removeFromSuperview];
                    _willShowCTR = nil;
                } else{
                    _willShowCTR = currentBaseVC.rightVC;
                }
            }
            if (_willShowCTR.view.superview != self.view) {
                [_willShowCTR.view setFrame:CGRectMake(self.view.frame.size.width*0.5, 0, self.view.frame.size.width,self.view.frame.size.height)];
                [self.view addSubview:_willShowCTR.view];
                [self.view sendSubviewToBack:_willShowCTR.view];
                currentVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
                currentVC.view.layer.shadowRadius = 5.0;
                currentVC.view.layer.shadowOpacity = 0.7;
            }
        }
        if (_willShowCTR) {
            [_willShowCTR.view setFrame:CGRectMake(_willShowCTR.view.frame.origin.x + point.x *0.01, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [currentVC.view setFrame:CGRectMake(currentVC.view.frame.origin.x + point.x * 0.01 * 2, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_willShowCTR) {
            float distance = currentVC.view.center.x - currentVC.view.bounds.size.width * 0.5;
            NSTimeInterval time = showTime * fabsf(distance)/ self.view.bounds.size.width;
            if (fabsf(distance) > autoShowDistance) {
                showRight = distance > 0 ? NO : YES;
                [self switchShowViewController:_willShowCTR fromViewController:currentVC duration:time showRight:showRight];
            } else{
                showRight = distance > 0 ? YES : NO;
                [self switchShowViewController:currentVC fromViewController:_willShowCTR duration:time showRight:showRight];
            }
            _willShowCTR = nil;
            
        }
    }
}

@end
