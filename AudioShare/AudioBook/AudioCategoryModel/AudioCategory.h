//
//  AudioCategory.h
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioCategory : NSObject
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *orderNum;
@property (nonatomic, copy)NSString *contentType;
@property (nonatomic, copy)NSString *coverPath;
@end
