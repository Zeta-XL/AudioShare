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

@interface AlbumTableViewController ()

@property (nonatomic, strong)AlbumView *albumView;

@end

@implementation AlbumTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //注册
    [self.tableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:@"AlbumCell"];
    //自定义albumView视图
    [self p_albumView];
    
    
}


//自定义albumView视图
-(void)p_albumView
{
    self.albumView = [[AlbumView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 250)];
    self.tableView.tableHeaderView = _albumView;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    
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
    
    playerVC.urlString = kStreamUrl1;
    
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
