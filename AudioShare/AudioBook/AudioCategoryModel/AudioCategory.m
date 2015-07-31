//
//  AudioCategory.m
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioCategory.h"

@implementation AudioCategory
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.categoryId = [NSString stringWithFormat:@"%@", value];
    } else if ([key isEqualToString:@"orderNum"]){
        self.orderNum = [NSString stringWithFormat:@"%@", value];
    } else {
        [super setValue:value forKey:key];
    }
    
}
@end
