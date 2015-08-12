//
//  DisclaimerView.h
//  AudioShare
//
//  Created by lanou3g on 15/8/12.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DisclaimerView : UIView

//
@property (nonatomic, strong)UIScrollView *myScrollview;

//
@property (nonatomic, strong)UILabel *discriptionLabel;

@property (nonatomic, copy)NSString *content;
- (CGSize)contextLabelHeight:(NSString *)aString;

@end
