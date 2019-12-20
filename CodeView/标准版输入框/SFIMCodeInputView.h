//
//  SFIMCodeInputView.h
//  SFIMUserCenter
//
//  Created by 汤世豪(80002131) on 2019/4/15.
//

#import <UIKit/UIKit.h>

/**
 验证码输入完成回调

 @param inputText 输入的验证码
 */
typedef void(^SFIMCodeInputCompletion)(NSString *inputText);

NS_ASSUME_NONNULL_BEGIN

@interface SFIMCodeInputView : UIView

/**
 初始化方法

 @param completion 完成回调 验证码输满时回调
 @return 输入的验证码
 */
- (instancetype)initWithCompletion:(SFIMCodeInputCompletion)completion;



/**
 成为第一响应者
 */
- (void)textFieldBecomeFirstResponder;

/**
 辞去第一响应者
 */
- (void)textFieldResignFirstResponder;

@end

NS_ASSUME_NONNULL_END
