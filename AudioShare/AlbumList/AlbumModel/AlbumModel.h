//
//  AlbumModel.h
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject
// 专辑Id
@property (nonatomic, copy)NSString *albumId;

// 专辑名
@property (nonatomic, copy)NSString *title;

// 所属专辑类型
@property (nonatomic, copy)NSString *categoryName;

// 专辑图片大
@property (nonatomic, copy)NSString *coverLarge;

// 专辑图片小
@property (nonatomic, copy)NSString *coverSmall;

// 原始图片
@property (nonatomic, copy)NSString *coverOrigin;

// 作者 /-----未使用-----/
@property (nonatomic, copy)NSString *nickname;

// 简介
@property (nonatomic, copy)NSString *intro;

// 专辑类型
@property (nonatomic, copy)NSString *tags;

//播放次数 //--未使用--//
@property (nonatomic, copy)NSString *playsCounts;

// 声音个数
@property (nonatomic, copy)NSString *tracksCount;

+ (NSArray *)propertyNames;
+ (NSArray *)propertyTypes;
- (NSArray *)albumInfoValue;

@end
