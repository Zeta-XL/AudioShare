//
//  PlayerViewController.h
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SpecialItem.h"
#import "API_URL.h"


@interface PlayerViewController : UIViewController

// player 相关

@property (nonatomic, assign)NSUInteger currentIndex;
@property (nonatomic, assign)BOOL isPlaying;

@property (nonatomic, strong)AVPlayer *player; //
@property (nonatomic, copy)NSString *urlString;

@property (nonatomic, assign)CGFloat totalSeconds; // 播放总时长
@property (nonatomic, assign)CGFloat currentSeconds; // 当前播放时间


// UI控件
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 标题
@property (weak, nonatomic) IBOutlet UILabel *timeGoingLabel; // 播放的时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel; // 总时间
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView; // 图片

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *titleString;
// 上次播放时间
@property (nonatomic, assign)CGFloat lastSeconds;
// 是否示后台播放
@property (nonatomic, assign)BOOL background;
// 数据
@property (nonatomic, assign)BOOL historyFlag;


// 在线点播(挺熟)
@property (nonatomic, strong)NSMutableArray *tracksList;
@property (nonatomic, copy)NSString *albumId;



// 在线直播radio -live
@property (nonatomic, copy)NSString *liveStartTime;
@property (nonatomic, copy)NSString *liveEndTime;
// 上一次直播的URL
@property (nonatomic, copy)NSString *lastLiveUrl;


// 根据UrlString初始化播放项目
- (SpecialItem *)createPlayerItemWithURLString:(NSString *)urlString;
+ (instancetype)sharedPlayer;
- (void)releasePlayer;
- (void)p_saveCurrentAlbumInfo;
@end
