//
//  SubjectCell.h
//  YWK
//
//  Created by 杨伟康 on 2017/5/19.
//  Copyright © 2017年 ywk. All rights reserved.
//

#import "BaseCell.h"

@interface SubjectCell : BaseCell


-(void)fillWithTitle:(NSString *)title index:(NSInteger)index;

-(void)isRightWithIndex:(NSInteger)index;

-(void)isWrong;
@end
