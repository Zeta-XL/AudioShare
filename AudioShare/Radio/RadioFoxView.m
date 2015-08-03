//
//  RadioFoxView.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioFoxView.h"

@implementation RadioFoxView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self p_setupView];
    }
    
    return self;
}

- (void)p_setupView
{
     self.backgroundColor = [UIColor whiteColor];

    self.networkButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _networkButton.frame = CGRectMake(15, 30, CGRectGetWidth(self.bounds) / 3 - 20 , 50);
    [_networkButton setTitle:@"网络电台" forState:(UIControlStateNormal)];
    _networkButton.backgroundColor = [UIColor  yellowColor];
    [self addSubview:_networkButton];
    
    
    self.countriesButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _countriesButton.frame = CGRectMake(CGRectGetMaxX(_networkButton.frame) + 15, CGRectGetMinY(_networkButton.frame), CGRectGetWidth(_networkButton.frame), CGRectGetHeight(_networkButton.frame));
    [_countriesButton setTitle:@"国家电台" forState:(UIControlStateNormal)];
    _countriesButton.backgroundColor = [UIColor yellowColor];
    [self addSubview:_countriesButton];
    
    
    
    self.provinceButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _provinceButton.frame =  CGRectMake(CGRectGetMaxX(_countriesButton.frame) + 15, CGRectGetMinY(_countriesButton.frame), CGRectGetWidth(_countriesButton.frame), CGRectGetHeight(_countriesButton.frame));
    [_provinceButton setTitle:@"省市电台" forState:(UIControlStateNormal)];
    _provinceButton.backgroundColor = [UIColor yellowColor];
    [self addSubview:_provinceButton];
    
    
    self.foxLabel = [[UILabel alloc]init];
    _foxLabel.frame = CGRectMake(CGRectGetMinX(_countriesButton.frame), CGRectGetMaxY(_countriesButton.frame)+15 , CGRectGetWidth(_countriesButton.frame), 30);
    _foxLabel.text = @"电台列表";
    _foxLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_foxLabel];
    
}

- (void)layoutSubviews
{
    _networkButton.frame = CGRectMake(15, 30, CGRectGetWidth(self.bounds) / 3 - 20 , 50);
    _countriesButton.frame = CGRectMake(CGRectGetMaxX(_networkButton.frame) + 15, CGRectGetMinY(_networkButton.frame), CGRectGetWidth(_networkButton.frame), CGRectGetHeight(_networkButton.frame));
    _provinceButton.frame =  CGRectMake(CGRectGetMaxX(_countriesButton.frame) + 15, CGRectGetMinY(_countriesButton.frame), CGRectGetWidth(_countriesButton.frame), CGRectGetHeight(_countriesButton.frame));
    _foxLabel.frame = CGRectMake(CGRectGetMinX(_countriesButton.frame), CGRectGetMaxY(_countriesButton.frame)+15 , CGRectGetWidth(_countriesButton.frame), 30);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
