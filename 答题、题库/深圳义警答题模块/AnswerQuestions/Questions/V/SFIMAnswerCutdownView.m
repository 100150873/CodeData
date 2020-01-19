//
//  SFIMAnswerCutdownView.m
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import "SFIMAnswerCutdownView.h"
#import "SFIMCollaborationModuleDefine.h"

@interface SFIMAnswerCutdownView ()
@property (strong, nonatomic) IBOutlet UILabel *cutdownlabel;

@end

@implementation SFIMAnswerCutdownView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.questionTypeLabel.backgroundColor = [UIColor sfim_colorWithHexString:@"#F4F6FA"];
    [self.questionTypeLabel setSfim_cornerRadius:11.0];
}


/// 隐藏倒计时
- (void)hideCutdown {
    self.cutdownlabel.hidden = YES;
    self.timeLabel.hidden = YES;
}


@end
