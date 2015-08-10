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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 100, self.contentView.bounds.size.height * 0.5)];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_titleLabel];
    
    //
    self.playTimesLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), 80, CGRectGetHeight(_titleLabel.frame) * 0.5)];
//    self.playTimesLabel.backgroundColor = [UIColor blueColor];
    _playTimesLabel.adjustsFontSizeToFitWidth = YES;
    _playTimesLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_playTimesLabel];
    
    //
    self.commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_playTimesLabel.frame) + 10, CGRectGetMinY(_playTimesLabel.frame), CGRectGetWidth(_playTimesLabel.frame)*2, CGRectGetHeight(_playTimesLabel.frame))];
//    self.commentLabel.backgroundColor = [UIColor blueColor];
    self.commentLabel.font = [UIFont systemFontOfSize:13.f];
    
    [self.contentView addSubview:_commentLabel];
    
    //
//    self.optionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    self.optionButton.frame = CGRectMake(self.contentView.bounds.size.width - 50 - 10, CGRectGetMinY(_commentLabel.frame) - 10, 50, 40);
    
//    [self.optionButton setTitle:@"下载" forState:(UIControlStateNormal)];
//    [self.optionButton addTarget:self action:@selector(optionButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.contentView addSubview:_optionButton];
    
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 50, self.contentView.bounds.size.height * 0.5);
    _playTimesLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), 60, CGRectGetHeight(_titleLabel.frame) * 0.5);
    _commentLabel.frame = CGRectMake(CGRectGetMaxX(_playTimesLabel.frame) + 10, CGRectGetMinY(_playTimesLabel.frame), CGRectGetWidth(_playTimesLabel.frame)*2, CGRectGetHeight(_playTimesLabel.frame));
//    _optionButton.frame = CGRectMake(self.contentView.bounds.size.width - 50 - 10, CGRectGetMinY(_commentLabel.frame) - 10, 60, 40);
}














- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
