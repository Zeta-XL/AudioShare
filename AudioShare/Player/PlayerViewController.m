
//
//  PlayerViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "PlayerViewController.h"
#import "TracksListTableViewController.h"
#import "TrackModel.h"
#import "UIImageView+WebCache.h"
#import "HistoryModel.h"
#import "DataBaseHandle.h"
#import "HistoryTableViewController.h"
#import "TimerViewController.h"

static PlayerViewController *singlePlayer = nil;

@interface PlayerViewController () <UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backButton; // 返回
@property (weak, nonatomic) IBOutlet UIButton *autoShutdown; // 定时关闭

@property (weak, nonatomic) IBOutlet UISlider *timeGoingSlider; // 播放进度条
@property (weak, nonatomic) IBOutlet UIButton *playButton; // 播放/暂停按键
@property (weak, nonatomic) IBOutlet UIButton *preButton;  // 上一首
@property (weak, nonatomic) IBOutlet UIButton *nextButton; // 下一首
@property (weak, nonatomic) IBOutlet UIButton *historyButton; // 播放历史
@property (weak, nonatomic) IBOutlet UIButton *listButton;  // 播放列表

// 进度观察者;
@property (nonatomic, strong)id timeObserver;


// 记录当前的item
@property (nonatomic, strong)SpecialItem *currentItem;






// url地址和播放状态时间的列表(播放列表)
@property (nonatomic, strong)NSMutableArray *urlStateList;

@property (nonatomic, strong)UIActivityIndicatorView *loadingView;
@end

@implementation PlayerViewController


- (void)releasePlayer
{
    // 注销结束通知
    [self p_cancelListen];
    
    // 移除item观察者
    if (_currentItem.statusObserver == YES) {
        [self.currentItem removeObserver:self forKeyPath:@"status"];
        _currentItem.statusObserver = NO;
    }
    ;
    
    // 移除时间观察者
    [self p_removeTimerObserver];
    self.urlString = nil;
    self.lastItem = nil;
    self.currentItem = nil;
    self.tracksList = nil;
    [self p_playerInitWithItem:nil];
    
}


// 单例初始化
+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlePlayer = [[PlayerViewController alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    });
    
    return singlePlayer;
}

#pragma mark ---- 视图生命周期
// 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _foreground = YES;
    // 视图
    self.titleLabel.text = self.titleString;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil];


    //------------ 总时间---------------------//
    NSString *totalTime = [self convertTime:_totalSeconds];
    self.totalTimeLabel.text = totalTime;
    NSString *currentTime = [self convertTime:_currentSeconds];
    self.timeGoingLabel.text = currentTime;
    
    if (_urlString) {

        [self p_cancelListen];

        SpecialItem *newItem = [self createPlayerItemWithURLString:_urlString];
        if (!newItem.isLiveCast) { //***************************?//
            // 记录上次播放进度-更更新数据库
            [self p_saveCurrentAlbumInfo]; //----------------------//
        }
        
        self.currentItem = newItem;
        // 初始化播放器
        [self p_playerInitWithItem: _currentItem];
        
        if (!_historyFlag) {
            self.lastSeconds = 0.0;
        } else {
            _historyFlag = NO;
        }
        
        
    } else {
        if (_lastLiveUrl) {
            self.currentItem = [self createPlayerItemWithURLString:_lastLiveUrl];
            self.urlString = _lastLiveUrl;
            self.lastSeconds = 0.0;
        } else {
            self.currentItem = _lastItem;
        }
        // 
        if (_currentItem == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有播放记录" delegate:self cancelButtonTitle:@"了解" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    if (_currentItem.isLiveCast) {
        self.lastLiveUrl = _urlString;
        self.preButton.enabled = NO;
        self.nextButton.enabled = NO;
        self.listButton.enabled = NO;
        self.timeGoingSlider.value = 0;
        self.timeGoingSlider.enabled = NO;
        self.historyButton.enabled = NO;
        self.tracksList = nil;
        self.urlStateList = nil;
        self.currentItem.statusObserver = NO;
        if (self.liveEndTime.length == 0 || self.liveStartTime.length == 0) {
            self.timeGoingLabel.text = [NSString stringWithFormat:@"00:00"];
            self.totalTimeLabel.text = [NSString stringWithFormat:@"23:59"];
        }else {
            self.timeGoingLabel.text = [NSString stringWithFormat:@"%@", self.liveStartTime];
            self.totalTimeLabel.text = [NSString stringWithFormat:@"%@", self.liveEndTime];
        }
        
        
    } else {
        self.preButton.enabled = YES;
        self.nextButton.enabled = YES;
        self.listButton.enabled = YES;
        self.timeGoingSlider.enabled = YES;
        self.historyButton.enabled = YES;
        //
        DLog(@"currentItem = %@, lastItem = %@", _currentItem, _lastItem);
        if (_currentItem != _lastItem) {
            // 需传参数
            [self.currentItem seekToTime:CMTimeMakeWithSeconds(_lastSeconds, 1)];
            // 点播需设置观察者
            [_loadingView startAnimating];  /****************/
            
        }
        // 设置观察者监测当前item status
        [self.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        self.currentItem.statusObserver = YES;
        // 处理数据
        [self p_data];
        
        // 添加时间进度观察者
        
        [self p_setPlayerTimerObserver];
        
        // 添加通知监测播放结束
        [self p_listenPlayTimeToEnd];
        
    }
    
}

// 视图出现
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (_isPlaying == NO) {
        
        [self playAction:_playButton];
    } else {
        
        [_player play];
        
    }
    
}

