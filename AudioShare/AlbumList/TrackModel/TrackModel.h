//
//  TrackModel.h
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kPlayUrl playUrl64
#define kDloadUrl downloadUrl

@interface TrackModel : NSObject <NSCoding>

// 音频id
@property (nonatomic, copy)NSString *trackId;

// 所属专辑id
@property (nonatomic, copy)NSString *albumId;
// 音频播放地址
@property (nonatomic, copy)NSString *kPlayUrl;
// 音频下载地址
@property (nonatomic, copy)NSString *kDloadUrl;
// 声音标题
@property (nonatomic, copy)NSString *title;
// 声音播放时长 ***** 注: 格式******
@property (nonatomic, assign)CGFloat duration;
// 下载大小 ***** 注: 格式******
@property (nonatomic, assign)CGFloat downloadSize;
@property (nonatomic, assign)CGFloat lastSeconds;

// 制作者名称
@property (nonatomic, copy)NSString *nickname;

@end
