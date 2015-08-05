//
//  Album——ListView.h
//  AudioShare
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Album_ListViewDelegate  <NSObject>

- (CGFloat)tellTextHeight;

@end


@interface Album_ListView : UIView

//
@property (nonatomic, strong)UIScrollView *myScrollView;

//布局子视图
@property (nonatomic, strong)UIView *myView;

//专辑名称
@property (nonatomic, strong)UILabel *titleLabel;

//创建人
@property (nonatomic, strong)UILabel *writerLabel;

//简介
@property (nonatomic, strong)UILabel *detailLabel;

//详情
@property (nonatomic, strong)UILabel *discriptionLabel;

@property (nonatomic, weak)id <Album_ListViewDelegate> delegate;

- (void)setupContentSize;
@end
