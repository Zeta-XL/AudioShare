//
//  RequestTool_v2.h
//  Request
//
//  Created by lanou3g on 15/7/20.
//  Copyright (c) 2015年 zhaoxinlei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^callBackData)(NSData *data);

@interface RequestTool_v2 : NSObject
+(void)requestWithURL:(NSString *)urlStr
          paramString:(NSString *)params
          postRequest:(BOOL)flag
         callBackData:(callBackData)cb;

@end
