
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

static PlayerViewController *singlePlayer = nil;

@interface PlayerViewController ()


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
// 记录最后的Item
@property (nonatomic, strong)SpecialItem *lastItem;

// 记录当前的item
@property (nonatomic, strong)SpecialItem *currentItem;

// 上一次直播的URL
@property (nonatomic, copy)NSString *lastLiveUrl;

// 上次播放时间
@property (nonatomic, assign)CGFloat lastSeconds;

// 播放item列表
@property (nonatomic, strong)NSMutableArray *playItemList;
@end

@implementation PlayerViewController
-(void)dealloc
{
    [self p_cancelListen];
}


// 单例初始化
+ (instancetype)sharedPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlePlayer = [[PlayerViewController alloc] init];
    });
    
    return singlePlayer;
}

#pragma mark ---- 视图生命周期
// 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // 视图
    self.titleLabel.text = self.titleString;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil];

    
    // 总时间---------------------//
    NSString *totalTime = [self convertTime:_totalSeconds];
    self.totalTimeLabel.text = totalTime;
    NSString *currentTime = [self convertTime:_currentSeconds];
    self.timeGoingLabel.text = currentTime;
    
    if (_urlString) {

        [self p_cancelListen];
        self.currentItem = [self createPlayerItemWithURLString:_urlString];
        // 初始化播放器
        [self p_playerInitWithItem: _currentItem];
        
        self.lastSeconds = 0.0;
    } else {
        if (_lastLiveUrl) {
            self.currentItem = [self createPlayerItemWithURLString:_lastLiveUrl];
            self.urlString = _lastLiveUrl;
            self.lastSeconds = 0.0;
        } else {
            self.currentItem = _lastItem;

        }
    }
   
    if (_currentItem.isLiveCast) {
        self.preButton.enabled = NO;
        self.nextButton.enabled = NO;
        self.listButton.enabled = NO;
        self.timeGoingSlider.value = 0;
        self.timeGoingSlider.enabled = NO;
        self.playItemList = nil;
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
        
        // 续传参数
        [self.currentItem seekToTime:CMTimeMakeWithSeconds(_lastSeconds, 1)];
        // 点播需设置观察者
        // 设置观察者监测当前item status
        [self.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        
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
        
        // 移除item观察者
        [self.currentItem removeObserver:self forKeyPath:@"status"];
        
        // 移除时间观察者
        [self p_removeTimerObserver];
    }
    self.lastSeconds = _currentSeconds;
    self.currentSeconds = 0;
    self.currentItem = nil;
    self.urlString = nil;

}

//-------------- 初始化数据  -----------//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.timeGoingSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:(UIControlStateHighlighted)]; // 滑动时
    [self.timeGoingSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:(UIControlStateNormal)]; // 不滑动时
    
    // 播放历史结果 ----需判断是否有可用url
    if (_urlString == nil && _lastLiveUrl == nil) {
        // 总时间
        self.lastItem = [self createPlayerItemWithURLString:kStreamUrl1];
        [self p_playerInitWithItem: _lastItem];
        _lastSeconds = 0.0;

    }
    
}


#pragma mark ---- ConvertTime

- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
        
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}


#pragma mark ---- 观察者 ---设置播放进度的观察者

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
}


#pragma mark ----- playitem status观察者 响应事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"chang---%@", change[@"new"]);
    if (self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }
        
    }
    
}


#pragma mark ---- 处理数据

