//
//  DownloadingTableViewCell.h
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dloaddata;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dloadProgress;

@end
