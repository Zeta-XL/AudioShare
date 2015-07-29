//
//  AudioTableViewCell.h
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell

//专辑图片
@property (nonatomic, strong)UIImageView *myImageView;
//专辑标题
@property (nonatomic, strong)UILabel *titleLabel;
//专辑类型
@property (nonatomic, strong)UILabel *tagsLabel;
//专辑中声音个数
@property (nonatomic, strong)UILabel *tracksCountsLabel;


@end