// 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.lastItem = _currentItem;
    if (_lastItem.isLiveCast == YES) {
        self.lastLiveUrl = _urlString;
    } else {
        self.lastLiveUrl = nil;
        
        // ****************更新数据库*************************
        if ( _urlString || _lastItem) {
            [self p_saveCurrentAlbumInfo];
        }
        
        
        // 移除item观察者
        if (_currentItem.statusObserver) {
            [self.currentItem removeObserver:self forKeyPath:@"status"];
            _currentItem.statusObserver = NO;
        }

        // 移除时间观察者
        [self p_removeTimerObserver];
    }
    self.lastSeconds = _currentSeconds;
    self.currentSeconds = 0;
    self.currentItem = nil;
    self.urlString = nil;
    _foreground = NO;

}

//-------------- 初始化数据  -----------//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载动画
//    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
//    
//    _loadingView.frame = CGRectMake(0, 0, 50, 50);
//    _loadingView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), [UIScreen mainScreen].bounds.size.height - 180);
//    [self.view addSubview:_loadingView];
    
    // Do any additional setup after loading the view from its nib.
    // 添加轻扫手势
    
    [self p_addSwipDownGesture];
    
    [self.timeGoingSlider setThumbImage:[UIImage imageNamed:@"round.png"] forState:(UIControlStateHighlighted)]; // 滑动时
    [self.timeGoingSlider setThumbImage:[UIImage imageNamed:@"round.png"] forState:(UIControlStateNormal)]; // 不滑动时
    // cache路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    DLog(@"%@", cachePath);
    // 播放历史结果 ----需判断是否有可用url
    if (_urlString == nil && _lastLiveUrl == nil) {

        // 用户数据路径
        NSString *trackListPath = [cachePath stringByAppendingPathComponent:@"/user/data/trackListInfo"];
        BOOL trackListExist = [[NSFileManager defaultManager] fileExistsAtPath:trackListPath];
        NSString *radioPath = [cachePath stringByAppendingPathComponent:@"/user/data/radioInfo"];
        BOOL radioExist = [[NSFileManager defaultManager] fileExistsAtPath:radioPath];
        
        if (trackListExist) {
            // 反归档获取播放列表
            NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:trackListPath];
            self.tracksList = dataDict[@"trackList"];
            DLog(@"trackList---%@",_tracksList);
            self.lastSeconds = [dataDict[@"lastSeconds"] doubleValue];
            DLog(@"lastSecinds---%lf", _lastSeconds);
            self.currentIndex = [dataDict[@"lastIndex"] integerValue];
            DLog(@"lastIndex--- %lu", _currentIndex);
            self.imageUrl = dataDict[@"imageUrl"];
            
            TrackModel *track = _tracksList[_currentIndex];
            self.totalSeconds = track.duration;
            self.lastItem = [self createPlayerItemWithURLString:track.playUrl64];
            [self p_playerInitWithItem: _lastItem];
            self.titleString= track.title;
            self.albumId = track.albumId;
            
            DLog(@"trackTitle---%@", track.title);
            
            [self.lastItem seekToTime:CMTimeMakeWithSeconds(_lastSeconds, 1)];
            [_loadingView startAnimating]; /***************/
        } else if (radioExist) {
            NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:radioPath];
            self.imageUrl = dataDict[@"imageUrl"];
            self.lastLiveUrl = dataDict[@"lastLiveUrl"];
            self.titleString = dataDict[@"title"];
        }
    }
    
}

