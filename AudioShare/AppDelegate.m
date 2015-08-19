//
//  AppDelegate.m
//  AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate () <UIAlertViewDelegate>

// 网络连接改变
- (void)reachabilityChanged: (NSNotification *)note;

// 处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach;



// timer
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation AppDelegate
- (void)dealloc
{
    [_hostReach stopNotifier];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    RootTabBarController *rootTBC = [[RootTabBarController alloc] init];
    self.window.rootViewController = rootTBC;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"switchOn"];
    [ud setBool:NO forKey:@"timerOn"];
    
    self.hostReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [_hostReach currentReachabilityStatus];
    
    switch (status) {
        case ReachableViaWiFi:
        {
            [ud setBool:YES forKey:@"networkOK"];
            break;
        }
        case ReachableViaWWAN:
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为2G/3G网络是否继续收听" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 102;
            BOOL swichOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"switchOn"];
            if (!swichOn) {
                [alertView show];
            }
            break;
        }
        case NotReachable:
        {   UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前无网络，无法加载数据" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [ud setBool:NO forKey:@"networkOK"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
            break;
        }
        default:
            break;
    }
    
    [ud synchronize];

    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:_hostReach];
    
    //开始监听,会启动一个run loop
    [_hostReach startNotifier];
    //解决偏移问题
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    // ********* 解决锁屏界面播放问题********** //
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    return YES;
}

// 锁屏界面相关
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                DLog(@"锁屏播放");
                [playerVC controlPlayAction];

                break;
            case UIEventSubtypeRemoteControlNextTrack:
                DLog(@"锁屏下一首");
                if (playerVC.currentItem.isLiveCast == NO) {
                    [playerVC controlNextAction];
                    [self setMediaInfo:playerVC.contentImageView.image andTitle:playerVC.titleString];
                }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                DLog(@"锁屏上一首");
                if (playerVC.currentItem.isLiveCast == NO) {
                    [playerVC controlPreAction];
                    [self setMediaInfo:playerVC.contentImageView.image andTitle:playerVC.titleString];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                DLog(@"锁屏暂停");
                [playerVC controlPlayAction];
            
            default:
                break;
        }
    }
}

// 设置锁屏界面显示信息
- (void)setMediaInfo:(UIImage *) img andTitle : (NSString *) title
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        
        [dict setObject:title forKey:MPMediaItemPropertyAlbumTitle];

        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:img];
        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}



- (void)reachabilityChanged: (NSNotification *)note
{
    Reachability *curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    
    if (status == ReachableViaWWAN) {
        
        DLog(@"2G/3G网络");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前为2G/3G网络是否继续收听" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        alertView.tag = 101;
        BOOL swichOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"switchOn"];
        if (!swichOn) {
            [alertView show];
        }
        
    }
    else if (status == ReachableViaWiFi)
    {
        DLog(@"当前为WiFi网络");
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:YES forKey:@"networkOK"];
        [ud synchronize];
        
    }else
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:NO forKey:@"networkOK"];
        [ud synchronize];
        DLog(@"无网络");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前无网络，无法加载数据" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
        if (playerVC.foreground) {
            if (playerVC.isPlaying) {
                [playerVC timerStopAction];
            }
            
            [playerVC dismissViewControllerAnimated:YES completion:nil];
            playerVC.foreground = NO;
        } else {
            if (playerVC.isPlaying) {
                [playerVC timerStopAction];
            }
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (alertView.tag == 101 || alertView.tag == 102 ) {
        if (buttonIndex == 0) {
            [ud setBool:NO forKey:@"networkOK"];
            [ud setBool:NO forKey:@"switchOn"];
            PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
            if (playerVC.foreground) {
                if (playerVC.isPlaying) {
                    [playerVC timerStopAction];
                }
                
                [playerVC dismissViewControllerAnimated:YES completion:nil];
                playerVC.foreground = NO;
            } else {
                if (playerVC.isPlaying) {
                    [playerVC timerStopAction];
                }
            }   
            [ud synchronize];
        } else if (buttonIndex == 1) {
            [ud setBool:YES forKey:@"networkOK"];
            [ud setBool:YES forKey:@"switchOn"];
            [ud synchronize];
        }
    }
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:nil];
    [self p_saveUserData];
    
    
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    DLog(@"playerVC--timer%@", playerVC.timer);
    // 进入后台后, player的计时器会销毁, 需重新创建计时器, 并放到子线程中, 同时启动子线程的runloop
    if (playerVC.timerTime > 0) {
        UIApplication *app = [UIApplication sharedApplication];
        self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_bgTask != UIBackgroundTaskInvalid) {
                    [app endBackgroundTask:_bgTask];
                    _bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
        
        //    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            DLog(@"timerTime---+++---%lf", playerVC.timerTime);
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:playerVC selector:@selector(timerChangeAction:) userInfo:nil repeats:YES];
            [_timer fire];
            
            // 启动runloop
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_bgTask != UIBackgroundTaskInvalid) {
                    [app endBackgroundTask:_bgTask];
                    _bgTask = UIBackgroundTaskInvalid;
                    DLog(@"timer++++++++++");
                }
            });
        });
    }
    
    // **********进入后台后, 锁屏播放器设置********** //
