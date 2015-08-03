//
//  AudioModel.m
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"albumId"]) {
        self.albumId = [NSString stringWithFormat:@"%@", value];
    
    } else if ([key isEqualToString:@"tracksCounts"]) {
        self.tracksCounts = [NSString stringWithFormat:@"%@", value];
    } else {
        [super setValue:value forKey:key];
    }
}
@end