#pragma mark ---- alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self playAction:nil];
    [self backAction:self.backButton];
}



#pragma mark ---- ConvertTime

- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: d];
    d = [d dateByAddingTimeInterval: -frominterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
        
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}


#pragma mark ---- 观察者(player) ---设置播放进度的观察者

// 添加进度观察者
- (void)p_setPlayerTimerObserver
{
    __block typeof(self) weakSelf = self;
   self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        DLog(@"%@", [NSValue valueWithCMTime:time]);
        
        weakSelf.currentSeconds = CMTimeGetSeconds(time);
        
        CGFloat sliderValue = weakSelf.currentSeconds / weakSelf.totalSeconds;
        weakSelf.timeGoingSlider.value = sliderValue;
        
        NSString *currentTime = [weakSelf convertTime:weakSelf.currentSeconds];
        weakSelf.timeGoingLabel.text = currentTime;
    }];
    
}

// 移除进度观察者
- (void)p_removeTimerObserver
{
    [self.player removeTimeObserver:_timeObserver];
    self.timeObserver = nil;
}


#pragma mark ----- playitem status观察者 响应事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"chang---%@", change[@"new"]);
    if (self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
            [_loadingView stopAnimating]; /****************************/
        }
        
    }
    if (_currentItem.statusObserver) {
        [_currentItem removeObserver:self forKeyPath:@"status"];
        _currentItem.statusObserver = NO;
    }
    
    
}


#pragma mark ---- 处理数据

/******************
处理在线听书, 相关数据
*******************/
- (void)p_data
{
    
    
    self.urlStateList = [NSMutableArray array];
    for (int i = 0; i < _tracksList.count; i++) {
        TrackModel *track = self.tracksList[i];
        
        [_urlStateList addObject:[@{@"url":track.playUrl64, @"timeState":@(0.0)} mutableCopy]];
    }
    if (_currentIndex == 0) {
        self.preButton.enabled = NO;
    } else if (_currentIndex == _tracksList.count - 1) {
        self.nextButton.enabled = YES;
    }
    
    DLog(@"urlListCount = %lud", _urlStateList.count);
    for (NSDictionary *d in _urlStateList) {
        DLog(@"urlArray:keys-%@, values-%@", d[@"url"], d[@"timeState"]);
    }
    
}




