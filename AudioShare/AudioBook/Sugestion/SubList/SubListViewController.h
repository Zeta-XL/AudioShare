//
//  SubListViewController.h
//  AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^returnBackTag)(NSString *aString);

@interface SubListViewController : UITableViewController
@property (nonatomic, strong)NSMutableArray *tagNameArray;
@property (nonatomic, copy)returnBackTag backTagName;
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, copy)NSString *categoryId;
@end
