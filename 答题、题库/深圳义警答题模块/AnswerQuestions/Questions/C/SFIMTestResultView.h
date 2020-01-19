//
//  SFIMTestResultView.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFIMTestResultView : UIView

@property (strong, nonatomic) IBOutlet UIButton *checkWrongButton;
@property (strong, nonatomic) IBOutlet UIButton *retestButton;

@property (strong, nonatomic) IBOutlet UILabel *wrongCountLabel;


@end

NS_ASSUME_NONNULL_END
