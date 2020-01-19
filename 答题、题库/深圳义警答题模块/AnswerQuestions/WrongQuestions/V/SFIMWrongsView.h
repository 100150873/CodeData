//
//  SFIMWrongsView.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFIMWrongsView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^backHomeBlock)(void);  //返回学院首页

@end

NS_ASSUME_NONNULL_END
