//
//  HistoryTableViewController.h
//  AudioShare
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^trackListBlock)(NSMutableArray *trackList);
@interface HistoryTableViewController : UITableViewController
@property (nonatomic, copy)trackListBlock handleTrackList;
@property (nonatomic, assign)BOOL isModal;

- (void)backToPlayer:(UIBarButtonItem *)leftbutton;
@end
