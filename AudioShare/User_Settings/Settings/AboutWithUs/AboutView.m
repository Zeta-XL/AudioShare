//
//  aboutView.m
//  AudioShare
//
//  Created by lanou3g on 15/8/12.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "aboutView.h"

@implementation AboutView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
        
    }
    return self;
}

-(void)p_setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    //
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) / 2 - 50, 10, 100, 100)];
    self.myImageView.backgroundColor = [UIColor blueColor];
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.image = [UIImage imageNamed:@"icon"];
    [self addSubview:_myImageView];
    
    //
    self.myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_myImageView.frame) - 20, CGRectGetMaxY(_myImageView.frame) + 10, CGRectGetWidth(_myImageView.frame) + 40, 30)];
    //self.myTitleLabel.backgroundColor = [UIColor blueColor];
    self.myTitleLabel.text = @"听书奇谈 V1.0";
    self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_myTitleLabel];
    
    //
    self.editionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_myTitleLabel.frame) - 50, CGRectGetMaxY(_myTitleLabel.frame), CGRectGetWidth(_myImageView.frame), CGRectGetHeight(_myTitleLabel.frame))];
    //self.editionLabel.backgroundColor = [UIColor blueColor];
    self.editionLabel.text = @"联系我们 :";
    self.editionLabel.textAlignment = NSTextAlignmentLeft;
    self.editionLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_editionLabel];
    
    //
    self.mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_editionLabel.frame), CGRectGetMaxY(_editionLabel.frame), CGRectGetWidth(_myTitleLabel.frame) + 100, CGRectGetHeight(_myTitleLabel.frame))];
    //self.mainLabel.backgroundColor = [UIColor blueColor];
    self.mainLabel.text = @"邮箱 : fengzhixinlei@Foxmail.com";
    self.mainLabel.textAlignment = NSTextAlignmentLeft;
    self.mainLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_mainLabel];
    
    //
    self.withUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mainLabel.frame), CGRectGetMaxY(_mainLabel.frame), CGRectGetWidth(_mainLabel.frame) + 20, CGRectGetHeight(_mainLabel.frame))];
    //self.withUsLabel.backgroundColor = [UIColor blueColor];
    self.withUsLabel.text = @"Copyright(c)2015年DLZ.All rights reserved.";
    self.withUsLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_withUsLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
