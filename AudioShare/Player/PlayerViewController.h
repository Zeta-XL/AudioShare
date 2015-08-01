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
@property (nonatomic, copy) NSString *titleString;
@property (weak, nonatomic) IBOutlet UILabel *timeGoingLabel; // 播放的时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel; // 总时间
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView; // 图片
@property (nonatomic, copy) NSString *imageUrl;



// 数据

@property (nonatomic, strong)NSMutableArray *tracksList;

// radio-live
@property (nonatomic, copy)NSString *liveStartTime;
@property (nonatomic, copy)NSString *liveEndTime;


// 根据UrlString初始化播放项目
- (SpecialItem *)createPlayerItemWithURLString:(NSString *)urlString;
+ (instancetype)sharedPlayer;

@end
