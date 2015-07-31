//
//  AlbumModel.h
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject
//专辑名
@property (nonatomic, copy)NSString *title;

//专辑简介
@property (nonatomic, copy)NSString *coverLarge;

//作者
@property (nonatomic, copy)NSString *nickname;

//图片
@property (nonatomic, copy)NSString *coverOrigin;

//标题
@property (nonatomic, copy)NSString *albumTitle;

//播放时长
@property (nonatomic, copy)NSString *play_time;

//播放次数
@property (nonatomic, copy)NSString *playtimes;
@end