/******************
处理在线听书, 相关数据
*******************/
- (void)p_data
{
    if (_currentIndex == 0) {
        self.preButton.enabled = NO;
    } else if (_currentIndex == _tracksList.count - 1) {
        self.nextButton.enabled = YES;
    }
    
    
    self.playItemList = [NSMutableArray array];
    
    for (int i = 0; i < _tracksList.count; i++) {
        if (i == _currentIndex) {
            [self.playItemList addObject:self.currentItem];
        } else {
            TrackModel *track = self.tracksList[i];
            SpecialItem *item= [self createPlayerItemWithURLString:track.playUrl64];
            [_playItemList addObject:item];
        }
        
    }
    
    DLog(@"listCount = %ld", _playItemList.count);
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


// 根据列表索引准备播放器///// 暂未使用  //////
- (void)p_initWithIndex:(NSInteger)index
{
    AVPlayerItem *avItem = _playItemList[_currentIndex];
    self.player = [AVPlayer playerWithPlayerItem:avItem];
    
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
    
    DLog(@"定时关闭");
}

// slider进度条拖动
- (IBAction)timeSliderAction:(UISlider *)sender
{
    [self.player pause];
    _currentSeconds = sender.value * _totalSeconds;
    
    [self.currentItem seekToTime:CMTimeMakeWithSeconds(_currentSeconds, 1)];
    [self.player play];
}

// 播放按键
- (IBAction)playAction:(UIButton *)sender
{
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
        [sender setImage:[UIImage imageNamed:@"pause_btn.jpg"] forState:(UIControlStateNormal)];
        // 判断当前的item属性
        if (self.currentItem.isLiveCast) { // 直播
            self.currentItem = [self createPlayerItemWithURLString:_urlString];
            [self p_playerInitWithItem:_currentItem];
        }
        [self.player play];
        
    } else {
        [sender setImage:[UIImage imageNamed:@"play_btn.jpg"] forState:(UIControlStateNormal)];
        
        [self.player pause];
    }
    DLog(@"currentIndex=%ld", _currentIndex);
}

// 上一首
- (IBAction)preButtonAction:(UIButton *)sender
{
    if (self.nextButton.enabled == NO) {
        self.nextButton.enabled = YES;
    }
    if (_currentIndex > 0) {
        _currentIndex--;
        DLog(@"pre to %ld", _currentIndex);
        if (_currentIndex == 0) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }


        [self p_replacePlayItemAtIndex:_currentIndex startSeconds:0.0];
        
        [self playAction:self.playButton];
    }
   
}


// 下一首
- (IBAction)nextButtonAction:(UIButton *)sender
{
    if (self.preButton.enabled == NO) {
        self.preButton.enabled = YES;
    }
    if (_currentIndex < _playItemList.count - 1) {
        _currentIndex++;
         DLog(@"nest to %ld", _currentIndex);
        if (_currentIndex == _playItemList.count - 1) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }
        
        
        [self p_replacePlayItemAtIndex:_currentIndex startSeconds:0.0];
        
        [self playAction:self.playButton];
        

    }
}

#pragma mark ---- 替换playitem;
// 更换playItem的方法
- (void)p_replacePlayItemAtIndex:(NSInteger)index startSeconds:(CGFloat)startSecs
{
    [self p_cancelListen];
    [_currentItem removeObserver:self forKeyPath:@"status"];
    
    self.currentItem = _playItemList[index];
    
    [self p_listenPlayTimeToEnd];
    [_currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    [self.player removeTimeObserver:nil];
    
    self.currentSeconds = startSecs;
    TrackModel *ctrack = _tracksList[index];
    self.totalSeconds = ctrack.duration;
    // 视图相关
    self.totalTimeLabel.text = [self convertTime:ctrack.duration];
    self.titleString = ctrack.title;
    self.titleLabel.text = self.titleString;
    
    
    [self.player replaceCurrentItemWithPlayerItem:_currentItem];
    [self p_setPlayerTimerObserver];
}



// 播放列表
- (IBAction)ListButtonAction:(UIButton *)sender
{
    TracksListTableViewController *trackListVC = [[TracksListTableViewController alloc] init];
    [self presentViewController:trackListVC animated:YES completion:^{
        DLog(@"打开列表");
    }];
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

    if (_currentIndex < _playItemList.count - 1) {
        
        [self nextButtonAction:self.nextButton];

    } else {
        [self p_cancelListen];
    }
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
