//
//  TracksListTableViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/30.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "TracksListTableViewController.h"
#import "TracksListTableViewCell.h"
#import "TrackModel.h"
#import "PlayerViewController.h"
#import "RequestTool_v2.h"
#import "MJRefresh.h"


@interface TracksListTableViewController ()
{
    NSInteger _maxPageId;
    NSInteger _currentPageId;
    NSInteger _pageSize;
}


@end

@implementation TracksListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TracksListTableViewCell class] forCellReuseIdentifier:@"tracksList"];
    
    _pageSize = _trackList.count;
    _currentPageId = 2;
    _maxPageId = 99;
    [self p_dragUptoLoadMore];
    [self p_setupNavigation];
    self.currentIndex = [PlayerViewController sharedPlayer].currentIndex;
}

- (NSString *)p_convertTime:(CGFloat)second
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


- (void)p_setupNavigation
{
    self.navigationItem.title = @"播放列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(confirmAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)backButtonAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        DLog(@"退出列表");
    }];
}

- (void)confirmAction:(UIBarButtonItem *)sender
{
    TrackModel *track = _trackList[self.currentIndex];
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    playerVC.urlString = track.playUrl64;
    playerVC.totalSeconds = track.duration;
    playerVC.titleString = track.title;
    playerVC.currentIndex = self.currentIndex;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _trackList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TracksListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tracksList" forIndexPath:indexPath];
    
    // Configure the cell...
    TrackModel *track = _trackList[indexPath.row];
    
    

    cell.titleLabel.text = track.title;
    NSString *time = [self p_convertTime:track.duration];
    cell.playTimesLabel.text = [NSString stringWithFormat:@"时长 %@", time];
    if (indexPath.row == [PlayerViewController sharedPlayer].currentIndex) {
        cell.titleLabel.textColor = [UIColor orangeColor];
    } else {
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    NSInteger playtimes = track.playtimes;
    if (playtimes >= 10000  ) {
        cell.commentLabel.text = [NSString stringWithFormat:@"收听人数: %.1lf万", playtimes/10000.0];
    } else {
        cell.commentLabel.text = [NSString stringWithFormat:@"收听人数: %ld", playtimes];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


//// header
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40   )];
//    view.backgroundColor = [UIColor whiteColor];
//    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    backButton.frame = CGRectMake(CGRectGetMidX([UIScreen mainScreen].bounds) -40, 30, 80, 20);
//    [backButton setTitle:@"返回" forState:(UIControlStateNormal)];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [view addSubview:backButton];
//    return view;
//}
//
//- (void)backAction:(UIButton *)sender
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        DLog(@"退出列表");
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.currentIndex = indexPath.row;
}

#pragma mark ------- 请求数据
// 请求数据
- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    NSString *params = [NSString stringWithFormat:@"pageId=%ld&pageSize=%ld&albumId=%@", pageId, pageSize, self.albumId];
    
    [RequestTool_v2 requestWithURL:kDetailAlbumList paramString:params postRequest:NO callBackData:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        if ([dict[@"msg"] isEqualToString:@"0"]) {
            // 获取声音model
            
            for (NSDictionary *d in dict[@"tracks"][@"list"]) {
                TrackModel *trackm = [[TrackModel alloc] init];
                [trackm setValuesForKeysWithDictionary:d];
                [_trackList addObject:trackm];
            }
            
            
            
            // 获得maxPageId
            _maxPageId = [dict[@"tracks"][@"maxPageId"] integerValue];
            DLog(@"maxPageId = %ld", _maxPageId);
            
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
