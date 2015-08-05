//
//  HistoryModel.h
//  AudioShare
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
@property (nonatomic, copy)NSString *albumId; // primary key
@property (nonatomic, copy)NSString *albumTitle;
@property (nonatomic, copy)NSString *trackTitle;
@property (nonatomic, copy)NSString *currentTime;
@property (nonatomic, copy)NSString *coverSmall; // 图片地址
@property (nonatomic, copy)NSString *archiveName;
@property (nonatomic, copy)NSString *timestamp;

+ (NSArray *)historyPropertyNames;
+ (NSArray *)historyPropertyTypes;
- (NSArray *)historyPropertyValues;

@end