#pragma mark ---- 播放器相关
// 根据UrlString初始化播放项目
- (SpecialItem *)createPlayerItemWithURLString:(NSString *)urlString
{
    NSURL *url = nil;
    // 准备播放对象
    SpecialItem *playerItem = nil;
    if ([urlString hasSuffix:@".m3u8"]) {
        url = [NSURL URLWithString:urlString];
        playerItem = [[SpecialItem alloc] initWithURL:url];
        playerItem.isLiveCast = YES;

    } else {
        if ([urlString hasSuffix:@".aac"]) {
            url = [NSURL fileURLWithPath:urlString];
        } else {
            url = [NSURL URLWithString:urlString];
        }
        playerItem = [[SpecialItem alloc] initWithURL:url];
        playerItem.isLiveCast = NO;
    }
    return playerItem;
    
}




// 根据item初始化播放器
- (void)p_playerInitWithItem:(SpecialItem *)playerItem;
{

    self.player = [AVPlayer playerWithPlayerItem:playerItem];
}


#pragma mark --- button响应事件
// 返回
- (IBAction)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        DLog(@"退出播放器");
    }];
}

// 定时关闭(暂停)
- (IBAction)autoShutdownAction:(UIButton *)sender
{
    
    TimerViewController *timerVC = [[TimerViewController alloc] init];
    timerVC.isModal = YES;
    UINavigationController *timerNC = [[UINavigationController alloc] initWithRootViewController:timerVC];
    [timerNC.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationBar.jpg"] forBarMetrics:(UIBarMetricsDefault)];
    [self presentViewController:timerNC animated:YES completion:nil];

    DLog(@"定时关闭");
}

// slider进度条拖动
- (IBAction)timeSliderAction:(UISlider *)sender
{
    
    if (_currentItem.statusObserver) {
        [_currentItem removeObserver:self forKeyPath:@"status"];
        _currentItem.statusObserver = NO;
    }
    if (_isPlaying) {
        [self.player pause];
    }
    
    _currentSeconds = sender.value * _totalSeconds;
    
    [self.currentItem seekToTime:CMTimeMakeWithSeconds(_currentSeconds, 1)];
    
    [_currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    _currentItem.statusObserver = YES;
    if (_isPlaying) {
        [self.player play];
    }
    
}

// 播放按键
- (IBAction)playAction:(UIButton *)sender
{
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
        [sender setImage:[UIImage imageNamed:@"music_pause_button.png"] forState:(UIControlStateNormal)];
        // 判断当前的item属性
        if (self.currentItem.isLiveCast) { // 直播
            self.currentItem = [self createPlayerItemWithURLString:_urlString];
            [self p_playerInitWithItem:_currentItem];
        }
        [self.player play];
        
    } else {
        [sender setImage:[UIImage imageNamed:@"music_play_button.png"] forState:(UIControlStateNormal)];
        
        [self.player pause];
    }
    DLog(@"currentIndex=%lu", _currentIndex);
}

// 上一首
- (IBAction)preButtonAction:(UIButton *)sender
{
    if (self.nextButton.enabled == NO) {
        self.nextButton.enabled = YES;
    }
    if (_currentIndex > 0) {
        _currentIndex--;
        DLog(@"pre to %lud", _currentIndex);
        if (_currentIndex == 0) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }

        CGFloat lastSeconds = [_urlStateList[_currentIndex][@"timeState"] doubleValue];
        [self p_replacePlayItemAtIndex:_currentIndex startSeconds:lastSeconds lastIndex:_currentIndex + 1];
        
        [self playAction:self.playButton];
    }
   
}


// 下一首
- (IBAction)nextButtonAction:(UIButton *)sender
{
    if (self.preButton.enabled == NO) {
        self.preButton.enabled = YES;
    }
    if (_currentIndex < _tracksList.count - 1) {
        _currentIndex++;
         DLog(@"nest to %lud", _currentIndex);
        if (_currentIndex == _tracksList.count - 1) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }
        
        CGFloat lastSeconds = [_urlStateList[_currentIndex][@"timeState"] doubleValue];
        [self p_replacePlayItemAtIndex:_currentIndex startSeconds:lastSeconds lastIndex:_currentIndex - 1];
        
        [self playAction:self.playButton];
        

    }
}


