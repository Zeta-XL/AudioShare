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

@interface AlbumTableViewController ()
{
    NSInteger _pageSize;
    NSInteger _maxPageId;
    NSInteger _currentPageId;
}
@property (nonatomic, strong)AlbumView *albumView;
@property (nonatomic, strong)NSMutableArray *tracksList;
@property (nonatomic, strong)AlbumModel *album;
@end

@implementation AlbumTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(backButtonAction:)];
    
    //注册
    [self.tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:@"AlbumCell"];
    _pageSize = 20;
    _currentPageId = 1;
    self.tracksList = [NSMutableArray array];
    
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    
    [self p_dragUptoLoadMore];
     
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
            DLog(@"%@", dict[@"tracks"][@"list"]);
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
            self.navigationItem.title = _album.categoryName;
            // 加载自定义albumView视图
            [self p_albumView];
            
        } else {
            DLog(@"加载数据无效");
        }
        
        if (_maxPageId != 0) {
            [self.tableView.footer endRefreshing];
        }
        
        [self.tableView reloadData];
    }];
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








//自定义albumView视图
-(void)p_albumView
{
    self.albumView = [[AlbumView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 220)];
    self.tableView.tableHeaderView = _albumView;
    [_albumView.albumImageView sd_setImageWithURL:[NSURL URLWithString:_album.coverLarge] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _albumView.titleLabel.text = _album.title;
    _albumView.writerLabel.text = [NSString stringWithFormat:@"作者: %@",  _album.nickname];
    _albumView.detailLabel.text = [NSString stringWithFormat:@"简介: %@",  _album.intro];
    
}

// 格式化时间
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
    
    [cell.optionButton setTitle:@"下载" forState:(UIControlStateNormal)];
    cell.titleLabel.text = track.title;
    NSString *time = [self p_convertTime:track.duration];
  
    cell.playTimesLabel.text = [NSString stringWithFormat:@"时长 %@", time];
    cell.commentLabel.text = [NSString stringWithFormat:@"第%ld个", indexPath.row +1];
    
    
    return cell;
}


//确定每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 播放声音视图
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    
    
    TrackModel *track = _tracksList[indexPath.row];
    
    
    playerVC.urlString = track.playUrl64;
    playerVC.totalSeconds = track.duration;
    playerVC.titleString = track.title;
    playerVC.currentIndex = indexPath.row;
    playerVC.imageUrl = self.album.coverLarge;

    playerVC.tracksList = _tracksList;
    
 
    [self presentViewController:playerVC animated:YES completion:^{
        DLog(@"打开播放器");
    }];
    
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
