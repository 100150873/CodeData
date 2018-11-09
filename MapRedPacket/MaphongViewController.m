//
//  MaphongViewController.m
//  ShareChain
//
//  Created by 罗建 on 2018/10/22.
//  Copyright © 2018年 Soway. All rights reserved.
//

#import "MaphongViewController.h"
#import "YYFilterTool.h"
#import "MapViewCell.h"
#import "JiluViewController.h"
#import "ZCMapRedPacketShopTableView.h"


//筛选框的高度
static CGFloat const kFilterViewHeight = 40;
static CGFloat const kUnfloadHeight = 40;//底部展开更多商家按钮高度
static CGFloat const kCellHight = 120;//cell的高度
static CGFloat const kDefaultCellCount = 3;//默认展示cell的个数


#import "RedEnvelopesController.h"
#import "RedPacketListController.h"
#import "ZCRedPacketShareVC.h"//推广VC
#import "NearShopListController.h"
#import "PersonalStoreController.h"
#import "PanoramiMapsController.h"//全景地图VC

#import "RangeView.h"
#import "WSRedPacketView.h"
#import "ChooseNavigationView.h"
#import "ZCMapRedShopShowView.h"//点击商家大头针 弹出的商家信息view

#import "WSRewardConfig.h"
#import "DSNAnnotation.h"
#import "AuthorizationTool.h"

#import "mapRedPacketNearbyShopModel.h"//商家模型

#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotationView.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

typedef NS_ENUM(NSInteger, ZCScrollType) {//tableView停留在屏幕的位置
    ZCScrollTypeTop = 0,
    ZCScrollTypeMid,
    ZCScrollTypeBottom
};

typedef NS_ENUM(NSInteger, ZCDragDirection) {//拖拽方向 只适用一次手势中不改变滑动方向  类似美团
    ZCDragDirectionUp = 0,
    ZCDragDirectionDown
};

static NSString *kDropdownCellIdentifier    = @"MapViewCell";
static NSString *kRedPacketIdentifier       = @"kRedPacketIdentifier";//红包的大头针标识
static NSString *kShopIdentifier            = @"kShopIdentifier";//商家大头针标识
static NSString *kFullMapIdentifier         = @"kFullMapIdentifier";//全景地图大头针标识

@interface MaphongViewController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKRouteSearchDelegate>

{

    CGFloat   _shopInfoViewHeight;//底部商家信息的高度
    CGFloat   _tableViewY,_tableViewHeight;//tableView的Y值 和 高度
}


/**
 商家简要信息view
 */
@property (nonatomic, strong) ZCMapRedShopShowView         *viewShopShortInfo;
@property (nonatomic, strong) ZCMapRedPacketShopTableView   *tableView; //拖拽区域内的tableView
@property (nonatomic, strong) BMKMapView                    *mapView;
/**
 右侧的快捷view
 */
@property (nonatomic, strong) RangeView                     *viewShortcut;


@property (nonatomic, strong) UITextField                  *textFieldSearch;
/**
 增加红包数量按钮
 */
@property (nonatomic, strong) UIButton                     *btnIncrease;

/**
 重新定位按钮
 */
@property (nonatomic, strong) UIButton                      *btnRelocation;

/**
 点击展开更多按钮
 */
@property (nonatomic, strong) UIButton                      *btnShowMore;
@property (nonatomic, strong) UIButton                      *mapPin;
@property (nonatomic, strong) UIView                        *viewFilter;


@property (nonatomic, assign) ZCDragDirection              dragDirection;
/**
 已定位成功
 */
@property (nonatomic, assign) BOOL                         locationSuccess;

/**
 第一次进来请求数据成功后弹出列表tableview
 */
@property (nonatomic, assign) BOOL                         firstFlag;


/**
 搜索弹窗使用
 */
@property (nonatomic, assign) BOOL                         searchFlag;

/**
 总的商家数量 用于分页处理
 */
@property (nonatomic, assign) NSInteger                    totalShopNum;

/**
 记录滚动方向
 */
@property (nonatomic, assign) CGFloat                      lastContentOffset;


/**
 正在展示的商家模型
 */
@property(nonatomic,strong)mapRedPacketNearbyShopModel      *showingShop;
/**
 第一次进来定位到的用户的经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D        userLocation;
/**
 地图反编码
 */
@property (nonatomic, strong) BMKGeoCodeSearch              *geoCodeSearch;
/**
 地图定位
 */
@property (nonatomic, strong) BMKLocationService            *locService;
/**
 全景地图大头针
 */
@property (nonatomic, strong) DSNAnnotation                 *annotationFullMap;

/**
 路径搜索
 */
@property (nonatomic, strong) BMKRouteSearch                *routeSearch;

/**
 商家列表
 */
@property (nonatomic, strong) NSMutableArray<mapRedPacketNearbyShopModel *>          *dataSource;
@property (nonatomic, strong) NSArray<mapRedPacketNearbyModel *>     *arrayRedPacket;
@property (nonatomic, strong) NSArray<shopCategoryModel *>           *arrayShopCategory;

/**
 记录当前地图正在显示的红包大头针数组
 */
@property (nonatomic, strong) NSArray *arrayRedPacketAnnotations;
/**
 记录当前地图正在显示的商家大头针数组
 */
@property (nonatomic, strong) NSArray *arrayShopAnnotations;

@property (nonatomic, strong) NSURLSessionDataTask          *task;

@property (nonatomic, copy  ) NSString                      *currentAddress;

/**
 当前所在的市
 */
@property (nonatomic, copy) NSString                        *city;
/**
 当前定位的省
 */
@property (nonatomic, copy) NSString                        *province;

@property (nonatomic, strong) NetworkRequestNearbyShopListModel  *requestShopListModel;
@property (nonatomic, strong) NetworkRequestNearbyRedPacketList  *requestRedPacketListModel;

@end

@implementation MaphongViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.firstFlag = YES;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [AuthorizationTool locationPermissionWithAuthorizedBlock:^(BOOL flag) {
        if (flag) {
            // 有权限就开启定位
            [self startLocating];
        }
        else {
            // 没有权限设置默认中心店 113.11754 23.016725
            self.userLocation = CLLocationCoordinate2DMake(22.812087824937844, 113.71074182886726);
            //            self.defaultCenter = CLLocationCoordinate2DMake(23.016725, 113.11754);
        }
    }];
}

