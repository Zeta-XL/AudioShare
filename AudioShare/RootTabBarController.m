//
//  RootTabBarController.m
//  
//
//  Created by lanou3g on 15/7/25.
//
//

#import "RootTabBarController.h"
#import "PlayViewController.h"
#import "AudioBookCategoryCollectionViewController.h"

@interface RootTabBarController ()
@property (nonatomic, strong)UIButton *playButton;
@property (nonatomic, strong)UIView *buttonView;
@end

@implementation RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 主页面(听书)
//    UIViewController *homeVC = [[UIViewController alloc] init];
//    homeVC.view.backgroundColor = [UIColor greenColor];
    
    
    // CollectionFlowLayout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];

    AudioBookCategoryCollectionViewController *homeVC = [[AudioBookCategoryCollectionViewController alloc] initWithCollectionViewLayout:flow];
    
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.tabBarItem.title = @"听书";
    
    // 直播页
    UIViewController *radioVC = [[UIViewController alloc] init];
    radioVC.view.backgroundColor = [UIColor blueColor];
    UINavigationController *radioNC = [[UINavigationController alloc] initWithRootViewController:radioVC];
    radioNC.tabBarItem.title = @"电台直播";
    
    UIViewController *downloadVC = [[UIViewController alloc] init];
    downloadVC.view.backgroundColor = [UIColor redColor];
    UINavigationController *downloadNC = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    downloadNC.tabBarItem.title = @"下载";
    
    
    UIViewController *user_settingsVC = [[UIViewController alloc] init];
    user_settingsVC.view.backgroundColor = [UIColor blackColor ];
    UINavigationController *user_settingsNC = [[UINavigationController alloc] initWithRootViewController:user_settingsVC];
    user_settingsNC.tabBarItem.title = @"我的";
    
    
    self.viewControllers = @[homeNC, radioNC, downloadNC, user_settingsNC];
    
    [self p_setPlayButton];
    
    
    
    
    

}

// 设置播放按钮
- (void)p_setPlayButton
{
    // playButton 的背景view
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tabBar.frame)-25, CGRectGetMinY(self.tabBar.frame)-50, 50, 50)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    _buttonView.layer.cornerRadius = 25;
    _buttonView.alpha = 0.5;
    self.playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _playButton.frame = _buttonView.bounds;
    [_playButton setImage:[UIImage imageNamed:@"main_play@2x.png"] forState:(UIControlStateNormal)];
    [_playButton setTintColor:[UIColor blackColor]];
    [_buttonView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [[self.tabBar superview] addSubview:_buttonView];
}





- (void)playAction:(UIButton *)sender
{
    PlayViewController *newVC = [[PlayViewController alloc]init];
    newVC.view.backgroundColor = [UIColor yellowColor];
    [self presentViewController:newVC animated:YES completion:^{
        // 播放声音
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
