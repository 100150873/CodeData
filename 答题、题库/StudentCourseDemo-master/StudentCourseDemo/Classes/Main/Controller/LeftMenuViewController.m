//
//  LeftMenuViewController.m
//  StudentCourseDemo
//
//  Created by lmj on 15/11/6.
//  Copyright (c) 2015年 lmj. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#define k_MenuItemHeight 54.0f
@interface LeftMenuViewController ()
{
    int currentSelectedIndex;
}
@property (nonatomic,strong) UITableView *menuTableView;
@end

@implementation LeftMenuViewController

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
    self.menuTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        tableView.delegate = self;
        tableView.dataSource = self;
        // UITableView设置背景颜色为clearColor，设置类型为Grouped。这里每个Group的四个角会有黑的 解决办法：
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 禁止拖动
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.menuTableView];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftMenuChangeSelected:)]) {
        [self.delegate leftMenuChangeSelected:indexPath.row];
    }
    [self.sideMenuViewController hideMenuViewController];
    currentSelectedIndex = indexPath.row;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
    [self.menuTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_MenuItemHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
        backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        cell.selectedBackgroundView = backView;
        
    }
    
    NSArray *titlesArr = @[@"在线学习",@"在线测评"];
    NSArray *imagesArr = @[@"IconHome.png",@"IconCat.png"];
    cell.textLabel.text = titlesArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imagesArr[indexPath.row]];
    return cell;
    
}

@end