// 自定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        return nil;
    }
    
    NSString *identifier = [(DSNAnnotation *)annotation identifier];
    CGSize  size;
    UIImageView *backImgView = [[UIImageView alloc] init];
    BMKAnnotationView * view = [(BMKMapView *)mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:identifier];
        view.canShowCallout = NO;
        [view addSubview:backImgView];
    }
    size = CGSizeMake(35, 35);
    if ([identifier isEqualToString:kRedPacketIdentifier]) {//红包
        size = CGSizeMake(45, 49);
        backImgView.image = ZCImageNamed(@"redPack");
    }
    else if ([identifier isEqualToString:kFullMapIdentifier]) {//全景地图
        
        backImgView.image = ZCImageNamed(@"full_location_icon");//z
        size = CGSizeMake(26, 40);
        CGRect rect = CGRectMake(0, 0, 61, 65);
        UIView * viewBG = [[UIView alloc]initWithFrame:rect];//背景view
        UIButton *btn = [UIButton buttonWithImageName:@"full_look_icon"];//全景地图的提示框按钮
        [btn addTarget:self action:@selector(clickFullMapBtn:) forControlEvents:UIControlEventTouchDown];
        btn.frame = rect;
        [viewBG addSubview:btn];
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:viewBG];
        pView.frame = rect;
        view.paopaoView = pView;
        view.canShowCallout = YES;
    }
    else {//默认商店logo
        mapRedPacketNearbyShopModel *model = (mapRedPacketNearbyShopModel *)[(DSNAnnotation *)annotation bindModel];
        [backImgView sd_setImageWithURL:model.Logo placeholderImage:ZCImageNamed(@"shop_default")];
    }
    
    view.size = size;
    backImgView.size = size;
    
    return view;
}

//选中大头针
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {

    DSNAnnotation *annotation = (DSNAnnotation *)view.annotation;
    if ([annotation.identifier isEqualToString:kRedPacketIdentifier]) {//点击了红包
        ZCLog(@"点击了红包 %@",[annotation.bindModel yy_modelToJSONString]);
        mapRedPacketNearbyModel *model = (mapRedPacketNearbyModel *)annotation.bindModel;
        [[UserModel sharedModel] checkLogonStatusWithBlock:^{//登录才能领取红包
            if (model.HasUsed) {//已领取
                [self requestRobRedPacket:model];
            }
            else {//未领取
                [self openRedPacketWithModel:model];
            }
        }];
    }
    else if ([annotation.identifier isEqualToString:kShopIdentifier]) {//点击了商家
        mapRedPacketNearbyShopModel *shop = (mapRedPacketNearbyShopModel *)annotation.bindModel;
        [self showShopShortViewWithModel:shop];
    }
}

/**
 展示商店的简要信息视图
 
 @param model 商店模型
 */
- (void)showShopShortViewWithModel:(mapRedPacketNearbyShopModel *)shop {
    
    //展示全景地图按钮
    [self showFullBtn:YES];
    self.showingShop = shop;
    [self.mapView removeAnnotation:self.annotationFullMap];//删除之前添加的自定义大头针
    [self predictDrivingTimeGoShop:shop];//获取预估的路线驾车时间
    
    ZCWeakSelf;
    self.viewShopShortInfo.clickRouteBlock = ^{//查看路线
        [weakSelf addChooseNavigationViewWithShopModel:shop];
    };
    self.viewShopShortInfo.clickShopDetailBlock = ^{//查看商家详情
        [weakSelf pushToPersonalStoreControllerWithShopId:shop.ID];
    };
    
    [self.viewShopShortInfo showShopInfoWithName:shop.name logo:shop.Logo category:shop.IndustryText moods:ZCString(@"人气%ld",shop.SaleCount)];
    [self.viewShopShortInfo showShopLocationInfoWithDistance:shop.DistanceText address:shop.CityName];
    if (self.viewShopShortInfo.y == kScreenHeight) {//没有显示
        [UIView animateWithDuration:0.15 animations:^{
            self.viewShopShortInfo.transform = CGAffineTransformMakeTranslation(0, - _shopInfoViewHeight);
        }];
        [self.tableView setContentOffset:CGPointMake(0, -_tableViewHeight) animated:YES];
    }
}

/**
 隐藏商家简要信息视图
 */
- (void)hideShopShortView {
    
    if (self.viewShortcut.y < kScreenHeight) {
        self.viewShopShortInfo.transform = CGAffineTransformIdentity;
        [self showFullBtn:NO];
        [self.mapView removeAnnotation:self.annotationFullMap];
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi {
  
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
   
    [self hideShopShortView];
    [self.tableView setContentOffset:CGPointMake(0, -_tableViewHeight) animated:YES];
}

#pragma mark - =======UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length) {
        self.requestShopListModel.Keyword = textField.text;
        [self changeData];
        [self.view endEditing:YES];
    } else {
        [ToastView showMessage:@"请输入搜索内容"];
    }
    return textField.text.length;
}


/**
 *- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
 - (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
 - (void)textFieldDidEndEditing:(UITextField *)textField
 *
 */

#pragma mark - <BMKMapViewDelegate>

// 地图区域即将改变
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    [self hideShopShortView];
    [self.task cancel];
}

// 地图区域改变结束
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    [self.mapView removeFromSuperview];
    [self.view addSubview:mapView];
    [self.view sendSubviewToBack:mapView];
    [self hideShopShortView];
    
    if (self.locationSuccess) {
        CLLocationCoordinate2D center = mapView.region.center;
        // 刷新数据
        self.requestShopListModel.Latitude =  center.latitude;
        self.requestShopListModel.Longitude = center.longitude;
        
        //屏幕坐标转地图经纬度
//        CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
//        ZCLog(@"验证经纬度  %f,%f === %f,%f",center.latitude,center.longitude,MapCoordinate.latitude,MapCoordinate.longitude);
        [self changeData];
        [self reverseGeoCodeWithCoordinate:center];
    }
}

- (void)reverseGeoCodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //需要逆地理编码的坐标位置
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = coordinate;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    if(flag){
        ZCLog(@"反geo检索发送成功");
    } else {
        ZCLog(@"反geo检索发送失败");
    }
}

