//
//  Album——ListView.m
//  AudioShare
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "Album_ListView.h"


@implementation Album_ListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
        
    }
    return self;
}


- (void)p_setupView
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    
    //self.myScrollView.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:_myScrollView];
    
    
    //
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.frame) - 40, 30)];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [_myScrollView addSubview:_titleLabel];
    
    //
    self.writerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, CGRectGetWidth(_titleLabel.frame) , CGRectGetHeight(_titleLabel.frame))];
//    self.writerLabel.backgroundColor = [UIColor blueColor];
    [_myScrollView addSubview:_writerLabel];
    
    //
    self.discriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_writerLabel.frame) + 10, CGRectGetWidth(self.frame) - 40, 0)];
    
    self.discriptionLabel.numberOfLines = 0;
    self.discriptionLabel.font = [UIFont systemFontOfSize:17.f];
    self.discriptionLabel.textAlignment = NSTextAlignmentNatural;
    
//    self.discriptionLabel.backgroundColor = [UIColor blueColor];
    
    [_myScrollView addSubview:_discriptionLabel];

    
}

- (void)setupContentSize
{
    if (_delegate && [_delegate respondsToSelector:@selector(tellTextHeight)]) {
        CGFloat height = 100 + [self.delegate tellTextHeight];
        
        
        CGRect temp = _discriptionLabel.frame;
        temp.size.height = [self.delegate tellTextHeight];
        _discriptionLabel.frame = temp;
        _myScrollView.contentSize = CGSizeMake(self.frame.size.width, height);
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
