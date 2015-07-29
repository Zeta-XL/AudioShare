//
//  AlbumView.h
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumView : UIView

//视图
@property (nonatomic, strong)UIImageView *myImageView;

//标题
@property (nonatomic, strong)UILabel *titleLabel;

//作者
@property (nonatomic, strong)UILabel *writerLabel;

//详情
@property (nonatomic, strong)UILabel *detailLabel;

//收藏
@property (nonatomic, strong)UILabel *collectionLabel;

//下载
@property (nonatomic, strong)UILabel *loadLabel;

//收藏button
@property (nonatomic, strong)UIButton *collectionButton;

//下载button
@property (nonatomic, strong)UIButton *loadButton;

//详情展示
@property (nonatomic, strong)UIButton *detailButton;


@end