#pragma mark - <BMKLocationServiceDelegate>

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    if (!self.userLocation.latitude && !self.userLocation.longitude) {
        self.userLocation = userLocation.location.coordinate;
        self.requestShopListModel.Latitude = userLocation.location.coordinate.latitude;
        self.requestShopListModel.Longitude = userLocation.location.coordinate.longitude;
        ZCLog(@"定位到用户经纬度 == %f  %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        [self changeData];
        [self reverseGeoCodeWithCoordinate:self.userLocation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.locationSuccess = YES;
        });
    }
}

#pragma mark - =======BMKGeoCodeSearchDelegate 地理反编码=========

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        self.province = result.addressDetail.province;
        self.city = result.addressDetail.city;
        //        ZCLog(@"定位到的省市 == %@  %@",[result yy_modelToJSONString],result.address);
        self.currentAddress = ZCString(@"%@-%@",result.addressDetail.district,result.addressDetail.streetName);
        [self requestNearbyRedPacketListWithProvinceName:self.province cityName:self.city longitude:self.requestShopListModel.Longitude latitude:self.requestShopListModel.Latitude];
    } else {
        ZCLog(@"地理反编码失败");
    }
}

#pragma mark - =======BMKRouteSearchDelegate 路线检索的代理=========
/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {//成功获取结果
        
        BMKDrivingRouteLine *routeLine = result.routes.firstObject;
        BMKTime *time = routeLine.duration;
        NSMutableString *result = [[NSMutableString alloc] initWithString:@"预计到达时间"];
        if (time.dates > 0) {
            [result appendString:ZCString(@"%d天%d小时%d分",time.dates,time.hours,time.minutes)];
        } else if (time.hours > 0) {
            [result appendString:ZCString(@"%d小时%d分",time.hours,time.minutes)];
        } else if (time.minutes > 0) {
            [result appendString:ZCString(@"%d分",time.minutes)];
        }
        //        ZCLog(@"预估时间 %@", [result yy_modelToJSONString]);
        self.viewShopShortInfo.routeTime = result;
    } else {//检索失败
    }
}

#pragma mark - =======网络请求=========


- (void)changeData {
    
    self.requestShopListModel.PageIndex = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self requestNearbyShopListData];
}

/**
 上拉加载更多商家
 */
- (void)loadMoreData {
    
    if (self.dataSource.count >= self.totalShopNum) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        self.requestShopListModel.PageIndex ++;
        [self requestNearbyShopListData];
    }
}

/**
 获取附近商家列表
 */
- (void)requestNearbyShopListData {
    
    [self.view endEditing:YES];
    if (self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    self.requestShopListModel.setupModel = [[NetworkRequestNearbyShopListModel alloc] init].setupModel;
    ZCWeakSelf;
    self.task = [HTTPSessionManager requestWithModel:self.requestShopListModel callBack:^(NetworkResponseModel *responseModel) {

        if (responseModel.code == 1) {
            
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.totalShopNum = responseModel.total;
            NSArray *list = @[];
            if (weakSelf.requestShopListModel.PageIndex == 1) {
                list = [NSArray yy_modelArrayWithClass:[mapRedPacketNearbyShopModel class] json:responseModel.data];
                weakSelf.dataSource = [NSMutableArray arrayWithArray:list];
            } else {
                list = [NSArray yy_modelArrayWithClass:[mapRedPacketNearbyShopModel class] json:responseModel.data];
                [weakSelf.dataSource addObjectsFromArray:list];
            }
            
            if (list.count < 5) {//为了能不显示透明的tableview  特意做的效果
                for (NSInteger i = 0; i < 5 - list.count ; i ++) {
                    mapRedPacketNearbyShopModel *shop = [[mapRedPacketNearbyShopModel alloc] init];
                    [weakSelf.dataSource addObject:shop];
                }
            }
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.firstFlag) {//第一次请求成功 弹窗
                weakSelf.firstFlag = NO;
                [weakSelf unfoldTableView];
            }
            
//            if (weakSelf.searchFlag) {//搜索结果要全屏显示
//                weakSelf.searchFlag = NO;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView setContentOffset:CGPointZero animated:NO];
//                });
//            }
            
        } else {
            if (weakSelf.requestShopListModel.PageIndex > 1) {
                weakSelf.requestShopListModel.PageIndex --;
            }
        }
    }];
}


/**
 获取附近的红包列表
 
 @param provinceName 省会名称
 @param cityName 市区名称
 @param longitude 经度
 @param latitude 维度
 */
- (void)requestNearbyRedPacketListWithProvinceName:(NSString *)provinceName
                                          cityName:(NSString *)cityName
                                         longitude:(CGFloat)longitude
                                          latitude:(CGFloat)latitude {
    
    self.requestRedPacketListModel.setupModel = [[NetworkRequestNearbyRedPacketList alloc] init].setupModel;
    self.requestRedPacketListModel.setupModel.host = host_Test;
    self.requestRedPacketListModel.Latitude = latitude;
    self.requestRedPacketListModel.Longitude = longitude;
    self.requestRedPacketListModel.ProvinceName = provinceName;
    self.requestRedPacketListModel.CityName = cityName;
    ZCWeakSelf;
    [HTTPSessionManager requestWithModel:self.requestRedPacketListModel callBack:^(NetworkResponseModel *responseModel) {
        if (responseModel.code == 1) {
            weakSelf.arrayRedPacket = [NSArray yy_modelArrayWithClass:[mapRedPacketNearbyModel class] json:responseModel.data];
            [weakSelf updateRedPacketAnnotations:weakSelf.arrayRedPacket];
        }
    }];
    
}

/**
 抢红包
 
 @param redPacketID 红包ID
 */
- (void)requestRobRedPacket:(mapRedPacketNearbyModel *)redPacket
{
    NetworkRequestRobRedPacket *robRequest = [[NetworkRequestRobRedPacket alloc] init];
    robRequest.Latitude = self.requestShopListModel.Latitude;
    robRequest.Longitude = self.requestShopListModel.Longitude;
    robRequest.ProvinceName = self.province;
    robRequest.CityName = self.city;
    robRequest.RedPacketId = redPacket.ID;
    [HTTPSessionManager requestWithModel:robRequest callBack:^(NetworkResponseModel *responseModel) {
        if (responseModel.code == 1) {//领取成功
            robRedPacketResultModel *resultModel = [robRedPacketResultModel yy_modelWithJSON:responseModel.data];
            RedEnvelopesController*fenleiContr=[[RedEnvelopesController alloc] init];
            fenleiContr.redPacketModel = redPacket;
            fenleiContr.resultModel = resultModel;
            [self presentViewController:fenleiContr animated:YES completion:nil];
        }
        else if (responseModel.code == 23) {//用户可用次数已无
            [ToastView showMessage:responseModel.desc];
        }
        else {
            
            [ToastView showMessage:responseModel.desc duration:2.0];
        }
    }];
}


