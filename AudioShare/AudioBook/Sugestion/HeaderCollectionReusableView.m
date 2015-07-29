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
    self.backgroundColor = [UIColor yellowColor];
    self.subCategoryLabel = [[UILabel alloc] init];
    _subCategoryLabel.frame = self.bounds;
    _subCategoryLabel.textAlignment = NSTextAlignmentLeft;

    [self addSubview:_subCategoryLabel];
    
}
@end