//    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    if (playerVC.contentImageView.image && playerVC.titleString.length > 0) {
        [self setMediaInfo:playerVC.contentImageView.image andTitle:playerVC.titleString];
    }
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 后台机试器未销毁, 再程序进入前台后, 赋给player
    if (self.timer) {
        [PlayerViewController sharedPlayer].timer = self.timer;
        self.timer = nil;
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    if (playerVC.isPlaying) {
        if (playerVC.foreground) {
            [playerVC.player play];
        }     
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self p_saveUserData];
    
}

- (void)p_saveUserData
{
    // cache路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    DLog(@"%@", cachePath);
    // 用户数据路径
    NSString *userDataPath = [cachePath stringByAppendingPathComponent:@"/user/data"];
    
    NSError *error = nil;
    // 判断是否存在文件夹
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:userDataPath];
    
    // 创建文件夹
    if (!exist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDataPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!error) {
            DLog(@"errorLog---%@", error);
        }
    }
    
    // 归档数据
    
    NSUInteger lastIndex = [PlayerViewController sharedPlayer].currentIndex;
    NSArray *tracksList = [PlayerViewController sharedPlayer].tracksList;
    CMTime currentTime = [[PlayerViewController sharedPlayer].player.currentItem currentTime];
    CGFloat lastSeconds = CMTimeGetSeconds(currentTime);
    NSString *lastLiveUrl = [PlayerViewController sharedPlayer].lastLiveUrl;
    NSString *imageUrl = [PlayerViewController sharedPlayer].imageUrl;
    DLog(@"index--%lu  trackList--%@  lastSeconds--%lf", lastIndex, tracksList, lastSeconds);
    //-------------------------上次播放的索引---------------上次播放的时间-------------------播放列表-----//
    if (tracksList) {
        NSDictionary *dataDict = @{@"lastIndex":@(lastIndex), @"lastSeconds":@(lastSeconds), @"trackList":tracksList, @"imageUrl":imageUrl};
        NSString *localListPath = [userDataPath stringByAppendingPathComponent:@"trackListInfo"];
        
        // 开始归档
        [NSKeyedArchiver archiveRootObject:dataDict toFile:localListPath];
    } else if (lastLiveUrl) { // 记录直播
        
        // 删除trackListInfo
        [[NSFileManager defaultManager] removeItemAtPath:[userDataPath stringByAppendingPathComponent:@"trackListInfo"] error:&error];
        if (!error) {
            DLog(@"%@", error);
        }
        NSString *titleString = [PlayerViewController sharedPlayer].titleString;
        NSDictionary *dataDict = @{@"imageUrl":imageUrl, @"title":titleString, @"lastLiveUrl":lastLiveUrl};
        NSString *localListPath = [userDataPath stringByAppendingPathComponent:@"radioInfo"];
        [NSKeyedArchiver archiveRootObject:dataDict toFile:localListPath];
    }
    // 归档设置信息
    NSString *localSettingPath = [userDataPath stringByAppendingPathComponent:@"setting"];
    NSUserDefaults *ud =  [NSUserDefaults standardUserDefaults];
    NSDictionary *settngDict = [ud objectForKey:@"defaultSetting"];
    [NSKeyedArchiver archiveRootObject:settngDict toFile:localSettingPath];
    
    if ([PlayerViewController sharedPlayer].timer) {
        [[PlayerViewController sharedPlayer].timer invalidate];
        [PlayerViewController sharedPlayer].timer = nil;
    }
}



@end