/**
 获取商家分类列表数据
 */
- (void)requestShopCategoryListResult:(dispatch_block_t)result
{
    NetworkRequestShopCategoryList *categoryRequest = [[NetworkRequestShopCategoryList alloc] init];
    [HTTPSessionManager requestWithModel:categoryRequest callBack:^(NetworkResponseModel *responseModel) {
        if (responseModel.code == 1) {
            self.arrayShopCategory = [NSArray yy_modelArrayWithClass:[shopCategoryModel class] json:responseModel.data];
            !result ? : result();
        } else {
            [ToastView showMessage:responseModel.desc];
        }
    }];
}

#pragma mark - =======Private Method=========

/**
 预计到达店铺的时间
 
 @param shop 正在展示的店铺
 */
- (void)predictDrivingTimeGoShop:(mapRedPacketNearbyShopModel *)shop {
    
    //构造驾车查询基础信息类
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = CLLocationCoordinate2DMake(self.userLocation.latitude, self.userLocation.longitude);
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake(shop.ShopLatitude, shop.ShopLongitude);
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingPolicy = BMK_DRIVING_TIME_FIRST;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL flag = [self.routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag) {
        ZCLog(@"car检索发送成功");
    }
    else {
        ZCLog(@"car检索发送失败");
    }
    
}

// 开启定位
- (void)startLocating {
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    [self.locService startUserLocationService];
    
    _mapPin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 47)];
    [_mapPin setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
    [_mapView bringSubviewToFront:_mapPin];
}

// 修改地图中心
- (void)setMapViewCenter:(CLLocationCoordinate2D)center {
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = center;//中心点
    region.span.latitudeDelta  = 0.05;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.05;//纬度范围 22.542945  113.962056
    [self.mapView setRegion:region animated:NO];
}

#pragma mark - =======添加大头针=========
- (void)setMapViewAnnotationsWithShopModelArr:(NSArray *)modelArr {
    
    if (self.arrayShopAnnotations.count) {
        [self.mapView removeAnnotations:self.arrayShopAnnotations];
    }
    
    
    NSMutableArray *annotationArr = [NSMutableArray array];
    for (mapRedPacketNearbyShopModel *model in modelArr) {
        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(model.latitude,model.longitude);
        DSNAnnotation *annotation = [[DSNAnnotation alloc] initWithCoordinate2D:coordinate2D title:model.ShopName subTitle:model.address];
        annotation.bindModel = model;
        annotation.identifier = kShopIdentifier;
        [annotationArr addObject:annotation];
        self.arrayShopAnnotations = annotationArr;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mapView addAnnotations:annotationArr];
    }];
}

- (void)updateRedPacketAnnotations:(NSArray *)annotations
{
    if (self.arrayRedPacketAnnotations.count) {
        [self.mapView removeAnnotations:self.arrayRedPacketAnnotations];
    }
    
    NSMutableArray *annotationArr = [NSMutableArray array];
    NSInteger count = annotations.count;
    for (NSInteger i = 0; i < count; i ++) {
        
        mapRedPacketNearbyModel *redPacket = annotations[i];
        CGFloat arcLat = (arc4random() % 30) / 3000.0;
        CGFloat arcLon = (arc4random() % 50) / 3000.0;
        CGFloat latitu =  0.0;CGFloat longit = 0.0;
        if (i <= count / 2) {
            latitu = self.requestShopListModel.Latitude + arcLat;
            longit = self.requestShopListModel.Longitude + arcLon;
        } else {
            latitu = self.requestShopListModel.Latitude - arcLat;
            longit = self.requestShopListModel.Longitude  - arcLon;
        }
        
        //        ZCLog(@"红包经纬度 %.10f %.10f",coordinate2D.latitude,coordinate2D.longitude);
        DSNAnnotation *annotation = [[DSNAnnotation alloc] initWithCoordinate2D:CLLocationCoordinate2DMake(latitu,longit) title:redPacket.Title subTitle:redPacket.AccountName];
        [annotationArr addObject:annotation];
        annotation.bindModel = redPacket;
        annotation.identifier = kRedPacketIdentifier;
        self.arrayRedPacketAnnotations = annotationArr;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mapView addAnnotations:annotationArr];
    }];
}

- (void)navigationWithShopModel:(mapRedPacketNearbyShopModel *)model navigationType:(NavigationType)navigationType {
    if ((navigationType == NavigationTypeGaoDe && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) ||
        (navigationType == NavigationTypeBaiDu && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])) {
        [ToastView showMessage:@"未安装相应导航软件"];
    }
    else {
        if (navigationType == NavigationTypeJieJing) {
            
            [self pushToFullMapVCWithLat:model.ShopLatitude lon:model.ShopLongitude title:model.ShopName];
        }
        else {
            NSString *url;
            if (navigationType == NavigationTypeGaoDe) {
                url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=%@&did=BGVIS2&dlat=%1f&dlon=%1f&dname=%@&dev=0&m=0&t=0", self.userLocation.latitude, self.userLocation.longitude,@"我的位置",  model.ShopLatitude, model.ShopLongitude, model.ShopName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else {
                url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%lf,%lf|name:%@&destination=latlng:%1f,%1f|name:%@&mode=driving", self.userLocation.latitude, self.userLocation.longitude, @"我的位置", model.ShopLatitude, model.ShopLongitude,model.ShopName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            }
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                if (kIOS10Later) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                }
                else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }
        }
    }
}


#pragma mark - Push/Pop、Present/Dismiss

