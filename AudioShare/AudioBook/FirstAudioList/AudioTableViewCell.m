//
//  AudioTableViewCell.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioTableViewCell.h"

@implementation AudioTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupView];
    }
    return self;
}


- (void)p_setupView
{
    //
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.contentView.bounds.size.height - 20, self.contentView.bounds.size.height - 20)];
//    self.myImageView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_myImageView];
    
    //
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_myImageView.frame) + 10, 10, CGRectGetWidth(self.frame) - CGRectGetWidth(_myImageView.frame) - 30, (self.contentView.bounds.size.height - 40) / 3)];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    //self.titleLabel.text = @"是的呀";
    
    //自动调整放置文字位置的大小
    [self.contentView addSubview:_titleLabel];
    
    //
    self.tagsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, 130, CGRectGetHeight(_titleLabel.frame))];
//    self.tagsLabel.backgroundColor = [UIColor blueColor];
    
    //自动调整放置文字位置的大小
    self.tagsLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_tagsLabel];
    
    //
    self.tracksCountsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_tagsLabel.frame), CGRectGetMaxY(_tagsLabel.frame) + 10, 50, CGRectGetHeight(_tagsLabel.frame))];
//    self.tracksCountsLabel.backgroundColor = [UIColor blueColor];
    
    //自动调整放置文字位置的大小
    self.tracksCountsLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_tracksCountsLabel];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _myImageView.frame = CGRectMake(10, 10, self.contentView.bounds.size.height - 20, self.contentView.bounds.size.height - 20);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_myImageView.frame) + 10, 10, CGRectGetWidth(self.frame) - CGRectGetWidth(_myImageView.frame) - 30, (self.contentView.bounds.size.height - 40) / 3);
    _tagsLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, 130, CGRectGetHeight(_titleLabel.frame));
    _tracksCountsLabel.frame = CGRectMake(CGRectGetMinX(_tagsLabel.frame), CGRectGetMaxY(_tagsLabel.frame) + 10, 50, CGRectGetHeight(_tagsLabel.frame));
    
}





















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
