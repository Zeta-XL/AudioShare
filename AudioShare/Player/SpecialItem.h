//
//  SpecialItem.h
//  AudioShare
//
//  Created by lanou3g on 15/7/30.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SpecialItem : AVPlayerItem 
@property (nonatomic, assign)BOOL isLiveCast;
@property (nonatomic, assign)BOOL statusObserver;
@end