- (void)pushToNearShopListController {
    
    NearShopListController *viewController = [[NearShopListController alloc] init];
    viewController.defaultCenter = self.userLocation;
    viewController.dataSource = self.dataSource;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToPersonalStoreControllerWithShopId:(NSString *)shopId {
    
    PersonalStoreController *viewController = [[PersonalStoreController alloc] init];
    viewController.shopId = shopId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addChooseNavigationViewWithShopModel:(mapRedPacketNearbyShopModel *)model {
    __weak typeof(self) weakSelf = self;
    ChooseNavigationView *chooseNavigationView = ({
        ChooseNavigationView *chooseNavigationView = [[ChooseNavigationView alloc] init];
        chooseNavigationView.chooseBlock = ^(NSInteger index) {
            [weakSelf navigationWithShopModel:model navigationType:index - 1];
        };
        chooseNavigationView;
    });
    
    [self.view addSubview:chooseNavigationView];
    [chooseNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}

/**
 跳转全景地图控制器
 
 @param lat 维度
 @param lon 经度
 @param title 全景地图标题
 */
- (void)pushToFullMapVCWithLat:(CGFloat)lat lon:(CGFloat)lon title:(NSString *)title {
    
    PanoramiMapsController *viewController = [[PanoramiMapsController alloc] init];
    [viewController lookFullScreenWithAddress:title lat:lat lon:lon];
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 跳转红包记录页面
 */
- (void)pushToRedPacketRecordVC {
    
    ZCWeakSelf;
    [[UserModel sharedModel] checkLogonStatusWithBlock:^{
        RedPacketListController *viewController = [[RedPacketListController alloc] init];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
}

/**
 返回上一个页面
 */
- (void)popPreVC {
    
    if (self.viewShopShortInfo.y == kScreenHeight) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self hideShopShortView];
    }
}

#pragma mark - <Initialization>

- (void)initData {
    
    self.requestRedPacketListModel = [[NetworkRequestNearbyRedPacketList alloc] init];
    self.requestShopListModel = [[NetworkRequestNearbyShopListModel alloc] init];
}

- (void)initSubviews {
    
    //顶部搜索框的白色背景view
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 37, kScreenWidth - 20, 48)];
    [searchBgView addcornerRadius:3.0];
    searchBgView.backgroundColor = [UIColor whiteColor];//lightGrayColor
    [self.view addSubview:searchBgView];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 30, 40)];
    backButton.centerY = searchBgView.height * 0.5;
    [backButton setImage:[UIImage imageNamed:@"backbtns"]  forState:UIControlStateNormal];
    backButton.contentMode = UIViewContentModeLeft;
    [searchBgView addSubview:backButton];
    [backButton addTarget:self action:@selector(popPreVC) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(backButton.right + 10, 0, 0.9, searchBgView.height)];
    line.backgroundColor = ZCColorSeperate;
    [searchBgView addSubview:line];
    
    //红包记录按钮
    UIButton *recordButton = [[UIButton alloc]initWithFrame:CGRectMake(searchBgView.width - 50, 29, 36, 36)];
    recordButton.centerY = searchBgView.height * 0.5;
    [recordButton setImage:[UIImage imageNamed:@"jiluhongb"] forState:UIControlStateNormal];
    recordButton.imageView.contentMode   = UIViewContentModeScaleAspectFit;
    [recordButton addTarget:self action:@selector(pushToRedPacketRecordVC) forControlEvents:UIControlEventTouchUpInside];
    [searchBgView addSubview:recordButton];
    
    //284 往左偏移5个像素
    CGFloat width = recordButton.left - line.right - 20;
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(line.right + 10, 0, width, 36)];
    searchBar.centerY = searchBgView.height * 0.5;
    searchBar.font = ZCFont(15);
    searchBar.textColor = ZCColorTitle;
    [searchBar setValue:ZCFont(13) forKeyPath:@"_placeholderLabel.font"];
    [searchBar setValue:ZCColorTitle forKeyPath:@"_placeholderLabel.textColor"];
    searchBar.placeholder = @" 搜索地点或商圈";
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:ZCImageNamed(@"shousuo")];
    searchIcon.height = searchIcon.width = 35;
    searchIcon.contentMode = UIViewContentModeCenter;
    searchBar.leftView = searchIcon;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.returnKeyType = UIReturnKeySearch;
    [searchBgView addSubview:searchBar];
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearch = searchBar;
    self.textFieldSearch.delegate = self;
    
    // 地图
    self.mapView = ({
        BMKLocationViewDisplayParam *locDisplayParam = [[BMKLocationViewDisplayParam alloc] init];
        locDisplayParam.isAccuracyCircleShow = NO;
        locDisplayParam.isRotateAngleValid   = NO;
        locDisplayParam.locationViewOffsetX  = 0;
        locDisplayParam.locationViewOffsetY  = 0;
        locDisplayParam.locationViewImgName  = @"location";
        
        BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        mapView.showsUserLocation = YES;//显示定位图层
        mapView.showMapScaleBar   = YES;
        mapView.userTrackingMode  = MKUserTrackingModeFollow;
        mapView.zoomLevel         = 15.135120;
        mapView.delegate          = self;
        [mapView updateLocationViewWithParam:locDisplayParam];
        mapView;
    });
    [self.view addSubview:self.mapView];
    //地图中间的定位图标
    UIImageView *imgVLocation = [[UIImageView alloc] initWithImage:ZCImageNamed(@"location_map_icon")];
    [self.view addSubview:imgVLocation];
    imgVLocation.size = CGSizeMake(25, 46);
    imgVLocation.center = self.mapView.center;
    
}


#pragma mark - StatusBar

- (UIStatusBarStyle)fd_preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - NavigationBar

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}


#pragma mark - FullScreenPop

- (BOOL)fd_interactivePopDisabled {
    return YES;
}

/**
 打开红包
 
 @param model 红包模型
 */
- (void)openRedPacketWithModel:(mapRedPacketNearbyModel *)model
{
    WSRewardConfig *info = ({
        WSRewardConfig *info   = [[WSRewardConfig alloc] init];
        info.money         = model.UsedCount;
        info.avatarImage    = [UIImage imageWithData:[NSData dataWithContentsOfURL:model.AccountAvatarUrl]];
        info.content = model.Title;
        info.userName  = model.AccountName;
        info;
    });
    
    ZCWeakSelf;
    [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
        ZCLog(@"取消领取");
    } finishBlock:^(float money) {
        [weakSelf requestRobRedPacket:model];
    }];
}

