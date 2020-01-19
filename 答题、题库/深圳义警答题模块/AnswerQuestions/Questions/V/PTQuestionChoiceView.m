//
//  PTTestChoiceButtonView.m
//  ProblemTest
//
//  Created by Celia on 2017/10/24.
//  Copyright © 2017年 Hopex. All rights reserved.
//

#import "PTQuestionChoiceView.h"
#import "PTQuestionChoiceButtonView.h"
#import "SFIMCollaborationModuleDefine.h"

@interface PTQuestionChoiceView () <ChoiceButtonViewDelegate>
@property (nonatomic, assign) NSInteger itemIndex;
/** 选项数据 */
@property (nonatomic, strong) NSArray *choiceData;
@end

@implementation PTQuestionChoiceView

#pragma mark - 代理协议
- (void)touchChoiceButton:(PTQuestionChoiceButtonView *)btnView {
    
    // 多选
    if (self.type == 1) {
        NSMutableArray *selectChoiceArr = [NSMutableArray array];
        for (int i = 0; i < self.choiceData.count; i++) {
            PTQuestionChoiceButtonView *tempBtnV = [self viewWithTag:1000*self.itemIndex + i];
            if (tempBtnV.status == ChoiceButtonStatusSelected) {
               NSString *choiceS = [NSString stringWithFormat:@"%C",(unichar)(tempBtnV.tag - 1000*self.itemIndex + 65)];
                [selectChoiceArr addObject:choiceS];
            }
        }
        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
            [self.delegate updateTheSelectChoice:selectChoiceArr];
        }
        
        return;
    }
    
    // 单选： 点中一个选项，将其他选项取消选中
    if (btnView.status == ChoiceButtonStatusSelected) {
        for (int i = 0; i<self.choiceData.count; i++) {
            PTQuestionChoiceButtonView *tempBtnV = [self viewWithTag:1000*self.itemIndex + i];
            if (tempBtnV != btnView) {
                tempBtnV.status = ChoiceButtonStatusNormal;
            }
        }
        
        NSString *choiceS = [NSString stringWithFormat:@"%C",(unichar)(btnView.tag - 1000*self.itemIndex + 65)];
        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
            [self.delegate updateTheSelectChoice:@[choiceS]];
        }
        
    }else {
        if ([self.delegate respondsToSelector:@selector(updateTheSelectChoice:)]) {
            [self.delegate updateTheSelectChoice:@[]];
        }
    }
    
}

#pragma mark - 数据处理
- (void)setChoiceData:(NSArray *)array index:(NSInteger)index {
    self.itemIndex = index;
    DEBUGLog(@"index -- %ld",index);
    self.choiceData = array;
    // 创建答案选项
    for (int i = 0; i<array.count; i++) {
        
        PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*index + i];
        if (!btnView) {
            PTQuestionChoiceButtonView *btnView = [[PTQuestionChoiceButtonView alloc] init];
            btnView.ChoiceType = i;
            btnView.tag = 1000*index + i;
            btnView.delegate = self;
            DEBUGLog(@"ceate -- %ld",index);
            // 选项如果 前两个包含A: B: 要移除
            NSString *choiceString = array[i];
            if ([choiceString containsString:@":"]) {
                choiceString = [choiceString substringFromIndex:2];
            }else if ([choiceString containsString:@"："]) {
                choiceString = [choiceString substringFromIndex:2];
            }
            
            btnView.choiceDesc = choiceString;
            [self addSubview:btnView];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(60 * i);
                make.left.equalTo(self).offset(20);
                make.right.equalTo(self).offset(- 20);
                make.height.mas_equalTo(44);
            }];
        } else {
            btnView.ChoiceType = i;
            // 选项如果 前两个包含A: B: 要移除
            NSString *choiceString = array[i];
            if ([choiceString containsString:@":"]) {
                choiceString = [choiceString substringFromIndex:2];
            }else if ([choiceString containsString:@"："]) {
                choiceString = [choiceString substringFromIndex:2];
            }
            
            btnView.choiceDesc = choiceString;
        }
        [btnView setSfim_cornerRadius:8.0];
    }
}

- (void)setHaveSelectChoice:(NSArray *)haveSelectChoice {
    _haveSelectChoice = haveSelectChoice;
    for (NSString *Charac in haveSelectChoice) {
        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
            NSInteger charInte = [Charac characterAtIndex:0];
            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte - 65)];
            DEBUGLog(@"select item ==== %ld",self.itemIndex);
            DEBUGLog(@"select btn ==== %@",btnView);
            if (btnView) {
                btnView.status = ChoiceButtonStatusError;
            }
        }
    }
}


- (void)updateStateWithHaveSelectChoice:(NSArray *)haveSelectChoice
                      selectResultBlock:(void (^)(BOOL reslut))selectResultBlock {
    _haveSelectChoice = haveSelectChoice;
    
    NSString *selectChoice = haveSelectChoice.firstObject;
    NSString *rightChoice = self.correctChoice.firstObject;
    BOOL isRight = [selectChoice isEqualToString:rightChoice];
    if (selectResultBlock) {
        selectResultBlock(isRight);
    }
    for (NSString *Charac in haveSelectChoice) {
        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
            NSInteger charInte = [Charac characterAtIndex:0];
            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte - 65)];
            DEBUGLog(@"select item ==== %ld",self.itemIndex);
            DEBUGLog(@"select btn ==== %@",btnView);
            if (btnView) {
                if (isRight) {
                    btnView.status = ChoiceButtonStatusCorrect;
                } else {
                    btnView.status = ChoiceButtonStatusError;
                }
            }
        }
    }
}




//- (void)setCorrectChoice:(NSArray *)correctChoice {
//    _correctChoice = correctChoice;
//    for (NSString *Charac in correctChoice) {
//        if (Charac.length > 0 && [Charac characterAtIndex:0] >=65) {
//            NSInteger charInte = [Charac characterAtIndex:0];
//            PTQuestionChoiceButtonView *btnView = [self viewWithTag:1000*self.itemIndex + (charInte - 65)];
//            if (btnView) {
//                DEBUGLog(@"correct item -- %ld",self.itemIndex);
//                DEBUGLog(@"correct btn -- %@",btnView);
//                btnView.status = ChoiceButtonStatusCorrect;
//            }
//        }
//    }
//}


@end
