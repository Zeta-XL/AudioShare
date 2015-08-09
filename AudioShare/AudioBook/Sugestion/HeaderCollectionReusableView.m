//
//  HeaderCollectionReusableView.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView
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
    self.subCategoryLabel = [[UILabel alloc] init];
    _subCategoryLabel.frame = self.bounds;
    _subCategoryLabel.textAlignment = NSTextAlignmentLeft;
    _subCategoryLabel.layer.borderColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.8].CGColor;
    _subCategoryLabel.layer.borderWidth = 2.f;
    _subCategoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subCategoryLabel];
    
}
@end
