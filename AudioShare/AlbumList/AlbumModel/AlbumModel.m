//
//  AlbumModel.m
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"tracks"]) {
        self.tracksCount = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"albumId"]) {
        self.albumId = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"playsCounts"]) {
        self.playsCounts = [NSString stringWithFormat:@"%@", value];
    } else {
        [super setValue:value forKey:key];
    }
        
}

@end
