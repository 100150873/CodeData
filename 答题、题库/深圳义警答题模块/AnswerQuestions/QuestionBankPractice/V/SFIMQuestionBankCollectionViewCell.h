//
//  SFIMQuestionBankCollectionViewCell.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/15.
//

#import <UIKit/UIKit.h>

#import "SFIMTestWrongModel.h"

NS_ASSUME_NONNULL_BEGIN


@class SFIMQuestionBankCollectionViewCell;
@protocol SFIMQuestionBankCollectionViewCellDelegate <NSObject>

/** 下一题 */
- (void)sfimQuestionBankCellTapNextQuestion:(SFIMQuestionBankCollectionViewCell *)cell;


@end

@interface SFIMQuestionBankCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, strong) SFIMTestWrongModel *model;

@property (nonatomic, assign) BOOL isTheLast;

/** 代理 */
@property (nonatomic, weak) id <SFIMQuestionBankCollectionViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
