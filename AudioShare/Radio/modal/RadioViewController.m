//
//  RadioViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioView.h"
@interface RadioViewController ()
@property (nonatomic, strong)RadioView *radio;
@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    _cancelButton.frame = CGRectMake(20, 30, 50, 30);
//    //_cancelButton.backgroundColor = [UIColor blackColor];
//    [_cancelButton addTarget:self action:@selector(cancelButtonAciton:) forControlEvents:(UIControlEventTouchUpInside)];
//    [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
//    [self.view addSubview:_cancelButton];
//    
//    
//    self.textLabel = [[UILabel alloc]init];
//    _textLabel.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame) + 15, CGRectGetMinY(_cancelButton.frame), CGRectGetWidth(self.view.frame) - (CGRectGetWidth(_cancelButton.frame) * 2) - 60, CGRectGetHeight(_cancelButton.frame));
//    //_textLabel.backgroundColor = [UIColor blackColor];
//    _textLabel.text = @"请选择要听的省市";
//    _textLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_textLabel];
//    
//    
//    self.determineButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    _determineButton.frame = CGRectMake(CGRectGetMaxX(_textLabel.frame) + 15, CGRectGetMinY(_textLabel.frame), CGRectGetWidth(_cancelButton.frame), CGRectGetHeight(_cancelButton.frame));
//    //_determineButton.backgroundColor = [UIColor blackColor];
//    [_determineButton addTarget:self action:@selector(determineButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [_determineButton setTitle:@"确定" forState:(UIControlStateNormal)];
//    [self.view addSubview:_determineButton];
//    
//    
//    
//    UIView *sp = [[UIView alloc]init];
//    sp.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 1);
//    sp.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:sp];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.radio.cancelButton addTarget:self action:@selector(cancelButtonAciton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.radio.determineButton addTarget:self action:@selector(determineButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)loadView
{
    [super loadView];
    self.radio = [[RadioView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = _radio;
    
}


//取消模态
- (void)cancelButtonAciton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)determineButtonAction:(UIButton *)sender
{
    
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
