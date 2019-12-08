//
//  ViewController.m
//  Demo
//
//  Created by 李林 on 17/3/24.
//  Copyright © 2017年 lhtx. All rights reserved.
//

#import "ViewController.h"
#import "InputText.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UITextView *textV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textF.maxTextLength = 5;
    self.textF.placeHolderColor = [UIColor blueColor];

    
    self.textV.textContainerInset = UIEdgeInsetsMake(50, 0, 0, 0);
    self.textV.maxTextLength = 1000;
    self.textV.placeHolderColor = [UIColor redColor];
    self.textV.placeholder = @"fawefaw";
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.textF.placeholder  = @"123";
}





@end