#pragma mark--配置拖拽view
-(void)setupUI
{
    
    _shopInfoViewHeight = ZCWidth(145);
    _tableViewY = 85 + 20 + kFilterViewHeight;//85 为搜索框的底部  20为间距
    _tableViewHeight = kScreenHeight - _tableViewY;
    /*--------------------- 筛选view -----------------------*/
    self.viewFilter = [[UIView alloc]initWithFrame:CGRectMake(0, _tableViewY - kFilterViewHeight, kScreenWidth, kFilterViewHeight)];
    self.viewFilter.hidden = YES;
    self.viewFilter.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"全部",@"智能排序"];
    for (int i = 0; i < 2; i ++) {
        float width = kScreenWidth * 0.5;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, kFilterViewHeight)];
        [btn setImage:ZCImageNamed(@"arrow_dwon") forState:UIControlStateNormal];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setImage:ZCImageNamed(@"arrow_selected_down") forState:UIControlStateSelected];
        [btn setButtonImageTitleStyle:1 spacing:8];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:ZCColorTitle forState:UIControlStateNormal];
        [btn setTitleColor:ZCColor(@"#F80100") forState:UIControlStateSelected];
        btn.tag = 50 + i;
        [self.viewFilter addSubview:btn];
        [btn addTarget:self action:@selector(clickFilerBtn:) forControlEvents:UIControlEventTouchDown];
    }
    [self.view addSubview:self.viewFilter];
    
    //分割线
    UIView *line =  [[UIView alloc]initWithFrame:CGRectMake(0, kFilterViewHeight - 1, kScreenWidth, 1)];
    line.backgroundColor =[UIColor colorWithRed:232/255.0 green:233/255.0 blue:235/255.0 alpha:1.0];
    [self.viewFilter addSubview:line];
    
     /*--------------------- 底部展开更多按钮 -----------------------*/
    self.btnShowMore = [UIButton buttonWithNormalName:@"展开更多商家" font:ZCFont(15) titleColor:ZCColorTitle backGroundColor:[UIColor whiteColor] normalImageName:@"unfold_more_icon"];
    [self.btnShowMore setButtonImageTitleStyle:1 spacing:4];
    [self.btnShowMore addTarget:self action:@selector(clickShowMoreBtn:) forControlEvents:UIControlEventTouchDown];
    self.btnShowMore.frame = CGRectMake(0, kScreenHeight - kUnfloadHeight, kScreenWidth, kUnfloadHeight);
    [self.view addSubview:self.btnShowMore];
    self.btnShowMore.hidden = YES;
    
     /*--------------------- 快捷键按钮 -----------------------*/
    
    CGFloat space = 15;
    // 放大缩小
    RangeView *rangeView = [RangeView rangeWithArray:@[@"quanjing",@"increase_icon",@"minus_icon"]];
    [self.view addSubview:rangeView];
    rangeView.backgroundColor = [UIColor whiteColor];
    self.viewShortcut = rangeView;
    [self showFullBtn:NO];//布置约束
    ZCWeakSelf;
    rangeView.didClickItemBlock = ^(NSInteger index){

        switch (index) {
            case 0: {//全景

                mapRedPacketNearbyShopModel *shop =  weakSelf.showingShop;
                weakSelf.annotationFullMap = [[DSNAnnotation alloc] initWithCoordinate2D:CLLocationCoordinate2DMake(shop.ShopLatitude,shop.ShopLongitude) title:shop.ShopName subTitle:shop.address];
                weakSelf.annotationFullMap.bindModel = shop;
                weakSelf.annotationFullMap.identifier = kFullMapIdentifier;
                [weakSelf.mapView addAnnotation:weakSelf.annotationFullMap];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [weakSelf.mapView selectAnnotation:weakSelf.annotationFullMap animated:YES];
                });
            }
                break;
            case 1: {//放大
                weakSelf.mapView.zoomLevel ++;
            }
                break;
            case 2: {//缩小
                weakSelf.mapView.zoomLevel --;
            }
                break;
        }
    };
    
    CGFloat bottom = kScreenHeight - kUnfloadHeight - space;
    //增加红包数量
    self.btnIncrease = [UIButton buttonWithNormalName:@"增加收红包数量" font:ZCFont(11) titleColor:RGB(164, 164, 164) backGroundColor:[UIColor clearColor] normalImageName:@"fengxiang"];
   self.btnIncrease.frame = CGRectMake((kScreenWidth-127)/2, 0, 127, 46);
    [self.btnIncrease setBackgroundImage:[UIImage imageNamed:@"圆角矩形 1"] forState:UIControlStateNormal];
    [self.view addSubview:self.btnIncrease];
    [self.btnIncrease addTarget:self action:@selector(clickIncreaseRedPacketNumBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.btnIncrease.bottom = bottom;

    //定位
    self.btnRelocation = [UIButton buttonWithImageName:@"my_location_icon"];
    self.btnRelocation.backgroundColor = [UIColor whiteColor];
    [self.btnRelocation addBorderWidth:0.6 WithColor:ZCColorSeperate cornerRadius:4];
    [self.view addSubview:self.btnRelocation];
    [self.btnRelocation addTarget:self action:@selector(clickRelocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.btnRelocation.frame = CGRectMake(17, 0, 36, 36);
    self.btnRelocation.bottom = bottom;
    
    /*--------------------- 初始化tableView -----------------------*/
    
    self.tableView = [[ZCMapRedPacketShopTableView alloc]initWithFrame:CGRectMake(0, _tableViewY, kScreenWidth, _tableViewHeight) style:UITableViewStylePlain];
    //tableview不延时
    self.tableView.delaysContentTouches = NO;
    for (UIView *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subView).delaysContentTouches = NO;
        }
    }
    
    self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //tableview下移
    self.tableView.contentInset = UIEdgeInsetsMake(_tableViewHeight, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(- 104, 0, 0, 0);
    self.tableView.estimatedRowHeight = kCellHight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    UINib *nib=[UINib nibWithNibName:@"MapViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:kDropdownCellIdentifier];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.ignoredScrollViewContentInsetBottom = 40;
    self.tableView.mj_footer = footer;
    footer.backgroundColor = [UIColor whiteColor];
    
    //添加KVO监听
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 是否显示全景地图按钮

 @param show YES展示 NO不展示
 */
- (void)showFullBtn:(BOOL)show
{
    [self.viewShortcut showFullBtn:show];
    
    CGFloat height = 39 * (show ? 3 : 2);
    self.viewShortcut.size = CGSizeMake(35, height);
    self.viewShortcut.right = kScreenWidth - 15;
    CGFloat bottom = kScreenHeight - (show ? _shopInfoViewHeight : kUnfloadHeight) - 15;
   self.btnRelocation.bottom = self.btnIncrease.bottom = self.viewShortcut.bottom = bottom;
}


/**
 展开tableView
 */
- (void)unfoldTableView {
    
    NSInteger count = self.dataSource.count > kDefaultCellCount ? kDefaultCellCount : self.dataSource.count;
    [self.tableView setContentOffset:CGPointMake(0, count * kCellHight - _tableViewHeight) animated:YES];
}



#pragma mark - =======Action 按钮点击事件=========

- (void)clickShowMoreBtn:(UIButton *)btn {
    
    [self unfoldTableView];
}


/**
 点击了泡泡的全景地图按钮
 
 @param btn 按钮
 */
- (void)clickFullMapBtn:(UIButton *)btn {
    
    [self pushToFullMapVCWithLat:self.showingShop.ShopLatitude lon:self.showingShop.ShopLongitude title:self.showingShop.ShopName];
}


- (void)clickRelocationBtn:(UIButton *)btn
{
    [self.mapView setCenterCoordinate:self.userLocation animated:YES];
}


/**
 点击了增加红包数量按钮
 
 @param btn 按钮
 */
- (void)clickIncreaseRedPacketNumBtn:(UIButton *)btn
{
    [[UserModel sharedModel] checkLogonStatusWithBlock:^{
        ZCRedPacketShareVC *shareVC = [[ZCRedPacketShareVC alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
}

/**
 点击了筛选按钮
 
 @param btn 筛选按钮
 */
- (void)clickFilerBtn:(UIButton *)btn
{
//    btn.selected = !btn.selected;
    if (btn.tag == 50) {//全部
        
        dispatch_block_t showCategoryBlock = ^{
            NSArray *categoryArray = [self.arrayShopCategory valueForKeyPath:@"Name"];
            [self showFilterListWithArray:categoryArray selectedBlock:^(NSString *str, NSInteger index) {
                for (shopCategoryModel *item in self.arrayShopCategory) {
                    if ([str isEqualToString:item.Name]) {
                        btn.selected = YES;
                        [btn setTitle:str forState:UIControlStateSelected];
                        [btn setButtonImageTitleStyle:1 spacing:8];
                        self.requestShopListModel.CategoryId = item.Code;
                        self.searchFlag = YES;
                        [self changeData];
                        break;
                    }
                }
            }];
        };
        
        if (self.arrayShopCategory.count) {//直接展示
            showCategoryBlock();
        } else {
            [self requestShopCategoryListResult:^{//请求网络
                showCategoryBlock();
            }];
        }
    } else {//排序
        /**
         排序方式   0 默认排序 1 智能排序 2 好评优选 3人气最高
         */
        [self showFilterListWithArray:@[@"智能排序",@"好评优选",@"人气最高"] selectedBlock:^(NSString *str, NSInteger index) {
            btn.selected = YES;
            [btn setTitle:str forState:UIControlStateSelected];
            [btn setButtonImageTitleStyle:1 spacing:8];
            self.requestShopListModel.SortType = index + 1;
            [self changeData];
        }];
    }
}

- (void)showFilterListWithArray:(NSArray *)array selectedBlock:(void (^)(NSString *str,NSInteger index))selectedBlock
{
    YYFilterTool *filterTool = [YYFilterTool shareInstance];
    filterTool.firstLevelElements = array;
    filterTool.topConditionEnable = YES;
    //    filterTool.levelType = YYBaseFilterTypeSingleLevel;//默认是一层，所以可以不用写
    //    filterTool.multiSelectionEnable = NO;//默认不支持多选，所以可以不写
    [filterTool popFilterViewWithStartY:_tableViewY startAnimateComplete:nil closeAnimateComplete:nil];
    filterTool.filterComplete = ^(NSArray *filters) {
        ZCLog(@"点击了 == %@",filters);
        FilterSelectIndexModel *model = filters.firstObject;
        !selectedBlock ? : selectedBlock(model.filterName,model.index);
    };
}

#pragma mark - KVO 监听tableView的contentOffset属性（收缩头部视图）
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        ZCLog(@"kvo监听到变化");
        CGPoint tableContenOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (!self.firstFlag) {//第一次网络成功后才进行设置
            self.btnShowMore.hidden = !(- tableContenOffset.y == _tableViewHeight);
        }
    }
}

#pragma mark - =======监听tableViewf的滚动代理=========

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    self.lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
}

//    ZCLog(@"tableView正在偏移  y = %f 高度 %f",scrollView.contentOffset.y,_tableViewHeight);

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    CGFloat speed = fabs(velocity.y);
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"速度 = %f 松开位置 = %f ",speed,offsetY);
    
    CGFloat maxSpeed = 2.7;
    CGFloat defaultOffsetY = _tableViewHeight - kDefaultCellCount * kCellHight;//默认显示的OffsetY
    
    if ( velocity.y < 0 ) {//向下滑动
        
        if ((speed > maxSpeed && offsetY >500) || (speed > 0 && offsetY > - 84)) {//顶部往下滑
            [self scrollScrollView:ZCScrollTypeTop];
        }
        else if (speed > maxSpeed && offsetY < 0) {//顶下部 高速下滑
            [self scrollScrollView:ZCScrollTypeBottom];
        }
        else if (speed > 0 && (offsetY < 0 && offsetY > - defaultOffsetY )) {//中上部往下滑
            [self scrollScrollView:ZCScrollTypeMid];
        }
        else if (speed > 0 && offsetY < - defaultOffsetY) {//中下部往下滑
            [self scrollScrollView:ZCScrollTypeBottom];
        }
    }
    else {//向上滑动
        
        if (offsetY > 0) {//顶部往上滑
            
        }
        else if (speed > maxSpeed && offsetY < 0) {//顶下部 高速上滑
            
        }
        else if (speed > 0 && (offsetY < 0 && offsetY > - defaultOffsetY )) {//中上部往上滑
            [self scrollScrollView:ZCScrollTypeTop];
        }
        else if (speed > 0 && offsetY < - defaultOffsetY) {//中下部往上滑
            [self scrollScrollView:ZCScrollTypeMid];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY  = scrollView.contentOffset.y;
    self.tableView.backgroundColor = (offsetY >= 0) ? [UIColor whiteColor] : [UIColor clearColor];
    
    if (offsetY < self.lastContentOffset){//向下滚动
        self.dragDirection =  ZCDragDirectionDown;
    }
    else if (offsetY > self.lastContentOffset){//向上滚动
        self.dragDirection = ZCDragDirectionUp;
    }
    
//    CGFloat defaultHeight = kDefaultCellCount * kCellHight;//默认显示的高度
    CGFloat showingHeight = offsetY + _tableViewHeight;//屏幕正在展示的tableview的高度
    
    /*--------------------- 控制快捷按钮的滑动位置 -----------------------*/
    if (showingHeight > kDefaultCellCount * kCellHight) {//向上滑动超过tableview高度的一半
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{ //0.15秒内做完改变frame的动画，动画效果匀速
            self.viewShortcut.alpha = self.btnRelocation.alpha = self.btnIncrease.alpha = 0;
        } completion:nil];
    } else {
        self.viewShortcut.alpha = self.btnRelocation.alpha = self.btnIncrease.alpha = 1;
        if (showingHeight >= kUnfloadHeight + 15) {
            self.btnRelocation.bottom = self.viewShortcut.bottom = self.btnIncrease.bottom = kScreenHeight - showingHeight - 15;
        }
    }
    
    /*--------------------- 控制筛选框的滑动位置 -----------------------*/
    if (offsetY + kFilterViewHeight > 0) {
        
        self.viewFilter.hidden = NO;
        if (offsetY < 0) {
            self.viewFilter.y = _tableViewY + kFilterViewHeight - (kFilterViewHeight + offsetY)*2;
        }
        else {
            self.viewFilter.y = _tableViewY - kFilterViewHeight;
        }
    }
    else {
        self.viewFilter.hidden = YES;
    }
}


 /*--------------------- 监听滑动停止 -----------------------*/
//（1）监听快速滑动，惯性慢慢停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {// 停止后要执行的代码
        [self scrollViewEndScroll:scrollView];
    }
}

//（2）手指控制直接停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {//手指控制 直接停止 也就是拖动一段距离直接停止
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {// 停止后要执行的代码
            [self scrollViewEndScroll:scrollView];
        }
    }
}


