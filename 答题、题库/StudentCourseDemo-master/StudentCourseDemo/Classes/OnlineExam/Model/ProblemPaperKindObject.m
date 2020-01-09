//
//  ProblemPaperKindObject.m
//  NewsBrowser
//
//  Created by lmj on 15-7-23.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import "ProblemPaperKindObject.h"
#import "Common.h"
#import "Config.h"
//分类显示排序存放
#define k_categoryShowPath [k_DocumentsPath stringByAppendingString:@"/categoryShowOrder.json"]
#define k_categoryShowPath2 [[NSBundle mainBundle] pathForResource:@"categoryShowOrder" ofType:@"txt"]
@implementation ProblemPaperKindObject
+(ProblemPaperKindObject *)share
{
    static ProblemPaperKindObject * _ProblemPaperKindObject_Share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ProblemPaperKindObject_Share=[[ProblemPaperKindObject alloc] init];
    });
    return _ProblemPaperKindObject_Share;
}
-(void)videoWithDict:(NSArray *)dict
{
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
     for (NSDictionary *dic in dict) {
      //   NSLog(@"videoWithDict---%@",dic[@"Name"]);
         ProblemPaperKindObject *video = [[ProblemPaperKindObject alloc] init];
         video.PRKID = [dic[@"PRKID"] intValue];
         video.ParentID = [dic[@"ParentID"] intValue];
         video.Name = dic[@"Name"];
         [categorysTemp addObject:video];
     }
   // NSLog(@"1234");
    self.indexsCategorys=[NSArray arrayWithArray:categorysTemp];
    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}
-(void)videoWithDict2:(NSArray *)dict
{
    //分类中分类!
    
    
    NSMutableArray *categorysTemp=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in dict) {
        ProblemPaperKindObject *video = [[ProblemPaperKindObject alloc] init];
        video.PRKID = [dic[@"PRKID"] intValue];
        video.ParentID = [dic[@"ParentID"] intValue];
        video.Name = dic[@"Name"];
         [categorysTemp addObject:video];
            //NSLog(@"PRKID---%@",[dic objectForKey:@"PRKID"]);
        
    }
    self.categorys=[NSArray arrayWithArray:categorysTemp];
    //显示的分类
    NSArray *categoryShowArr=[[Common readLocalString:k_categoryShowPath secondPath:k_categoryShowPath2] JSONValue];
   // NSLog(@"k_DocumentsPath---%@",k_DocumentsPath);
   // NSLog(@"categoryShowArr----%@",categoryShowArr);
    //
   // NSLog(@"categoryShowArr--%@",categoryShowArr);
    
    NSMutableArray *showTempArr=[[NSMutableArray alloc] init];
    for (int i=0; i<categoryShowArr.count; i++) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"PRKID=%@",[categoryShowArr objectAtIndex:i]];
        [showTempArr addObjectsFromArray:[self.categorys filteredArrayUsingPredicate:filter]];
    }
    self.categorysShow=[NSArray arrayWithArray:showTempArr];
  //  NSLog(@"categorysShow--%@",self.categorysShow);
    NSPredicate *filter2=[NSPredicate predicateWithFormat:@" NOT (PRKID  in %@)",categoryShowArr];
    self.categoryHide=[self.categorys filteredArrayUsingPredicate:filter2];
    
    
    //    [video setValuesForKeysWithDictionary:dict]; // KVC方法使用前提: 字典中的所有key 都能在 模型属性 中找到
    
}



-(void)initWithJson:(NSDictionary *)dict
{
    [self videoWithDict:dict];
}
@end
