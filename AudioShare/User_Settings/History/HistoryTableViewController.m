//
//  HistoryTableViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "AudioTableViewCell.h"
#import "HistoryModel.h"
#import "DataBaseHandle.h"
#import "UIImageView+WebCache.h"
#import "TrackModel.h"
#import "PlayerViewController.h"
#import "RequestTool_v2.h"

@interface HistoryTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tracksList;
@property (nonatomic, assign)BOOL networkOK;
@end

@implementation HistoryTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_loadDataFromDatabase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"historyCell"];
    self.navigationItem.title = @"播放历史";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash"] style:(UIBarButtonItemStyleDone) target:self action:@selector(p_deleteAllHistoryAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    PlayerViewController *player = [PlayerViewController sharedPlayer];
    DLog(@"playing------%d, playforegroud--------%d", player.isPlaying, player.foreground);
    if (player.isPlaying && player.foreground == NO && player.lastItem.isLiveCast == NO) {
        [player p_saveCurrentAlbumInfo];
    }
    
    
    
    
    
}

// 加载数据库数据
- (void)p_loadDataFromDatabase
{
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    self.dataArray = [[[DataBaseHandle shareDataBase] selectAllFromTable:kHistoryTableName historyProperty:[HistoryModel historyPropertyNames] sidOption:NO] mutableCopy];
    
    [[DataBaseHandle shareDataBase] closeDB];
    
    
    if (self.dataArray.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        label.text = @"没有历史记录..";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = label;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        // 数组排序
        [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *timeStampStr1 = [(HistoryModel *)obj1 timestamp];
            NSString *timeStampStr2 = [(HistoryModel *)obj2 timestamp];
            NSTimeInterval t1 = [timeStampStr1 doubleValue];
            NSTimeInterval t2 = [timeStampStr2 doubleValue];
            return -[@(t1) compare:@(t2)];
        }];
        
    }
    [self.tableView reloadData];
}


- (void)p_deleteAllHistoryAction:(UIBarButtonItem *)sender;
{
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    
    [[DataBaseHandle shareDataBase] dropTableWithName:kHistoryTableName];
    
    self.dataArray = [[[DataBaseHandle shareDataBase] selectAllFromTable:kHistoryTableName historyProperty:[AlbumModel propertyNames] sidOption:NO] mutableCopy];
    
    [[DataBaseHandle shareDataBase] closeDB];
    
    if (self.dataArray.count == 0 || self.dataArray == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        label.text = @"没有历史记录..";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = label;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    NSString *cachePath = [[DataBaseHandle shareDataBase] getPathOf:Cache];
    NSString *userHistoryPath = [cachePath stringByAppendingPathComponent:@"user/history"];
    
    [[NSFileManager defaultManager] removeItemAtPath:userHistoryPath error:nil];
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    HistoryModel *history = _dataArray[indexPath.row];
    
    cell.titleLabel.text = history.albumTitle;
    cell.tagsLabel.text = history.trackTitle;
    cell.tagsLabel.font = [UIFont systemFontOfSize:13.f];
    
    cell.tracksCountsLabel.text = @"当前播放到:";
    cell.timeLabel.text = history.currentTime;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:history.coverSmall] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryModel *history = _dataArray[indexPath.row];
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        [self p_unarchiveWithTrackListName:history.archiveName albumId:history.albumId];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

// 反归档
- (void)p_unarchiveWithTrackListName:(NSString *)tracksListName albumId:(NSString *)albumId
{
    // 用户数据路径
    
    NSString *cachePath = [[DataBaseHandle shareDataBase] getPathOf:Cache];
    
    NSString *trackListPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/user/history/%@", tracksListName]];
    
    
    BOOL trackListExist = [[NSFileManager defaultManager] fileExistsAtPath:trackListPath];
    
    if (trackListExist) {
        // 反归档获取播放列表
        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:trackListPath];
        
        NSInteger index = [dataDict[@"lastIndex"] integerValue];
        NSInteger tracksCount = [dataDict[@"tracksCount"] integerValue];
        CGFloat lastSeconds = [dataDict[@"lastSeconds"] doubleValue];
        NSString *imgUrl = dataDict[@"imageUrl"];
        
        
        
        __weak typeof(self) weakSelf = self;
        self.handleTrackList = ^(NSMutableArray *trackList){
            if (tracksCount != 0 && trackList.count != 0) {
                PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
                playerVC.tracksList = trackList;
                playerVC.lastSeconds = lastSeconds;
                playerVC.currentIndex = index;
                playerVC.imageUrl = imgUrl;
                TrackModel *track = trackList[index];
                playerVC.totalSeconds = track.duration;
                playerVC.titleString = track.title;
                playerVC.urlString = track.playUrl64;
                playerVC.historyFlag = YES;
                playerVC.albumId = track.albumId;
                if (weakSelf.isModal) {
                    [weakSelf backToPlayer:nil];
                } else {
                    [weakSelf presentViewController:playerVC animated:YES completion:nil];
                }
                
            } else {
                DLog(@"当前网络不稳定");
            }
            
        };
        
        [self p_requestDataWithPageId:1 pageSize:tracksCount albumId:albumId];
        
    }
}

// 请求数据
- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
                        albumId:(NSString *)albumId
{
    
    NSString *params = [NSString stringWithFormat:@"pageId=%ld&pageSize=%ld&albumId=%@", pageId, pageSize, albumId];
    
    [RequestTool_v2 requestWithURL:kDetailAlbumList paramString:params postRequest:NO callBackData:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSMutableArray *tracksList = [NSMutableArray array];
        if ([dict[@"msg"] isEqualToString:@"0"]) {
            // 获取声音model
            
            for (NSDictionary *d in dict[@"tracks"][@"list"]) {
                TrackModel *trackm = [[TrackModel alloc] init];
                [trackm setValuesForKeysWithDictionary:d];
                [tracksList addObject:trackm];
            }
            

        } else {
            DLog(@"加载数据无效");
        }
        
        self.handleTrackList(tracksList);
        
    }];
    
}


- (void)backToPlayer:(UIBarButtonItem *)leftbutton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
