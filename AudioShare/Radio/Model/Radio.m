//
//  Radio.m
//  AudioShare
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "Radio.h"
#import "RequestTool_v2.h"
@implementation Radio

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"radioPlayUrl"]) {
        self.radioPlayUrl = value[@"radio_24_aac"];
    } else {
        [super setValue:value forKey:key];
    }
}
@end
