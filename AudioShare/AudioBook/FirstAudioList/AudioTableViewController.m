//
//  AudioTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioTableViewController.h"
#import "AudioTableViewCell.h"
#import "AlbumTableViewController.h"
#import "AudioBookCategoryCollectionViewController.h"

@interface AudioTableViewController ()

@end

@implementation AudioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //右button事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"逛逛书城" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonAction : )];
    
    //左button事件
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction : )];
    
    
    //注册
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

//右button点击事件
-(void)rightBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"逛逛书城");
    // CollectionFlowLayout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    AudioBookCategoryCollectionViewController *audiocateVC = [[AudioBookCategoryCollectionViewController alloc] initWithCollectionViewLayout:flow];
    
    [self.navigationController pushViewController:audiocateVC animated:YES];
    
    
}

//左button点击事件
-(void)leftBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"刷新");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //cell小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
//确定每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

//跳转到专辑页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewController *albumTVC = [[AlbumTableViewController alloc]init];
    [self.navigationController pushViewController:albumTVC animated:YES];
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
