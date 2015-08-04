//
//  SearchModel.m
//  AudioShare
//
//  Created by lanou3g on 15/8/2.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


//因albumId和接口文件id重名，重写albumId方法
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.albumId = [NSString stringWithFormat:@"%@", value];
    } else {
        [super setValue:value forKey:key];
    }
}



@end
