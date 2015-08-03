//
//  API_URL.h
//  AudioShare
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//


#ifndef AudioShare_API_URL_h
#define AudioShare_API_URL_h

#import "RadioHeader.h"

#define kRadioUrl @"http://live.ximalaya.com/live-web/v1/getRadiosListByType"
#define kRadioCityUrl @"http://live.ximalaya.com/live-web/v1/getProvinceList?device=iPhone"

#define kStreamUrl1 @"http://fdfs.xmcdn.com/group9/M00/40/EA/wKgDZlWhtSXgp22zAKWl4zfNMB4283.mp3"
#define kStreamUrl2 @"http://fdfs.xmcdn.com/group9/M09/36/53/wKgDZlWV3NeibnhLALj028B3jTI787.mp3"
#define kStreamUrl3 @"http://fdfs.xmcdn.com/group12/M06/37/48/wKgDXFWXKwSjJxXAALgV_1IGEHM201.mp3"

#define kLiveCast @"http://live.xmcdn.com/192.168.3.134/live/12/24.m3u8"
#define kDownloadUrl @"http://download.xmcdn.com/group12/M06/40/C7/wKgDW1WhtRmC_qVBAFXyKWxyylw936.aac"

// 所有大分类标题
#define kAudioCategoryList @"http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=iPhone&picVersion=10&scale=2" // 参数 device=iPhone&picVersion=10&scale=2
// 所有小分类标题
#define kSubAudioCategoryList @"http://mobile.ximalaya.com/mobile/discovery/v1/category/tagsWithoutCover" // 参数 categoryId=3&contentType=album&device=iPhone
// 推荐页面
#define kAudioSuggetionList @"http://mobile.ximalaya.com/mobile/discovery/v1/category/recommends" // 参数 categoryId=3&contentType=album&device=iPhone&version=4.1.7.1
// 小分类专辑列表页面
#define kSubAudioAlbumList @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album" // 参数 calcDimension=hot&categoryId=3&device=iPhone&pageId=1&pageSize=20&status=0&tagName=浪漫言情

// 专辑详情界面
#define kDetailAlbumList @"http://mobile.ximalaya.com/mobile/others/ca/album/track" // 参数 pageId=2&pageSize=20&albumId=2722845



#endif
