
//
//  PlayerViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "PlayerViewController.h"
#import "TracksListTableViewController.h"

static PlayerViewController *singlePlayer = nil;

@interface PlayerViewController ()

// UI布局

@property (weak, nonatomic) IBOutlet UIButton *backButton; // 返回
@property (weak, nonatomic) IBOutlet UIButton *autoShutdown; // 定时关闭

@property (weak, nonatomic) IBOutlet UISlider *timeGoingSlider; // 播放进度条
@property (weak, nonatomic) IBOutlet UIButton *playButton; // 播放/暂停按键
@property (weak, nonatomic) IBOutlet UIButton *preButton;  // 上一首
@property (weak, nonatomic) IBOutlet UIButton *nextButton; // 下一首
@property (weak, nonatomic) IBOutlet UIButton *historyButton; // 播放历史
@property (weak, nonatomic) IBOutlet UIButton *listButton;  // 播放列表

// 记录最后的Item
@property (nonatomic, strong)SpecialItem *lastItem;

// 记录当前的item
@property (nonatomic, strong)SpecialItem *currentItem;

// 上一次直播的URL
@property (nonatomic, copy)NSString *lastLiveUrl;

@end

@implementation PlayerViewController
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
    self.titleLabel.text = self.titleString;
    
    
    // 总时间---------------------//
    _totalSeconds = 1356.96; // 传值获得
    NSString *totalTime = [self convertTime:_totalSeconds];
    self.totalTimeLabel.text = totalTime;
    
    if (_urlString ) {
        self.currentItem = [self createPlayerItemWithURLString:_urlString];
        // 初始化播放器
        [self p_playerInitWithItem: _currentItem];
    } else {
        if (_lastLiveUrl) {
            self.currentItem = [self createPlayerItemWithURLString:_lastLiveUrl];
            self.urlString = _lastLiveUrl;
            
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
        
    } else {
        self.preButton.enabled = YES;
        self.nextButton.enabled = YES;
        self.listButton.enabled = YES;
        self.timeGoingSlider.enabled = YES;
        // 续传参数
        [self.currentItem seekToTime:CMTimeMakeWithSeconds(_currentSeconds, 1)];
        
        // 点播需设置观察者
        // 设置观察者监测当前item status
        [self.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        
        // 处理数据
        [self p_data];
        
        // 添加时间进度观察者
        [self p_setPlayerTimerObserver];
        
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
    
//    self.currentItem = nil;
//    self.urlString = nil;
    DLog(@"LiveUrl:%@", _lastLiveUrl);
    DLog(@"Url:%@",_urlString);
}

//-------------- 初始化数据  -----------//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentIndex = 0;
    
    
    // 播放历史结果 ----需判断是否有可用url
    if (_urlString == nil && _lastLiveUrl == nil) {
        // 总时间
        
        self.lastItem = [self createPlayerItemWithURLString:kStreamUrl1];
        [self p_playerInitWithItem: _lastItem];
        
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
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:NULL usingBlock:^(CMTime time) {
        NSLog(@"%@", [NSValue valueWithCMTime:time ]);
        
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
    [self.player removeTimeObserver:nil];
}


#pragma mark ----- 观察者 响应事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@", change[@"new"]);
    if (self.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [self playAction:self.playButton];
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
    
    
    self.tracksList = [NSMutableArray array];
    [_tracksList addObject:_currentItem];
    NSString *local = [[NSBundle mainBundle] pathForResource:@"testDemo.aac" ofType:nil];
    for (NSString *urlStr in @[ kStreamUrl2, kStreamUrl3, local]) {
        SpecialItem *item= [self createPlayerItemWithURLString:urlStr];
        [_tracksList addObject:item];
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


// 根据列表索引准备播放器///// 暂未使用  //////
- (void)p_initWithIndex:(NSInteger)index
{
    AVPlayerItem *avItem = _tracksList[_currentIndex];
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
    
}

// 上一首
- (IBAction)preButtonAction:(UIButton *)sender
{
    if (self.nextButton.enabled == NO) {
        self.nextButton.enabled = YES;
    }
    if (_currentIndex > 0) {
        _currentIndex--;
        if (_currentIndex == 0) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }

        [_currentItem removeObserver:self forKeyPath:@"status"];
        self.currentItem = _tracksList[_currentIndex];
        [_currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        
        
        [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
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
        if (_currentIndex == _tracksList.count - 1) {
            sender.enabled = NO;
        }
        
        if (_isPlaying == NO) {
            [self playAction:self.playButton];
        }
        
        [_currentItem removeObserver:self forKeyPath:@"status"];
        self.currentItem = _tracksList[_currentIndex];
        [_currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
        
      
        [self.player replaceCurrentItemWithPlayerItem:_tracksList[_currentIndex]];
        [self playAction:self.playButton];
    }
}

// 播放列表
- (IBAction)ListButtonAction:(UIButton *)sender
{
    TracksListTableViewController *trackListVC = [[TracksListTableViewController alloc] init];
    [self presentViewController:trackListVC animated:YES completion:^{
        DLog(@"打开列表");
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
