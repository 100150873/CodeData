//
//  SFIMAnswerCutdownView.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFIMAnswerCutdownView : UIView

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

/// 隐藏倒计时
- (void)hideCutdown;

@end

NS_ASSUME_NONNULL_END
