//
//  RadioProvinceTableViewController.h
//  AudioShare
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义block
typedef void (^provinceBlock)(NSString *aString);

@interface RadioProvinceTableViewController : UITableViewController
@property (nonatomic, strong)NSString *string;

//声明block
@property (nonatomic, copy)provinceBlock province;

@end
