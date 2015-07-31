//
//  RequestTool_v2.m
//  Request
//
//  Created by lanou3g on 15/7/20.
//  Copyright (c) 2015年 zhaoxinlei. All rights reserved.
//

#import "RequestTool_v2.h"

@implementation RequestTool_v2
+(void)requestWithURL:(NSString *)urlStr
          paramString:(NSString *)params
          postRequest:(BOOL)flag
         callBackData:(callBackData)cb
{
   
    NSString *utf8String = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = nil;
    NSMutableURLRequest *request = nil;
    if (!flag) {
        NSString *urlString = nil;
        if (params) {
            urlString = [@[urlStr, utf8String] componentsJoinedByString:@"?"];
        }else{
            urlString = urlStr;
        }
        
        url = [NSURL URLWithString:urlString];
        NSLog(@"%@", url);
        request = [NSMutableURLRequest requestWithURL:url];
        
    }else{
        url = [NSURL URLWithString:urlStr];
        request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [utf8String dataUsingEncoding:NSUTF8StringEncoding];
        
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            cb(data);
        }else {
            NSLog(@"连接错误");
        }
        
    }];
    
}

@end
