//
//  RadioTableViewCell.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioTableViewCell.h"

@implementation RadioTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    

    self.radioImageView = [[UIImageView alloc]init];
    _radioImageView.frame = CGRectMake(10, 2.5, self.contentView.frame.size.height - 5, self.contentView.frame.size.height - 5);
//    _radioImageView.backgroundColor = [UIColor yellowColor];
    _radioImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _radioImageView.layer.borderWidth = 1.f;
    [self.contentView addSubview:_radioImageView];
    
    
    
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_radioImageView.frame) + 10, CGRectGetMinY(_radioImageView.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(_radioImageView.frame) - 30, (self.contentView.frame.size.height - 15) /2);
//    _nameLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_nameLabel];
    
    
    self.contentLabel = [[UILabel alloc]init];
    _contentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame)+5, CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_nameLabel.frame));
//    _contentLabel.backgroundColor = [UIColor yellowColor];
    _contentLabel.font = [UIFont systemFontOfSize:15.f];
    _contentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_contentLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _radioImageView.frame = CGRectMake(10, 2.5, self.contentView.frame.size.height - 5, self.contentView.frame.size.height - 5);
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_radioImageView.frame) + 10, CGRectGetMinY(_radioImageView.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(_radioImageView.frame) - 30, (self.contentView.frame.size.height - 15) /2);
    
    _contentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame)+5, CGRectGetWidth(_nameLabel.frame), CGRectGetHeight(_nameLabel.frame));
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
