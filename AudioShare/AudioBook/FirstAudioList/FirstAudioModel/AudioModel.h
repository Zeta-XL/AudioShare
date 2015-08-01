//
//  AudioModel.h
//  AudioShare
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject
//专辑图片地址
@property (nonatomic, copy)NSString *coverMiddle;

//专辑标题
@property (nonatomic, copy)NSString *title;

//专辑类型
@property (nonatomic, copy)NSString *tags;

//专辑中声音个数
@property (nonatomic, copy)NSString *tracksCounts;

@property (nonatomic, copy)NSString *albumId;
@end
