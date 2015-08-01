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



@end
