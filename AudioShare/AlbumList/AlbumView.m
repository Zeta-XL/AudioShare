//
//  AlbumView.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
        
    }
    return self;
}

//布局视图
-(void)p_setupView
{
    //
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 150, 150)];
    self.myImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_myImageView];
    
    //
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.frame) - 40, 40)];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.titleLabel.text = @"测试";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_myImageView.frame) + 10, CGRectGetMinY(_myImageView.frame), CGRectGetWidth(self.frame) - CGRectGetWidth(_myImageView.frame) - 30, 40)];
    self.writerLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_writerLabel];
    
    //
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_writerLabel.frame), CGRectGetMaxY(_writerLabel.frame) + 10, CGRectGetWidth(_writerLabel.frame), CGRectGetHeight(_writerLabel.frame))];
    self.detailLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_detailLabel];
    
    //
    self.collectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_detailLabel.frame), CGRectGetMaxY(_detailLabel.frame) + 15, 75, CGRectGetHeight(_detailLabel.frame))];
    //self.collectionLabel.backgroundColor = [UIColor blueColor];
    //self.collectionLabel.text = @"收藏";
    //self.collectionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_collectionLabel];
    
    //
    self.loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_collectionLabel.frame) + 10, CGRectGetMinY(_collectionLabel.frame), CGRectGetWidth(_collectionLabel.frame), CGRectGetHeight(_collectionLabel.frame))];
    //self.loadLabel.backgroundColor = [UIColor blueColor];
    //self.loadLabel.text = @"下载";
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_loadLabel];
    
    //
    self.collectionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.collectionButton.frame = self.collectionLabel.frame;
    [self.collectionButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    [self.collectionButton addTarget:self action:@selector(collectionButtonAction : ) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_collectionButton];
    
    //
    self.loadButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.loadButton.frame = self.loadLabel.frame;
    [self.loadButton setTitle:@"批量下载" forState:(UIControlStateNormal)];
    [self.loadButton addTarget:self action:@selector(loadButtonAction : ) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_loadButton];
    
    
}

//collectionButton点击事件
-(void)collectionButtonAction : (UIButton *)sender
{
    DLog(@"收藏");
}

//loadButtonAction点击事件
-(void)loadButtonAction : (UIButton *)sender
{
    DLog(@"批量下载");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}





@end
