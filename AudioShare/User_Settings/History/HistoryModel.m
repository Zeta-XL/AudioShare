//
//  HistoryModel.m
//  AudioShare
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel
+ (NSArray *)historyPropertyNames
{
    return @[@"albumId", @"albumTitle", @"trackTitle", @"currentTime", @"coverSmall", @"archiveName", @"timestamp"];
}

+ (NSArray *)historyPropertyTypes
{
    return @[@"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT"];
}

- (NSArray *)historyPropertyValues
{
    return @[_albumId, _albumTitle, _trackTitle, _currentTime, _coverSmall, _archiveName, _timestamp];
}


@end
