//
//  FavorateTableViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "FavorateTableViewController.h"
#import "AudioTableViewCell.h"
#import "RequestTool_v2.h"
#import "DataBaseHandle.h"
#import "UIImageView+WebCache.h"
#import "AlbumModel.h"
#import "AlbumTableViewController.h"
#import "API_URL.h"

@interface FavorateTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)BOOL onceFlag;
@property (nonatomic, assign)BOOL networkOK;
@end

@implementation FavorateTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //打开数据库 //
    
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    self.dataArray = [[[DataBaseHandle shareDataBase] selectAllFromTable:kFavorateTableName modelProperty:[AlbumModel propertyNames] sidOption:NO] mutableCopy];
    
    
    [[DataBaseHandle shareDataBase] closeDB];
    
    
    if (self.dataArray.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        label.text = @"没有收藏记录..";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = label;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    [self.tableView reloadData];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"favorateCell"];
    self.navigationItem.title = @"收藏专辑";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteAllAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"trash"] style:(UIBarButtonItemStyleDone) target:self action:@selector(deleteAllAction:)];
    
    // 数据库更新
    DLog(@"once--------------------");
    NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
    [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
    
    
    NSArray *resultArray = [[[DataBaseHandle shareDataBase] selectAllFromTable:kFavorateTableName modelProperty:[AlbumModel propertyNames] sidOption:NO] mutableCopy];
    
    [[DataBaseHandle shareDataBase] closeDB];
    
    if (resultArray.count != 0) {
        
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        
        
        for (AlbumModel *am in resultArray) {
            dispatch_group_async(group, globalQueue, ^{
                [self p_requestDataWithAlbumId:am.albumId];
            });
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
            [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
            
            self.dataArray = [[[DataBaseHandle shareDataBase] selectAllFromTable:kFavorateTableName modelProperty:[AlbumModel propertyNames] sidOption:NO] mutableCopy];
            
            [[DataBaseHandle shareDataBase] closeDB];
            [self.tableView reloadData];
        });
        
    }
    
    
    
    
    
    
    
}

// 请求数据更新数据库
- (void)p_requestDataWithAlbumId:(NSString *)albumId
{
    DLog(@"currentThread---%@",[NSThread currentThread]);
    NSString *params = [NSString stringWithFormat:@"pageId=1&pageSize=1&albumId=%@", albumId];
    
    [RequestTool_v2 requestWithURL:kDetailAlbumList paramString:params postRequest:NO callBackData:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        if ([dict[@"msg"] isEqualToString:@"0"]) {
            
            AlbumModel *album = [[AlbumModel alloc] init];
            [album setValuesForKeysWithDictionary:dict[@"album"]];
            DLog(@"albumId=%@", album.albumId);
            // 数据库更新
            NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
            [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
            
            NSArray *resultArray = [[DataBaseHandle shareDataBase] selectFromTable:kFavorateTableName withKey:@"albumId" pairValue:albumId modelProperty:[AlbumModel propertyNames]];
            
            if ( ![[resultArray.firstObject tracksCount] isEqualToString:album.tracksCount] ) {
                [[DataBaseHandle shareDataBase] updateTable:kFavorateTableName changeDict:@{@"tracksCount": album.tracksCount} atPrimaryKey:@"albumId" primaryKeyValue:albumId];
                DLog(@"更新-----完成");
            } else {
                DLog(@"没有-----更新");
            }
            [[DataBaseHandle shareDataBase] closeDB];
            
            
        } else {
            DLog(@"加载数据无效, 未更新数据库");
        }
        
    }];
    
    
    
    
    
}



- (void)deleteAllAction:(UIBarButtonItem *)sender
{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"是否删除所有收藏记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *docPath = [[DataBaseHandle shareDataBase] getPathOf:Document];
        [[DataBaseHandle shareDataBase] openDBWithName:kDBName atPath:docPath];
        
        
        [[DataBaseHandle shareDataBase] dropTableWithName:kFavorateTableName];
        
        
        [[DataBaseHandle shareDataBase] closeDB];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        label.text = @"没有收藏记录..";
        label.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableHeaderView = label;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.dataArray = nil;
        [self.tableView reloadData];
    }
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorateCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    AlbumModel *album = _dataArray[indexPath.row];
    cell.titleLabel.text = album.title;
    cell.tagsLabel.text = album.tags;
    cell.tracksCountsLabel.text = [NSString stringWithFormat:@"共%@集",album.tracksCount];
    
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString: album.coverLarge] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

// cell 的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

// 点击cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        AlbumTableViewController *albumTVC = [[AlbumTableViewController alloc] init];
        
        AlbumModel *album = _dataArray[indexPath.row];
        
        albumTVC.albumId = album.albumId;
        
        [self.navigationController pushViewController:albumTVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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
