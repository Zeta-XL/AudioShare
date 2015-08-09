//
//  AlbumView.h
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumViewDelegate <NSObject>

- (void)onClickCollectionButton:(UIButton *)sender;

- (void)onClickDownloadButton:(UIButton *)sender;

@end

@interface AlbumView : UIView

@property (nonatomic, strong)UIImageView *albumBackView;

//视图
@property (nonatomic, strong)UIImageView *albumImageView;

//标题
@property (nonatomic, strong)UILabel *titleLabel;

//作者
@property (nonatomic, strong)UILabel *writerLabel;

//详情
@property (nonatomic, strong)UILabel *detailLabel;


//收藏button
@property (nonatomic, strong)UIButton *collectionButton;

//下载button
@property (nonatomic, strong)UIButton *loadButton;

@property (nonatomic, weak)id <AlbumViewDelegate> delegate;

@end
