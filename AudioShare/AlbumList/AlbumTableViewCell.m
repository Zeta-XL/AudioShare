//
//  AlbumTableViewCell.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupView];
    }
    return self;
}

-(void)p_setupView
{
    //
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 50, 50)];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_titleLabel];
    
    //
    self.playTimesLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, 50, 30)];
    self.playTimesLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_playTimesLabel];
    
    //
    self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_playTimesLabel.frame) + 10, CGRectGetMinY(_playTimesLabel.frame), CGRectGetWidth(_playTimesLabel.frame), CGRectGetHeight(_playTimesLabel.frame))];
    self.commentLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_commentLabel];
    
    //
    self.optionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.optionButton.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 20, CGRectGetMinY(_commentLabel.frame) - 10, 50, 40);
    //self.loadButton.backgroundColor = [UIColor blueColor];
    [self.optionButton setTitle:@"下载" forState:(UIControlStateNormal)];
    [self.optionButton addTarget:self action:@selector(optionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:_optionButton];
    
    
    
    
}


//下载button点击事件
-(void)optionButtonAction:(UIButton *)sender
{
    DLog(@"原文下载");
}












- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
