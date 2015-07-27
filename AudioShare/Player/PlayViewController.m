//
//  PlayViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/26.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
@property (nonatomic, strong)UIButton *backButton;
@end

@implementation PlayViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _backButton.frame = CGRectMake(5, 25, 80, 40);
    _backButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [_backButton setTitle:@"返回" forState:(UIControlStateNormal)];
    _backButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backButton];
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)didReceiveMemoryWarning
{
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
