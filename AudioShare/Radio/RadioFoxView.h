//
//  RadioFoxView.h
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioFoxView : UIView

//网络电台
@property (nonatomic, strong)UIButton *networkButton;

//国家电台
@property (nonatomic, strong)UIButton *countriesButton;

//省市电台
@property (nonatomic, strong)UIButton *provinceButton;

@property (nonatomic, strong)UILabel *foxLabel;

@end
