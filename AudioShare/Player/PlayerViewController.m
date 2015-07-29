//
//  PlayerViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *autoShutdown;
@property (weak, nonatomic) IBOutlet UILabel *timeGoingLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeGoingSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *preButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@end

@implementation PlayerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

#pragma mark --- button响应事件
// 返回
- (IBAction)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        DLog(@"退出播放器");
    }];
}

// 定时关闭(暂停)
- (IBAction)autoShutdownAction:(UIButton *)sender
{
    
    DLog(@"定时关闭");
}

// slider进度条
- (IBAction)timeSliderAction:(UISlider *)sender
{
    
}

// 播放按键
- (IBAction)playAction:(UIButton *)sender {
}

// 上一首
- (IBAction)preButtonAction:(UIButton *)sender {
}


// 下一首
- (IBAction)nextButtonAction:(UIButton *)sender {
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
