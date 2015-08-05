//
//  TrackModel.m
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "TrackModel.h"

@implementation TrackModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"trackId"]) {
        self.trackId = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"albumId"]) {
        self.albumId = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"duration"]) {
        self.duration = [value doubleValue];
    } else if ([key isEqualToString:@"downloadSize"]) {
        self.downloadSize = [value doubleValue];
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 对编码的属性标记
    [aCoder encodeObject:_trackId forKey:@"trackId"];
    [aCoder encodeObject:_albumId forKey:@"albumId"];
    [aCoder encodeObject:_playUrl64 forKey:@"playUrl"];
    [aCoder encodeObject:_downloadUrl forKey:@"downloadUrl"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_albumTitle forKey:@"albumTitle"];
    [aCoder encodeDouble:_duration forKey:@"duration"];
    [aCoder encodeDouble:_downloadSize forKey:@"downloadSize"];
    [aCoder encodeDouble:_lastSeconds forKey:@"lastSeconds"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_coverMiddle forKey:@"coverMiddle"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.trackId = [aDecoder decodeObjectForKey:@"trackId"];
        self.albumId = [aDecoder decodeObjectForKey:@"albumId"];
        self.playUrl64 = [aDecoder decodeObjectForKey:@"playUrl"];
        self.downloadUrl = [aDecoder decodeObjectForKey:@"downloadUrl"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.albumTitle = [aDecoder decodeObjectForKey:@"albumTitle"];
        self.duration = [aDecoder decodeDoubleForKey:@"duration"];
        self.downloadSize = [aDecoder decodeDoubleForKey:@"downloadSize"];
        self.lastSeconds = [aDecoder decodeDoubleForKey:@"lastSeconds"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.coverMiddle = [aDecoder decodeObjectForKey:@"coverMiddle"];
    }
    
    return self;
}

@end
