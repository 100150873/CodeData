//
//  SFIMQuestionBankView.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFIMQuestionBankView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) void (^backHomeBlock)(void);  //返回上一页
@end

NS_ASSUME_NONNULL_END
