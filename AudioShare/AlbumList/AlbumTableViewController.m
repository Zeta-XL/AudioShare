//
//  AlbumTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "AlbumTableViewCell.h"
#import "AlbumView.h"
#import "PlayerViewController.h"
#import "API_URL.h"
#import "RequestTool_v2.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AlbumModel.h"
#import "TrackModel.h"
#import "DataBaseHandle.h"
#import "Album_ListViewController.h"

@interface AlbumTableViewController () <AlbumViewDelegate>
{
    NSInteger _pageSize;
    NSInteger _maxPageId;
    NSInteger _currentPageId;
    BOOL _loadOk;
    BOOL _isSaved;
}
@property (nonatomic, strong)AlbumView *albumView;
@property (nonatomic, strong)NSMutableArray *tracksList;
@property (nonatomic, strong)AlbumModel *album;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, assign)BOOL networkOK;
@end

@implementation AlbumTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //打开数据库 //
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    // 创建表 (收藏)
    [[DataBaseHandle shareDataBase] createTableWithName:kFavorateTableName paramNames:[AlbumModel propertyNames] paramTypes:[AlbumModel propertyTypes] setPrimaryKey:YES];
    // 查找数据
    NSArray *resultArray = [[DataBaseHandle shareDataBase] selectFromTable:kFavorateTableName withKey:@"albumId" pairValue:self.albumId modelProperty:[AlbumModel propertyNames]];
    if (resultArray) {
        _isSaved = YES;
        [_albumView.collectionButton setTitle:@"取消收藏" forState:(UIControlStateNormal)];
    } else {
        _isSaved = NO;
        [_albumView.collectionButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    }
    
    
    [[DataBaseHandle shareDataBase] closeDB];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景
/*    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"19.jpg" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
*/
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backButtonAction:)];
    [self p_albumView];
    [self p_setupActivity];

    
    //注册
    [self.tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:@"AlbumCell"];
    _pageSize = 20;
    _currentPageId = 1;
    self.tracksList = [NSMutableArray array];
    
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    [self p_dragUptoLoadMore];
    [self.activity startAnimating];
     
}

- (void)p_setupActivity
{
    //进度轮
    self.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 80, 50)];
    self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activity.backgroundColor = [UIColor grayColor];
    self.activity.alpha = 0.8;
    self.activity.layer.cornerRadius = 6;
    self.activity.layer.masksToBounds = YES;
    
    //显示位置
    [self.activity setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    
    [self.view addSubview:_activity];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)backButtonAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




// 请求数据
- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    NSString *params = [NSString stringWithFormat:@"pageId=%ld&pageSize=%ld&albumId=%@", pageId, pageSize, self.albumId];
    
    [RequestTool_v2 requestWithURL:kDetailAlbumList paramString:params postRequest:NO callBackData:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        if ([dict[@"msg"] isEqualToString:@"0"]) {
            // 获取声音model
//            DLog(@"%@", dict[@"tracks"][@"list"]);
            for (NSDictionary *d in dict[@"tracks"][@"list"]) {
                TrackModel *trackm = [[TrackModel alloc] init];
                [trackm setValuesForKeysWithDictionary:d];
                [_tracksList addObject:trackm];
            }
            
            // 获得maxPageId
            _maxPageId = [dict[@"tracks"][@"maxPageId"] integerValue];
            DLog(@"maxPageId = %ld", _maxPageId);
            // 获取album信息
            self.album = [[AlbumModel alloc] init];
            [_album setValuesForKeysWithDictionary:dict[@"album"]];
            if (_album.tags == nil) {
                _album.tags = @"无";
            }
            self.navigationItem.title = _album.categoryName;
            
            [_albumView.albumImageView sd_setImageWithURL:[NSURL URLWithString:_album.coverLarge] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            _albumView.titleLabel.text = _album.title;
            _albumView.writerLabel.text = [NSString stringWithFormat:@"作者: %@",  _album.nickname];
            if (_album.intro.length == 0) {
                _album.intro = @"无";
            }
            _albumView.detailLabel.text = [NSString stringWithFormat:@"简介: %@",  _album.intro];
            _loadOk = YES;
            [self.activity stopAnimating];
            _albumView.collectionButton.enabled = YES;
            _albumView.loadButton.enabled = YES;
        } else {
            DLog(@"加载数据无效");
        }
        
        if (_maxPageId != 0) {
            [self.tableView.footer endRefreshing];
        }
        
        [self.tableView reloadData];
        self.tableView.scrollEnabled = YES;
    }];
    self.tableView.scrollEnabled = NO;
    _loadOk = NO;
    _albumView.collectionButton.enabled = NO;
    _albumView.loadButton.enabled = NO;
}

