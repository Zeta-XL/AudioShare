//
//  Radio.h
//  AudioShare
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Radio : NSObject

@property (nonatomic, copy)NSString *rname; //电台名称

@property (nonatomic, copy)NSString *radioCoverSmall; //广播图片

@property (nonatomic, copy)NSString *programName; //当前节目名称

@property (nonatomic, strong)UIImage *radioImage; //解析后存储图片

@property (nonatomic, copy)NSString *radioPlayUrl;
@end