// 播放列表
- (IBAction)ListButtonAction:(UIButton *)sender
{
    TracksListTableViewController *trackListVC = [[TracksListTableViewController alloc] init];
    UINavigationController *listNC = [[UINavigationController alloc] initWithRootViewController:trackListVC];
    
    trackListVC.trackList = self.tracksList;
    trackListVC.albumId = self.albumId;
    
    [self presentViewController:listNC animated:YES completion:^{
        DLog(@"打开列表");
    }];
}

- (IBAction)historyButtonAction:(UIButton *)sender
{
    HistoryTableViewController *historyVC = [[HistoryTableViewController alloc] init];
    UINavigationController *hisNC = [[UINavigationController alloc] initWithRootViewController:historyVC];
    [hisNC.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationBar.jpg"] forBarMetrics:(UIBarMetricsDefault)];
    historyVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@2x.png"] style:(UIBarButtonItemStyleDone) target:historyVC action:@selector(backToPlayer:)];
    historyVC.isModal = YES;
    [self presentViewController:hisNC animated:YES completion:^{
    }];
    
}



#pragma mark ---- 替换playitem;
// 更换playItem的方法
- (void)p_replacePlayItemAtIndex:(NSInteger)index startSeconds:(CGFloat)startSecs lastIndex:(NSInteger)lastIndex
{
    // 移除观察者
    [self p_cancelListen];
    if (_currentItem.statusObserver) {
        [_currentItem removeObserver:self forKeyPath:@"status"];
        _currentItem.statusObserver = NO;
    }
   
    [self p_removeTimerObserver];
    
    CGFloat lastSeconds = CMTimeGetSeconds([_currentItem currentTime]);
    if (lastSeconds >= CMTimeGetSeconds(_currentItem.duration) - 1.0) {
        lastSeconds = 0.0;
    }
    [_urlStateList[lastIndex] setObject:@(lastSeconds) forKey:@"timeState"];
    
    // ******************更新数据库(播放历史)***********************
//    [self p_saveCurrentAlbumInfo];
    
    self.currentItem = [self createPlayerItemWithURLString:_urlStateList[index][@"url"]];
    self.lastItem = _currentItem;
    
    // 添加观察者
    [self p_listenPlayTimeToEnd];
    [_currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    _currentItem.statusObserver = YES;
    
    self.currentSeconds = startSecs;
    [self.currentItem seekToTime:CMTimeMakeWithSeconds(_currentSeconds, 1)];
    [_loadingView startAnimating]; /*********************/
    
    TrackModel *ctrack = _tracksList[index];
    self.totalSeconds = ctrack.duration;
    // 视图相关
    self.totalTimeLabel.text = [self convertTime:ctrack.duration];
    self.titleString = ctrack.title;
    self.titleLabel.text = self.titleString;
    
    
    [self.player replaceCurrentItemWithPlayerItem:_currentItem];
    if (_foreground) {
        [self p_setPlayerTimerObserver];
    }
    
}





#pragma mark ---- 自动播放下一集
// 添加通知
- (void)p_listenPlayTimeToEnd
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
}

// 注销通知
- (void)p_cancelListen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentItem];
}

// 自动播放下一集
- (void)trackPlayDidEnd:(SpecialItem *)sender
{
    
    DLog(@"播放结束");

    if (_currentIndex < _tracksList.count - 1) {
        
        [self nextButtonAction:self.nextButton];

    } else {
        [self p_cancelListen];
    }
    
    
    
}

