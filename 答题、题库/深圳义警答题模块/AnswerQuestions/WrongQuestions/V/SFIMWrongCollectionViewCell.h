//
//  SFIMWrongCollectionViewCell.h
//  SFIMCollaborationModule
//
//  Created by gzc on 2020/1/13.
//

#import <UIKit/UIKit.h>
#import "SFIMTestWrongModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SFIMWrongCollectionViewCell;
@protocol SFIMWrongCollectionViewCellDelegate <NSObject>

/** 上一题 */
- (void)sfimQuestionCellTapLastQuestion:(SFIMWrongCollectionViewCell *)cell;
/** 下一题 */
- (void)sfimQuestionCellTapNextQuestion:(SFIMWrongCollectionViewCell *)cell;
/** 更新选中的选项数据 */
- (void)sfimQuestionCellUpdateSelectChoices:(NSArray *)choiceArray cell:(SFIMWrongCollectionViewCell *)cell;

@end

@interface SFIMWrongCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, strong) SFIMTestWrongModel *model;

/** 第一个 没有上一题按钮 */
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL isTheLast;

/** 代理 */
@property (nonatomic, weak) id <SFIMWrongCollectionViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
