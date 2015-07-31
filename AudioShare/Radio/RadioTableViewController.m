//
//  RadioTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioTableViewController.h"
#import "RadioHeader.h"
#import "RadioTableViewCell.h"
#import "RadioProvinceTableViewController.h"
#import "RadioFoxView.h"
#import "API_URL.h"
#import "PlayerViewController.h"

@interface RadioTableViewController ()


@property (nonatomic , strong)RadioFoxView *radioFoxView;
@end

@implementation RadioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    //注册
    [self.tableView registerClass:[RadioTableViewCell class] forCellReuseIdentifier:@"radioCell"];
    self.navigationItem.title = @"电台直播";

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioTableViewCell *foxCell = [tableView dequeueReusableCellWithIdentifier:@"radioCell" forIndexPath:indexPath];
    
    
    
   return foxCell;
}

// 点击某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController *playerVC = [PlayerViewController sharedPlayer];
    // 传url
    playerVC.urlString = kLiveCast;
    
    [self presentViewController:playerVC animated:YES completion:^{
        DLog(@"打开播放器处理");
    }];
    
}



#pragma mark ---- header和footer
//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    self.radioFoxView = [[RadioFoxView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 140)];
    
    
    [self.radioFoxView.networkButton addTarget:self action:@selector(networkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.radioFoxView.countriesButton addTarget:self action:@selector(countriesButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.radioFoxView.provinceButton addTarget:self action:@selector(provinceButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return _radioFoxView;
    
}

// footer
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//}

// cell 的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
}


#pragma mark ---- 电台button点击事件
- (void)networkButtonAction:(UIButton *)sender
{
    
}


- (void)countriesButtonAction:(UIButton *)sender
{
    
}


- (void)provinceButtonAction:(UIButton *)sender
{
    RadioProvinceTableViewController *provinceVC = [[RadioProvinceTableViewController alloc] init];
    
    [self.navigationController pushViewController:provinceVC animated:YES];
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
