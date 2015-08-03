//
//  SuggestionCollectionViewCell.m
//  AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SuggestionCollectionViewCell.h"

@implementation SuggestionCollectionViewCell
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 专辑图片
    self.albumImageView = [[UIImageView alloc] init];
    _albumImageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height * 0.66);
    [self.contentView addSubview:_albumImageView];
//    _albumImageView.backgroundColor = [UIColor grayColor];
    
    
    // 专辑名
    self.albumTitleLabel = [[UILabel alloc] init];
    _albumTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(_albumImageView.frame), CGRectGetWidth(_albumImageView.frame) * 0.75, self.contentView.bounds.size.height * 0.34);
    _albumTitleLabel.textAlignment = NSTextAlignmentCenter;
    _albumTitleLabel.font = [UIFont systemFontOfSize:15.f];
    _albumTitleLabel.numberOfLines = 2;
    [self.contentView addSubview:_albumTitleLabel];
//    _albumTitleLabel.backgroundColor = [UIColor greenColor];
    
    
    // 专辑声音个数
    self.tracksCountsLabel = [[UILabel alloc] init];
    _tracksCountsLabel.frame = CGRectMake(CGRectGetMaxX(_albumTitleLabel.frame), CGRectGetMinY(_albumTitleLabel.frame), self.contentView.bounds.size.width *0.25, CGRectGetHeight(_albumTitleLabel.frame));
    _tracksCountsLabel.textAlignment = NSTextAlignmentCenter;
    _tracksCountsLabel.font = [UIFont systemFontOfSize:14.f];
    _tracksCountsLabel.numberOfLines = 3;
    _tracksCountsLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_tracksCountsLabel];
//     _tracksCountsLabel.backgroundColor = [UIColor blueColor];

}
@end