// 上拉加载
- (void)p_dragUptoLoadMore
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(p_loadMoreData)];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.footer.ignoredScrollViewContentInsetTop = 30;
}

// 加载数据
- (void)p_loadMoreData
{
    if (_currentPageId <= _maxPageId) {
        [self p_requestDataWithPageId:_currentPageId pageSize:_pageSize];
        _currentPageId++;
    } else {
        [self.tableView.footer noticeNoMoreData];
    }
}




#pragma mark ----albumView 设置
//自定义albumView视图
-(void)p_albumView
{
    self.albumView = [[AlbumView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 180)];
    self.tableView.tableHeaderView = _albumView;
    self.albumView.delegate = self;
    
    //打开数据库 //
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    // 创建表 (收藏)
    [[DataBaseHandle shareDataBase] createTableWithName:kFavorateTableName paramNames:[AlbumModel propertyNames] paramTypes:[AlbumModel propertyTypes] setPrimaryKey:YES];
    // 查找数据
    NSArray *resultArray = [[DataBaseHandle shareDataBase] selectFromTable:kFavorateTableName withKey:@"albumId" pairValue:self.albumId modelProperty:[AlbumModel propertyNames]];
    if (resultArray) {
        _isSaved = YES;
        [_albumView.collectionButton setTitle:@"取消收藏" forState:(UIControlStateNormal)];
    } else {
        _isSaved = NO;
        [_albumView.collectionButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    }
    
    
    [[DataBaseHandle shareDataBase] closeDB];
    
    
    
    _albumView.detailLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_albumView.detailLabel addGestureRecognizer:tap];
    
}

//代理
- (void)onClickCollectionButton:(UIButton *)sender
{
    _isSaved = !_isSaved;
    
    // 打开数据库
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    // 创建表 (收藏)
    [[DataBaseHandle shareDataBase] createTableWithName:kFavorateTableName paramNames:[AlbumModel propertyNames] paramTypes:[AlbumModel propertyTypes] setPrimaryKey:YES];
    if (_isSaved) {
        
        // 数据库插入数据
       BOOL result = [[DataBaseHandle shareDataBase] insertIntoTable:kFavorateTableName paramKeys:[AlbumModel propertyNames] withValues:[_album albumInfoValue]];
        if (result) {
            DLog(@"收藏%@成功", self.albumId);
            [sender setTitle:@"取消收藏" forState:(UIControlStateNormal)];
        } else {
            DLog(@"收藏%@失败", self.albumId);
        }
        
  
    } else {
        // 数据库删除数据
        [[DataBaseHandle shareDataBase] deletefromTable:kFavorateTableName withKey:@"albumId" value:_albumId];
        
        
        [sender setTitle:@"收藏" forState:(UIControlStateNormal)];
    }
    

    [[DataBaseHandle shareDataBase] closeDB];
    
}

- (void)onClickDownloadButton:(UIButton *)sender
{
    DLog(@"显示详情");
    [self tapAction:nil];
    
}


- (void)tapAction:(UITapGestureRecognizer *)sender
{
    DLog(@"点击");
    Album_ListViewController *albumLVC = [[Album_ListViewController alloc]init];
    
    albumLVC.titleString = _albumView.titleLabel.text;
    albumLVC.writerString = _albumView.writerLabel.text;
    albumLVC.discriptionString = _albumView.detailLabel.text;
    
    [self.navigationController pushViewController:albumLVC animated:YES];
    
    
}

// 格式化时间
- (NSString *)p_convertTime:(CGFloat)second
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _tracksList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    
    
    TrackModel *track = _tracksList[indexPath.row];
    
    cell.titleLabel.text = track.title;
    NSString *time = [self p_convertTime:track.duration];
//    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.playTimesLabel.text = [NSString stringWithFormat:@"时长 %@", time];
//    cell.playTimesLabel.textColor = [UIColor whiteColor];
    NSInteger playtimes = track.playtimes;
    if (playtimes >= 10000  ) {
        cell.commentLabel.text = [NSString stringWithFormat:@"收听人数: %.1lf万", playtimes/10000.0];
    } else {
        cell.commentLabel.text = [NSString stringWithFormat:@"收听人数: %ld", playtimes];
    }
//    cell.commentLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


//确定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        // 播放声音视图
        PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
        
        TrackModel *track = _tracksList[indexPath.row];
        
        
        playerVC.urlString = track.playUrl64;
        playerVC.totalSeconds = track.duration;
        playerVC.titleString = track.title;
        playerVC.currentIndex = indexPath.row;
        playerVC.imageUrl = self.album.coverLarge;
        playerVC.albumId = self.albumId;
        playerVC.tracksList = _tracksList;
        
        
        [self presentViewController:playerVC animated:YES completion:^{
            DLog(@"打开播放器");
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
}


// header







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
