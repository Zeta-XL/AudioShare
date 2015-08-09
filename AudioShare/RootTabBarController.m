//
//  RootTabBarController.m
//  
//
//  Created by lanou3g on 15/7/25.
//
//

#import "RootTabBarController.h"
#import "PlayerViewController.h"
#import "AudioBookCategoryCollectionViewController.h"
#import "RadioTableViewController.h"
#import "AudioTableViewController.h"
#import "DownloadViewController.h"
#import "FoxSettingsTableViewController.h"
#import "DataBaseHandle.h"
#import "AlbumModel.h"
#import "HistoryModel.h"

@interface RootTabBarController ()
@property (nonatomic, strong)UIButton *playButton;
@property (nonatomic, strong)UIView *buttonView;
@property (nonatomic, assign)BOOL networkOK;
@end

@implementation RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 主页面(听书)
    AudioTableViewController *homeVC = [[AudioTableViewController alloc] init];
    
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.tabBarItem.title = @"听书";
    homeNC.tabBarItem.image = [UIImage imageNamed:@"30x-Music.png"];
    homeNC.navigationBar.tintColor = [UIColor blackColor];
    [homeNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.jpg"]  forBarMetrics:(UIBarMetricsDefault)];
    
    // 直播页
    RadioTableViewController *radioVC = [[RadioTableViewController alloc] init];
    UINavigationController *radioNC = [[UINavigationController alloc] initWithRootViewController:radioVC];
    radioNC.tabBarItem.title = @"电台直播";
    radioNC.tabBarItem.image = [UIImage imageNamed:@"30x-Radio.png"];
    radioNC.navigationBar.tintColor = [UIColor blackColor];
    [radioNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.jpg"]  forBarMetrics:(UIBarMetricsDefault)];
    //    // 下载页
    //    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    //    UINavigationController *downloadNC = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    //    downloadNC.tabBarItem.title = @"下载";
    //    downloadNC.tabBarItem.image = [UIImage imageNamed:@"30x-Download.png"];
    
    FoxSettingsTableViewController *user_settingsVC = [[FoxSettingsTableViewController alloc] init];
    UINavigationController *user_settingsNC = [[UINavigationController alloc] initWithRootViewController:user_settingsVC];
    user_settingsNC.tabBarItem.title = @"我的";
    user_settingsNC.tabBarItem.image = [UIImage imageNamed:@"30x-Home.png"];
    user_settingsNC.navigationBar.tintColor = [UIColor blackColor];
    [user_settingsNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.jpg"]  forBarMetrics:(UIBarMetricsDefault)];
    self.viewControllers = @[homeNC, radioNC, user_settingsNC];
    
    [self p_setPlayButton];
    
    // 创建数据库
    [self p_createDBAndTable];
    
    
    
    
    // 反归档获得setting信息
    [self p_unarchiveData];
    
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.barStyle = UIBarMetricsDefault;

}

// 创建数据库和表
- (void)p_createDBAndTable
{
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    DLog(@"docPath----  %@",docPath);
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    // 创建表 (收藏)
    [[DataBaseHandle shareDataBase] createTableWithName:kFavorateTableName paramNames:[AlbumModel propertyNames] paramTypes:[AlbumModel propertyTypes] setPrimaryKey:YES];
    
    // 创建表 (播放历史)
    [[DataBaseHandle shareDataBase] createTableWithName:kHistoryTableName paramNames:[HistoryModel historyPropertyNames] paramTypes:[HistoryModel historyPropertyTypes] setPrimaryKey:YES];
    
    
    [[DataBaseHandle shareDataBase] closeDB];
}


// 反归档获取设置信息
- (void)p_unarchiveData
{
    NSString *cachePath = [[DataBaseHandle shareDataBase] getPathOf:Cache];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"user/data/setting"];
    
    // 获得数据
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    DLog(@"+++%@+++", dict);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dict forKey:@"defaultSetting"];
    [ud synchronize];
    
    if ([ud objectForKey:@"defaultSetting"] == nil) {
        NSDictionary *dict = @{@"defaultCategoryId":@"3", @"defaultTagName": @"恐怖悬疑"};
        [ud setObject:dict forKey:@"defaultSetting"];
        [ud synchronize];
    }

}



// 设置播放按钮
- (void)p_setPlayButton
{
    // playButton 的背景view
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tabBar.frame)-25, CGRectGetMinY(self.tabBar.frame)-50, 50, 50)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    _buttonView.layer.cornerRadius = 25;
    _buttonView.alpha = 0.5;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_buttonView addGestureRecognizer:pan];
    
    self.playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _playButton.frame = _buttonView.bounds;
    [_playButton setImage:[UIImage imageNamed:@"main_play@2x.png"] forState:(UIControlStateNormal)];
    [_playButton setTintColor:[UIColor blackColor]];
    [_buttonView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [[self.tabBar superview] addSubview:_buttonView];
}


- (void)panAction:(UIPanGestureRecognizer *)sender
{
    

    CGPoint point = [sender translationInView:sender.view];
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, 0);
    [sender setTranslation:CGPointZero inView:sender.view];
    
}



- (void)playAction:(UIButton *)sender
{
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        PlayerViewController *newVC = [PlayerViewController sharedPlayer];
        [self presentViewController:newVC animated:YES completion:^{
            // 播放声音
            
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
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
