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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    RootTabBarController *rootTBC = [[RootTabBarController alloc] init];
    self.window.rootViewController = rootTBC;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // cache路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    DLog(@"%@", cachePath);
    // 用户数据路径
    NSString *userDataPath = [cachePath stringByAppendingPathComponent:@"/user/data"];
   
    NSError *error = nil;
    // 创建文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:userDataPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!error) {
        DLog(@"errorLog---%@", error);
    }
    
    // 归档数据
    
    NSInteger lastIndex = [PlayerViewController sharedPlayer].currentIndex;
    NSArray *tracksList = [PlayerViewController sharedPlayer].tracksList;
    CMTime currentTime = [[PlayerViewController sharedPlayer].player.currentItem currentTime];
    CGFloat lastSeconds = CMTimeGetSeconds(currentTime);
    NSString *lastLiveUrl = [PlayerViewController sharedPlayer].lastLiveUrl;
    NSString *imageUrl = [PlayerViewController sharedPlayer].imageUrl;
    DLog(@"index--%ld  trackList--%@  lastSeconds--%lf", lastIndex, tracksList, lastSeconds);
    //-------------------------上次播放的索引---------------上次播放的时间-------------------播放列表-----//
    if (tracksList) {
        NSDictionary *dataDict = @{@"lastIndex":@(lastIndex), @"lastSeconds":@(lastSeconds), @"trackList":tracksList, @"imageUrl":imageUrl};
        NSString *localListPath = [userDataPath stringByAppendingPathComponent:@"trackListInfo"];
        
        // 开始归档
        [NSKeyedArchiver archiveRootObject:dataDict toFile:localListPath];
    } else if (lastLiveUrl) { // 直播
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
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    [[PlayerViewController sharedPlayer] releasePlayer];
}

@end
