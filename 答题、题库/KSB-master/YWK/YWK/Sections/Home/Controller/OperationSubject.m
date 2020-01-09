//
//  OperationSubject.m
//  YWK
//
//  Created by 杨伟康 on 2017/5/23.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "OperationSubject.h"
#import "operationCell.h"

@interface OperationSubject ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation OperationSubject
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"操作题";
    

    NSNumber *type = self.myDict[@"type"];
    NSInteger i = [type integerValue];
    switch (i) {
        case 0:{
                self.dataArray = @[@"操作题题目:",@"打开考生文件夹，通过“组织”“文件夹与搜索选项”菜单打开“文件夹选项”框，在其“查看”页上去除“隐藏已知文件类型扩展名”的勾选。再完成下列操作：",@"1) 在考生文件夹中新建一个名为MyFile.docx的Word文件，在其中任意插入一个表格。",@"2) 将考生文件夹的Fruit.dat文件压缩为Preserve.zip",@"3) 用“附件”中的“画图”软件打开考生文件夹下的Sunflower.bmp文件，将其另存为PNG文件Sunflower.png。",@"4) 用Windows Media Player软件打开并播放考生文件夹中的Start.wav音频文件。",@"5) 通过“个性化”或者“控制面板”更改桌面背景，图片选Fjexam95\\popo.bmp，位置设置为平铺方式。",@"6) 搜索Fjnewdat文件夹，查找文件名主名末尾是end，扩展名任意的文件，将其拷贝到考生文件夹下的Friend文件夹中。",@"7) 将考生文件下Document文件夹中的Mfiles.dat文件属性设置为只读文件。",@"8) 将考生文件夹下的Garbage文件夹中的Nothing子文件夹删除",@"解析：",@"1)新建文件",@"单击鼠标右键，弹出快捷菜单，选择【新建】|【Microsoft  Word 文档】命令，即可生成新的Word文件，此时Word文件的名字处呈现蓝色可编辑状态。编辑名称为题目指定的名称MyFile，打开MyFile.docx，点击【插入】选项卡|【表格】，最后点击【保存】。",@"2)压缩文件",@"选定文件Fruit.da，点击鼠标右键，点击【添加到压缩文件(A)…】，弹出“压缩文件名和参数”窗口，选择压缩文件格式为ZIP(Z)，压缩文件名更改为Preserve.zip，最后点击【确定】。",@"3)用画图软件转换图片格式",@"选定文件Sunflower.bmp，点击鼠标右键，选择【打开方式(H)】|【画图】，点击【另存为(A)】|【PNG图片(P)】,最后点击【保存】",@"4)使用Windows Media Player",@"选定音频文件Start.wav，点击鼠标右键，选择【打开方式(H)】|【Windows Media Player】，关闭。",@"5)设置桌面背景",@"在电脑桌面，点击鼠标右键，点击【个性化】|【桌面背景】，点击【浏览(B)…】，弹出浏览文件夹窗口，选取Fjexam95，点击【全部清除】，勾选图片popo.bmp，设置为平铺方式。",@"6)使用通配符搜索文件",@"打开Fjnewdat文件夹，在搜索窗口输入*end.*，将搜索到的文件右击鼠标，点击【复制】，打开考生文件夹下的Friend文件夹，点击鼠标右键，点击【粘贴】。",@"7)设置文件属性",@"打开考生文件下Document文件夹，点击鼠标右键，点击【属性】，勾选【只读】。",@"打开考生文件下Document文件夹，点击鼠标右键，点击【属性】，勾选【只读】。",@"8)删除文件",@"打开考生文件夹下的Garbage文件夹，选定子文件Nothing，点击鼠标右键，点击【删除】，弹出删除文件对话框，点击【是】。"];
        }break;
        case 1:{
            self.dataArray = @[@"题目:",@"在word 2010中打开考生文件夹下的文档wd.docx，完成如下操作：",@"1)	通过页面布局进行页面设置，使纸张大小为16开，页边距的上、下、左、右边距均为2.5厘米；",@"2)	修改标题1的样式为：黑体、一号字、居中、红色（自定义RGB（255，0，0）），并应用于文档的标题（第1行）；",@"3)	将正文（除第1行标题外）各段设置为首行缩进2字符，行距为2.5倍，段前、段后间距各为0.3行；",@"4)	将正文第2段和第3段（北京时间……举办权。）分成等宽的2栏、栏间距3字符、栏间加分隔线；",@"5)	在文尾插入分页符，在第二页插入Fjexam95\\wd.jpg图像文件，尺寸大小为原来的150%，文字环绕为“上下型”，位置相对于页面水平居中；",@"6)	在文末（即图片下方）插入线性1磅的红色（自定义RGB（255，0，0））水平实线；",@"7)	在奇数页页眉输入内容“里约热内卢奥运会”，偶数页页眉输入内容“里约2016”",@"8)	完成后直接保存，并关闭Word 2010。",@"解析：",@"1)	在【页面布局】功能区的【页面设置】分组中，单击“纸张大小”下拉列表，选择“16开(18.426厘米)”选项；单击“页边距”|“自定义边距”，设置上、下、左、右边距均为2.5厘米。",@"2)	在【开始】功能区的【样式】分组中，右键点击“标题1”|“修改”，设置字体黑体，字号一号，对齐方式居中；在【格式】|【字体】里设置红色字体；选中第一行，单击“标题1”样式。",@"3)	选取正文内容，在【开始】功能区的【段落】分组中，单击右侧的下三角对话框启动器按钮，弹出“段落”对话框，单击“缩进和间距”选项卡，在“特殊格式”中选择“首行缩进”，在“磅值”中选择“2字符”，在“段前段后间距”中输入0.3行，“行距”选择“多倍行距”，“设置值”输入2.5。",@"4)	选中正文第2段和第3段，在【页面布局】功能区的【页面设置】分组中，单击“分栏”下拉列表|“更多分栏”，在“分栏”对话框，设置等宽2栏、栏间距3字符、勾选分隔线。",@"5)	鼠标点击文章 末尾，在【页面布局】功能区的【页面设置】分组中，单击【分隔符】|【分页符】；第二页，在【插入】功能区的【插图】分组中，单击【图片】，选择Fjexam95\\wd.jpg图像文件；选中图片点击鼠标右键，单击“大小和位置”，在“布局”窗口，设置尺寸大小为原来的150%，文字环绕为“上下型”，位置水平居中。",@"6)	在【插入】功能区的【插图】分组中，单击【形状】|【直线】，按住鼠标左键，在图像底下画出一条直线，右击线条，在【设置形状格式】对话框里，设置“线性宽度”1磅、线条颜色红色。",@"7)	在【插入】功能区的【页眉和页脚】分组中，单击【编辑页脚】，在【格式】中勾选“奇偶页不同”，在第一张页眉输入“里约热内卢奥运会”，在第二张页眉输入“里约2016”。",@"8)	单击【保存】。"];
        }break;

        case 2:{
            self.dataArray = @[@"Ppt演示文稿题目",@"在PowerPoint 2010中打开考生文件夹下的演示文稿Pt.pptx，完成如下操作：",@"1)	在第1张幻灯片标题的进入动画设置为“飞入”，效果选项为“自左侧”，持续时间为1.5秒；",@"2)	将所有幻灯片的主题设置为龙腾四海，背景样式为样式10；",@"3)	在版式为“标题和内容”的幻灯片母版中插入幻灯片编号，并在左下角添加一个“直角双向箭头”按钮，使放映时点击该按钮链接到幻灯片的首页；",@"4)	完成后直接保存，并关闭PowerPoint 2010。",@"解析：",@"打开演示文稿Pt.pptx",@"1)	选中第一幻灯片，单击标题区，切换到【动画】选项卡，选中【飞入】；单击【效果选项】，选择【自左侧】；持续时间改为1.5秒。",@"2)	单击【设计】选项卡，在【主题】功能窗口选择“龙腾四海”；单击【背景样式】，选择【样式10】。",@"3)	单击【视图】选项卡，单击【幻灯片母版】，选中版式为“标题和内容”的幻灯片母版；单击【插入】选项卡|【幻灯片编号】，勾选“幻灯片编号(N)”；单击【插入】|【形状】|【箭头总汇】，选中“直角双向箭头”，于幻灯片母版左下角，按住鼠标左键汇出图形，单击鼠标右键，点选“超链接(H)”|【本文档中的位置】|第一张幻灯片。",@"4)	单击【保存】"];
        }break;

        case 3:{
            self.dataArray = @[@"题目:",@"在Excel 2010 中打开考生文件夹下的Ex.xlsx工作簿，“成绩”工作表存放某门课程的成绩数据，要求完成如下操作：",@"1)	在“成绩”工作表的“期末成绩”与“排名”列之间插入“最终成绩”列，并计算每个学生的最终成绩，公式为：最终成绩=期中成绩30%+期末成绩70%，保留0位小数；",@"2)	利用RANK函数按“最终成绩”从大到小排名，放置于F2:F10单元格区域；",@"3)	将（A1:B10，E1：E10）单元格区域数据复制到新表中，将新表改名为“统计”，并在“统计”工作表（A1:C10）所构成的数据清单中，先按系部降序排列，再使用分类汇总功能求各个系部的“最终成绩”的平均值，汇总结果显示在数据下方，并将“系部”列设置为“自动调整列宽”；",@"4)	在“统计”工作表中，将计算机系学生的“最终成绩”数据绘制成“三维簇状柱形图”，在图表设计中修改图表布局为“布局5”，图表标题修改为“计算机系成绩图表”，图表坐标轴标题修改为“百分制成绩”，产生的图表放置在该表（A16:E30）单元格区域中；",@"5)	将“成绩”工作表单元格区域（A1:F10）设置双线外边框，单实线内边框；",@"6)	完成后直接保存工作簿，并关闭Excel 2010。",@"解析：",@"1)	选中“排名”列，右击“插入”，在列名位置输入“最终成绩”；在E2单元格输入“=C2*30%+D2*70%”，按回车键，单击E2单元格，在【开始】功能区的【数字】分组中，单击“减少小数位数”，然后进行填充（单击E2单元格，鼠标移到编辑框右侧，变为十字箭头时，按住左键下拉）。",@"2)	点击F2单元格，单击“编辑栏”的“插入函数”按钮，在“插入函数”对话框选择RANK函数，弹出“函数参数”对话框，第一个参数选取E2单元格，第二参数选取E2：E10，同时按F4进行绝对引用设置，第三个参数忽略不填。",@"3)	选中A1:B10，按住Ctrl键，加选E1：E10，右击选择“复制”，到Sheet2工作表的A1单元格，右击“粘贴”，双击“Sheet2”更名为“统计”；在【数据】功能区的【排序和筛选】分组中，单击“排序”，在“排序”对话框中，主要关键字选择“系统”，次序为降序; 在【数据】功能区的【分级显示】分组中，单击“分类汇总”，在分类汇总对话框中，“分类字段”选择“系部”、“汇总方式”选择“平均值”、“选定汇总项”选择“最终成绩”，单击【确定】；选取A1:C14区域，在【开始】功能区的【单元格】分组中，单击“格式”下拉列表选定“自动调整列宽”。",@"4)	选定单元格区域B5:C8，按住Ctrl键，加选B1:C1，在【插入】功能区的【图表】中，单击“柱形图”下拉列表，选定“三维簇状柱形图” ，将图表坐标轴标题修改为“百分制成绩”，调整图表大小放置在A16:E30单元格区域中。",@"5)	切换到“成绩”工作表，选定单元格区域A1:F10，鼠标右击选定“设置单元格格式”，在“设置单元格格式”对话框中，单击【边框】，选择“单实线”，单击“内部”，选择“双实线”，单击“外边框”。",@"6)	单击【保存】。"];
        }break;

        case 4:{
            
        }break;

            
        default:
            break;
    }
    
    
    
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    operationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell fillWithTitle:self.dataArray[indexPath.row] index:0];
    [cell fillWithContent:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = self.dataArray[indexPath.row];
    CGFloat height = [UILabel getHeightByWidth:SCREEN_WIDTH - 15 title:content font:SYSTEMFONT(14)];
    
    
    return height+10;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
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