#pragma mark ------ 记录播放历史 --- 归档播放列表
- (void)p_saveCurrentAlbumInfo
{
    
    NSString *cachePath = [[DataBaseHandle shareDataBase] getPathOf:Cache];
    NSString *userHistoryPath = [cachePath stringByAppendingPathComponent:@"user/history"];
    
    // 判断是否存在,然后创建文件夹
    BOOL exixt = [[NSFileManager defaultManager] fileExistsAtPath:userHistoryPath];
    if (!exixt) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userHistoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    DLog(@"docPath----  %@",docPath);
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    
    // 创建表 (播放历史)
    [[DataBaseHandle shareDataBase] createTableWithName:kHistoryTableName paramNames:[HistoryModel historyPropertyNames] paramTypes:[HistoryModel historyPropertyTypes] setPrimaryKey:YES];
    
    
    TrackModel *track = _tracksList[_currentIndex];
    
    HistoryModel *history = [[HistoryModel alloc] init];
    history.albumId = track.albumId;
    history.albumTitle = track.albumTitle;
    history.trackTitle = track.title;
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    history.timestamp = [NSString stringWithFormat:@"%lf", timestamp];
    
    
    CGFloat timeSeconds = 0;
    if (_currentItem) {
        timeSeconds = CMTimeGetSeconds([_currentItem currentTime]);
    } else {
        timeSeconds = CMTimeGetSeconds([_lastItem currentTime]);
    }
      
    history.currentTime = [self convertTime:timeSeconds];
    history.coverSmall = track.coverLarge;
    history.archiveName = [NSString stringWithFormat:@"aid%@", history.albumId];
    
    // 查找数据是否有
    NSArray *resultArray = [[DataBaseHandle shareDataBase] selectFromTable:kHistoryTableName withKey:@"albumId" pairValue:history.albumId historyProperty:[HistoryModel historyPropertyNames]];
    
    if (resultArray.count == 0) { // 没有数据记录则新建
        BOOL oK = [[DataBaseHandle shareDataBase] insertIntoTable:kHistoryTableName paramKeys:[HistoryModel historyPropertyNames] withValues:[history historyPropertyValues]];
        if (oK) {
            [self p_archiveTrackList:self.tracksList withName:history.archiveName atArchivePath:userHistoryPath];
        } else {
            DLog(@"保存播放历史数据失败:(");
        }
    } else { // 有数据记录则更新
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[history historyPropertyValues] forKeys:[HistoryModel historyPropertyNames]];
        
        [[DataBaseHandle shareDataBase] updateTable:kHistoryTableName changeDict:dict atPrimaryKey:@"albumId" primaryKeyValue:history.albumId];
        
        [self p_archiveTrackList:self.tracksList withName:history.archiveName atArchivePath:userHistoryPath];
    }
    


    [[DataBaseHandle shareDataBase] closeDB];
    
    
}


// 归档播放列表数据
- (void)p_archiveTrackList:(NSMutableArray *)list  withName:(NSString *)archiveName atArchivePath:(NSString *)path
{
    CGFloat timeSeconds = 0;
    if (_currentItem) {
        timeSeconds = CMTimeGetSeconds([_currentItem currentTime]);
    } else {
        timeSeconds = CMTimeGetSeconds([_lastItem currentTime]);
    }
    NSDictionary *dataDict = @{@"lastIndex":@(_currentIndex), @"lastSeconds":@(timeSeconds), @"tracksCount":@(self.tracksList.count), @"imageUrl":_imageUrl};
    NSString *localListPath = [path stringByAppendingPathComponent:archiveName];
    
    // 开始归档
    [NSKeyedArchiver archiveRootObject:dataDict toFile:localListPath];
}



#pragma mark ---- 添加轻扫向下手势
- (void)p_addSwipDownGesture
{
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipDownAction:)];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipDown];
}

- (void)swipDownAction:(UISwipeGestureRecognizer *)sendser
{
    [self backAction:nil];
}



#pragma mark ----timer 相关
- (void)timerStopAction
{
    if (_isPlaying) {
        [self playAction:nil];
    }
    
}

- (void)timerChangeAction:(NSTimer *)aTimer
{
    
    self.timerTime = _timerTime - 1;
    if (_timerTime <= 0) {
        [self timerStopAction];
        [self.timer invalidate];
        self.timer = nil;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"timerOn"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定时关闭时间已到" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