- (void)scrollViewEndScroll:(UIScrollView *)scrollView {
    
    scrollView.auto
    CGFloat offsetY  = scrollView.contentOffset.y;
    CGFloat showingHeight = offsetY + _tableViewHeight;//屏幕正在展示的tableview的高度
    //    ZCLog(@"tableView偏移量  y = %f   %f",scrollView.contentOffset.y,offsetY + _tableViewHeight);
    CGFloat defaultHeight = kDefaultCellCount * kCellHight;//默认显示的高度
    if ( showingHeight > defaultHeight && offsetY < 0) { //停留在 默认高度与顶部之间
        
        if (self.dragDirection == ZCDragDirectionUp) {//向上拖拽
            [self scrollScrollView:ZCScrollTypeTop];
        }
        else {//向下拖拽
            [self scrollScrollView:ZCScrollTypeMid];
        }
    }
    else if (showingHeight < defaultHeight && offsetY < 0 && showingHeight > 0) {//停留在 默认高度的下面
        
        if (self.dragDirection == ZCDragDirectionUp) {//向上拖拽
           [self scrollScrollView:ZCScrollTypeMid];
        }
        else {//向下拖拽
          [self scrollScrollView:ZCScrollTypeBottom];
        }
    }
}

/**
 滚动ScrollView到指定位置

 @param type 位置枚举类型 上、中、下
 */
