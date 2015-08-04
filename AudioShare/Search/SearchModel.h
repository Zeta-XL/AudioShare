//
//  SearchModel.h
//  AudioShare
//
//  Created by lanou3g on 15/8/2.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

//图片地址
@property (nonatomic, copy)NSString *cover_path;

//专辑中声音个数
@property (nonatomic, copy)NSString *tracks;

//专辑标题
@property (nonatomic, copy)NSString *title;

//专辑类型
@property (nonatomic, copy)NSString *tags;

@property (nonatomic, copy)NSString *albumId;


@end
