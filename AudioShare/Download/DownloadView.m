//
//  DownloadView.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "DownloadView.h"

@implementation DownloadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUpView];
    }
    return self;
}

- (void)p_setUpView
{
//    self.backgroundColor = [UIColor yellowColor];
    
    // 已下载
    self.dloadedView = [[UITableView alloc] init];
    _dloadedView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64 - 49);
    [self addSubview:_dloadedView];
    _dloadedView.backgroundColor = [UIColor redColor];
    
    self.dloadingView = [[UITableView alloc] init];
    _dloadingView.frame = CGRectMake(CGRectGetMaxX(_dloadedView.frame), 0, CGRectGetWidth(_dloadedView.frame), CGRectGetHeight(_dloadedView.frame));
    [self addSubview:_dloadingView];
    _dloadingView.backgroundColor = [UIColor greenColor];
    
    CGSize contentSize = _dloadedView.frame.size;
    contentSize.width *= 2;
    
    self.contentSize = contentSize;
    
    self.pagingEnabled = YES;
    self.scrollEnabled = NO;
    self.bounces = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