- (void)scrollScrollView:(ZCScrollType)type {
    
    [self performSelectorOnMainThread:@selector(setTableViewOffsetY:) withObject:@(type) waitUntilDone:NO];
}

- (void)stopOnTop:(UIScrollView *)scrollView {
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
}


- (void)setTableViewOffsetY:(NSNumber *)type {
    
    switch (type.integerValue) {
        case ZCScrollTypeTop: {
            [self.tableView setContentOffset:CGPointZero animated:YES];
        }
            break;
        case ZCScrollTypeMid: {
            [self unfoldTableView];
        }
            break;
        case ZCScrollTypeBottom: {
            [self.tableView setContentOffset:CGPointMake(0, - _tableViewHeight) animated:YES];
        }
            break;
    }
    
}


#pragma mark - =======UITableView 的代理事件=========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropdownCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    mapRedPacketNearbyShopModel *model = self.dataSource[indexPath.row];
    if (model.ID) {
        [cell.imageview sd_setImageWithURL:model.Logo placeholderImage:ZCImageNamed(@"")];
        
        cell.namelabel.text = model.ShopName;
        cell.maplabel.text = model.Business;
        cell.taplabel.text = model.IndustryText;
        cell.lastlabel.text = ZCString(@"%ld人气",(long)model.SaleCount);
        [cell.kmlabel setTitle:model.DistanceText forState:0];
        cell.tags = model.tags;
        [cell hideAllSubviews:NO];
    } else {
        [cell hideAllSubviews:YES];
    }
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    mapRedPacketNearbyShopModel *model = self.dataSource[indexPath.row];
    if (model.ID) {
        [self pushToPersonalStoreControllerWithShopId:model.ID];
    }
}

#pragma mark - =======Setter Getter=========

- (void)setUserLocation:(CLLocationCoordinate2D)userLocation {
    
    _userLocation = userLocation;
    [self setMapViewCenter:userLocation];
}

- (void)setDataSource:(NSMutableArray<mapRedPacketNearbyShopModel *> *)dataSource {
    _dataSource = dataSource;
    
    [self setMapViewAnnotationsWithShopModelArr:dataSource];
}

- (BMKGeoCodeSearch *)geoCodeSearch
{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}

- (ZCMapRedShopShowView *)viewShopShortInfo {
    if (!_viewShopShortInfo) {
        _viewShopShortInfo = [[ZCMapRedShopShowView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, _shopInfoViewHeight)];
        _viewShopShortInfo.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_viewShopShortInfo];
        _viewShopShortInfo.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _shopInfoViewHeight);
    }
    return _viewShopShortInfo;
}

- (BMKRouteSearch *)routeSearch {
    if (!_routeSearch) {
        _routeSearch = [[BMKRouteSearch alloc] init];
        _routeSearch.delegate = self;
    }
    return _routeSearch;
}

- (void)dealloc {
    
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    [self.locService stopUserLocationService];
    self.locService.delegate = nil;
    self.locService = nil;
    self.geoCodeSearch.delegate = nil;
    self.geoCodeSearch = nil;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end



