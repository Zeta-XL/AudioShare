//
//  DisclaimerViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/8/12.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "DisclaimerView.h"

@interface DisclaimerViewController ()

@property (nonatomic ,strong)DisclaimerView *disclaimerVC;

@end

@implementation DisclaimerViewController

-(void)loadView
{
    self.disclaimerVC = [[DisclaimerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _disclaimerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor redColor];

}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
