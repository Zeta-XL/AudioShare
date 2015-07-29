//
//  AudioBookCategoryCollectionViewCell.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioBookCategoryCollectionViewCell.h"

@implementation AudioBookCategoryCollectionViewCell
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
    self.contentView.backgroundColor = [UIColor yellowColor];
    
    // 大分类的图片
    self.categoryImageView = [[UIImageView alloc] init];
    _categoryImageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height * 2.0 / 3);
    [self.contentView addSubview:_categoryImageView];
    _categoryImageView.backgroundColor = [UIColor grayColor];
    
    // 大分类的标题
    self.categoryTitleLabel = [[UILabel alloc] init];
    _categoryTitleLabel.frame = CGRectMake(0, CGRectGetHeight(_categoryImageView.frame), CGRectGetWidth(_categoryImageView.frame), self.contentView.bounds.size.height / 3.0);
    _categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
    _categoryTitleLabel.font = [UIFont systemFontOfSize:14.f];
    _categoryTitleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_categoryTitleLabel];
    _categoryTitleLabel.backgroundColor = [UIColor whiteColor];
    
}

@end
