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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.frame) - 40, (self.bounds.size.height - 30) /4)];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.text = @"测试";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    //
    CGFloat height = CGRectGetHeight(_titleLabel.frame) * 2.5;
    
    self.albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10, height, height)];
//    self.albumImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_albumImageView];
    
    
    //
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_albumImageView.frame) + 10, CGRectGetMinY(_albumImageView.frame), CGRectGetWidth(self.frame) - CGRectGetWidth(_albumImageView.frame) - 30, height / 4)];
//    self.writerLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_writerLabel];
    
    //
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_writerLabel.frame), CGRectGetMaxY(_writerLabel.frame) + 10, CGRectGetWidth(_writerLabel.frame), CGRectGetHeight(_writerLabel.frame))];
//    self.detailLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_detailLabel];
    
    
    //
    self.collectionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.collectionButton.frame = CGRectMake(CGRectGetMinX(_detailLabel.frame), CGRectGetMaxY(_detailLabel.frame) + 15, (CGRectGetWidth(self.frame) - CGRectGetWidth(_albumImageView.frame) - 40) / 2, CGRectGetHeight(_detailLabel.frame));
    [self.collectionButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    [self.collectionButton addTarget:self action:@selector(collectionButtonAction : ) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_collectionButton];
    
    //
    self.loadButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.loadButton.frame = CGRectMake(CGRectGetMaxX(_collectionButton.frame) + 10, CGRectGetMinY(_collectionButton.frame), CGRectGetWidth(_collectionButton.frame), CGRectGetHeight(_collectionButton.frame));
    [self.loadButton setTitle:@"批量下载" forState:(UIControlStateNormal)];
    [self.loadButton addTarget:self action:@selector(MultiDownloadButtonAction: ) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_loadButton];
    
    
}

//collectionButton点击事件
-(void)collectionButtonAction : (UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickCollectionButton:)]) {
        [self.delegate onClickCollectionButton:sender];
    }
    DLog(@"收藏");
}

//loadButtonAction点击事件
-(void)MultiDownloadButtonAction: (UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDownloadButton:)]) {
        [self.delegate onClickDownloadButton:sender];
    }
    DLog(@"批量下载");
}







@end
