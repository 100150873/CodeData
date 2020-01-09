//
//  ExamVC.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/24.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "ExamVC.h"
#import "operationCell.h"

@interface ExamVC ()

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation ExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"考试大纲";
    self.titleArray = @[@"一、考试目的",@"二、考试内容",@"三、考试说明"];
    
    NSArray *array = @[@"考核考生计算机应用的基本能力，包括对信息技术，计算机硬件、软件、网络、多媒体、数据库基本知识的掌握程度及在Windows 7操作系统环境下管理计算机资源、正确理解与使用网络资源、在学习工作中运用Office 2010办公软件与Access数据库管理系统的基本能力。"];
    NSArray *array1 = @[@"（一）信息与计算机",@"1．信息、信息技术、信息科学的发展和主要研究领域；",@"2．信息化社会和信息素养的主要特性，计算科学与计算思维概念；",@"3．计算机的发展、特点及人工智能等应用；",@"4．计算机中信息的存储方式及编码表示： ",@"⑴二、八、十、十六进制数，位(bit)、字节（B），算术、逻辑运算规则；",@"⑵存储单位KB，MB，GB，TB及字、字长含义；",@"⑶BCD码、ASCII码、汉字编码方法；",@"⑶BCD码、ASCII码、汉字编码方法；",@"5．微机系统的基本组成：",@"⑴PC微机系统及硬件逻辑结构；",@"⑵微机软件系统的作用及其分类；",@"⑶硬件、软件、用户间的关系；",@"6．微机的CPU、主板、内存、总线嵌入式系统及其组成；",@"7．微机的外存储设备：硬盘、U盘、闪存、移动硬盘、云存储等；",@"8．微机的I/O设备与接口：显示器和显示适配卡、键盘、鼠标、打印机、声卡、扫描仪及手机、iPad、数码相机等常用外部设备；",@"（二）Windows操作系统",@"1.操作系统的作用、功能、分类，当前常用的Windows、Unix、Linux、Mac OX、嵌入式、智能终端操作系统等特点；",@"2. Windows 7的特点、桌面组成、启动和退出方式、Windows 7帮助信息的获取，鼠标器、图标、窗口、菜单、对话框的组成和操作",@"3.文件、文件夹，文件类型、文件夹/文件名命名规则，通配符 ？ *的使用；",@"4.主题、桌面背景、屏幕保护程序、显示属性等外观和修改化设置、桌面的“网络”设置、任务栏的相关操作，中文输入法的选择与使用；",@"5.使用桌面“计算机”查看与管理计算机资源的操作方法；",@"6.库/文件/文件夹选中、查看方式、新建、移动、复制、删除、重命名、设置属性、查找、创建快捷方式，设置“工具”菜单中的“文件夹选项”的“查看”选项；",@"7.“回收站”“剪贴板”“任务管理器”的应用；",@"8. 控制面板的“用户管理”、“添加/删除程序”、“打印机”的使用,提高Windows 7系统启动速度、虚拟内存设置，磁盘的查看和格式化、磁盘备份、磁盘碎片整理的应用；",@"9.媒体播放机（Windows Media Player）、记事本、计算器、写字板、画图、压缩软件等的应用；",@"10.信息共享与交换方式，信息的静态移动/复制、对象嵌入、对象链接的实现。",@"（三）办公自动化软件应用",@"1．Office 2010办公类软件的启动与退出、工作窗口的基本组成、文件的建立、打开与保存、文本编辑区通用编辑方法；",@"2．Word 2010的各种视图、Word 2010文档的编辑、查找和替换，文档格式的设置（包括字符格式、段落格式）和页面格式的设置（包括节的设置、分页、分栏和插入页眉和页脚），样式的使用；",@"3．Word 2010表格的创建与编辑，插入图片、文本框、艺术字、绘图及图文混排的方法；",@"4． Excel 2010工作簿、工作表、单元格、单元格区域、名称的概念与意义；",@"5．电子表格的建立、编辑及格式化操作，公式、函数（包括SUM、AVERAGE、If、MAX、MIN、COUNT等常用函数）的使用与操作，名称的使用，相对引用、绝对引用和混合引用的使用方法；",@"6．电子表格的数据清单，掌握使用记录单向数据清单输入数据和编辑数据的方法，通过数据清单对数据进行排序、筛选（包括自动筛选、自定义筛选）、分类汇总及数据透视表的操作；",@"7．图表的类型、创建与编辑的操作方法。",@"8．PowerPoint 2010各种视图的意义与应用，创建与编辑电子演示文稿的操作方法；",@"9．掌握在幻灯片中插入多媒体对象（图片、艺术字、声音、影片、表格和图表等）的操作方法；",@"10．幻灯片母版、设计模板的应用，选用标准配色方案、创建自定义配色方案、幻灯片背景设置；",@"11．超级链接的创建与编辑，幻灯片放映设置（包括设置动画、自动播放，手动播放，自定义放映）；",@"12．Office 2010集成应用（导出、导入、嵌入和链接）。",@"（四）多媒体应用技术基础",@"1．多媒体、多媒体技术概念、主要特征，媒体元素、分类及其特点；",@"2．多媒体的关键技术和主要应用领域[包括MOOC(慕课)、VR等应用]；",@"3．多媒体计算机系统的组成结构，声卡、视频卡的主要功能；",@"4．扫描仪的基本常识；",@"5．常见多媒体素材制作软件、多媒体创作软件、多媒体应用系统制作的了解。",@"6．音频、图像、视频的数字化概念及处理技术，多媒体数据压缩方法，各种媒体素材的获取方法，各种媒体素材最常见的文件格式及其格式转换。",@"7．与图像相关的分辨率（显示器分辨率、屏幕分辨率和图像分辨率）的概念，图形与图像的区别，视频与动画的区别，音频与图像存储容量的计算，简单动画制作与处理知识。",@"（五）计算机网络基础",@"1．计算机网络的定义、组成和功能，网络的产生与发展、分类；",@"2．模拟通信和数据通信的基本概念、调制解调器的功能；",@"3．多路复用和数据交换技术、传输介质的特点；",@"4．网络协议的定义和三个要素，网络协议的分层模型、OSI参考模型以及各层的功能，网络互连技术和网络互连设备；",@"5．局域网的特点和组成、拓扑结构、局域网类型、网络设备、网络操作系统；",@"6．Internet的发展和特点、TCP/IP协议、域名系统、统一资源定位符；",@"7．IP地址的格式、类型、子网掩码、Internet接入方式、局域网连接Internet的基本设置、在Windows中安装配置TCP/IP协议；",@"8．WWW服务和电子邮件服务的基础原理，使用IE浏览器访问网页，使用搜索引擎检索资料；",@"9．信息安全的基本概念，网络安全基本要素、网络安全威胁以及隐患的防范及处理措施，计算机病毒及防治。",@"10．数字加密、数字签名、数字证书和防火墙技术等基本概念及应用。",@"11.网络技术（无线网络技术、云计算、大数据、互联网+、物联网、移动互联网等）基本常识。",@"（六）数据库技术及应用基础",@"1．	数据处理、数据库、数据库管理系统和数据库系统的概念；",@"2．	数据库的特点、数据库管理系统的功能和数据库系统的组成，数据库技术发展的三个阶段、数据库技术的发展方向，数据库应用开发平台；",@"3．	现实世界、信息世界和机器世界的关系，数据模型的两个层次，信息世界的实体、属性、联系概念，E-R模型表示方法；",@"4．	层次模型、网状模型，关系模型的关系、元组、属性、域、关键字、主键、外键等概念，关系模型的特点及关系的三种基本运算（选择、投影、连接）；",@"5．	数据库设计（包括概念结构的设计和逻辑结构的设计）和数据库实施的基本方法；",@"6．	Access 2010数据库的创建、打开和关闭，表、查询对象；",@"7．	Access表的设计与操作：",@"⑴利用表向导、设计视图创建表，建立多表间关系；",@"⑵表记录数据的输入、修改及删除；",@"⑶修改表结构（包括字段名、数据类型、各种属性的设置、设置主键等）；",@"⑷设定和修改多表之间的关系；",@"8．使用SOL语句对表记录进行插入、修改与删除；",@"9．使用SOL语句进行表（包括多个表之间）记录选择查询（简单查询、条件查询和自然连接查询）、常用数据统计（COUNT、SUM、AVG、MAX、MIN）、记录更新（UPDATE）等操作。"];
    
    NSArray *array2 = @[@"（一）考试形式",@"考试采用无纸化方式。",@"考试环境：Windows 7简体中文版、Office 2010简体中文版",@"考试时间：90分钟。",@"（二）试卷题型结构",@"1.选择题（25小题）                          25%",@"2.文字录入题（5分钟输入约120个汉字）       5%",@"3.基本操作题（8小题）                       25%",@"4.Office操作题                              45%",@"操作考试内容有：Windows 7操作系统、多媒体应用、网络应用、Word 2010、PowerPoint 2010、Excel 2010、Access 2010。其中Excel 2010与Access 2010操作部分只考其中一种，由考生考试时自选。"];
    self.dataArray = @[array,array1,array2];
    [self.view addSubview:self.tableView];
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[operationCell class] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        
    }
    return _tableView;
}

#pragma mark -- UITabelViewDelegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataArray[indexPath.section];

    operationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell fillWithTitle:self.dataArray[indexPath.row] index:0];
    [cell fillWithContent:array[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];

    NSString *content = array[indexPath.row];
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 15 title:content font:SYSTEMFONT(14)];
    
    
    return height+10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel createLabelWithFrame:CommonVIEWFRAME(0, 0, 0, 0)
                                            andText:self.titleArray[section]
                                       andTextColor:[UIColor blackColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(18)
                                   andTextAlignment:NSTextAlignmentCenter];

    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(0);
        make.right.equalTo(view.mas_right).offset(0);
        make.top.equalTo(view.mas_top).offset(0);
        make.bottom.equalTo(view.mas_bottom).offset(0);
    }];
    
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = @{@"type":@(indexPath.row)};
    [self PushViewControllerByClassName:@"Subjects" info:dic];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
