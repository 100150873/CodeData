//
//  ZCPlaceholderView.h
//  OpenShop
//
//  Created by GZC on 2018/12/19.
//  Copyright © 2018年 SuWei. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 占位图的类型 */
typedef NS_ENUM(NSInteger, ZCPlaceholderViewType) {
    
    ZCPlaceholderViewTypeNoNetwork = 0,//没网
    ZCPlaceholderViewTypeNoData,//没数据
    ZCPlaceholderViewTypeNoShop,//没门店
    ZCPlaceholderViewTypeNoResult//搜索没结果
};

#pragma mark - @protocol

@class ZCPlaceholderView;

@protocol ZCPlaceholderViewDelegate <NSObject>

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(ZCPlaceholderView *)placeholderView
   reloadButtonDidClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZCPlaceholderView : UIView

/** 占位图类型（只读） */
@property (nonatomic, assign, readonly) ZCPlaceholderViewType type;

/** 占位图的代理方（只读） */
@property (nonatomic, weak, readonly) id <ZCPlaceholderViewDelegate> delegate;

/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame
                         type:(ZCPlaceholderViewType)type
                     delegate:(id)delegate;

/**
 修改占位文字和图片
 
 @param desc 文字
 @param image 图片
 */
- (void)changePlaceholderDesc:(NSString *)desc image:(NSString *)image;


/**
 底部按钮标题
 
 @param buttonTitle 钮标题
 */
- (void)setButtonTitle:(NSString *)buttonTitle;

@end

NS_ASSUME_NONNULL_END
