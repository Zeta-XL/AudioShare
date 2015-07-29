//
//  AlbumTableViewCell.h
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell

//详情
@property (nonatomic, strong)UILabel *titleLabel;

//下载button
@property (nonatomic, strong)UIButton *optionButton;

//播放时间
@property (nonatomic, strong)UILabel *playTimesLabel;

//评论
@property (nonatomic, strong)UILabel *commentLabel;

@end
