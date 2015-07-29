//
//  RadioView.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioView.h"


@implementation RadioView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self p_setupView];
    }
    
    return self;
}

- (void)p_setupView
{
 
    self.cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _cancelButton.frame = CGRectMake(15, 30, 50, 30);
    [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [self addSubview:_cancelButton];
    
    
    self.textLabel = [[UILabel alloc]init];
    _textLabel.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame) + 15, CGRectGetMinY(_cancelButton.frame), CGRectGetWidth(self.frame) - (CGRectGetWidth(_cancelButton.frame) * 2) - 60, CGRectGetHeight(_cancelButton.frame));
    _textLabel.text = @"请选择要听的省市";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    
    
    self.determineButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _determineButton.frame = CGRectMake(CGRectGetMaxX(_textLabel.frame) + 15, CGRectGetMinY(_textLabel.frame), CGRectGetWidth(_cancelButton.frame), CGRectGetHeight(_cancelButton.frame));
    [_determineButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self addSubview:_determineButton];
    
    
    
    UIView *sp = [[UIView alloc]init];
    sp.frame = CGRectMake(0, 64, CGRectGetWidth(self.frame), 1);
    sp.backgroundColor = [UIColor blackColor];
    [self addSubview:sp];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
