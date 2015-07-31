//
//  SettingTableViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserTableViewCell.h"
@interface SettingTableViewController ()



@property (nonatomic, strong)NSArray *dataArray;

//
@property (nonatomic, strong)UISwitch *mySwitch;


@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"设置";
    
    //注册
    [self.tableView registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"settingCell"];
    
    self.dataArray = @[@"定时关闭", @"仅wifi下播放或下载", @"缓存设置"];
    
    self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 60 , 50, 0, 0)];
    
    [_mySwitch setOn:YES];
    
    [_mySwitch addTarget:self action:@selector(mySwitchAction :) forControlEvents:(UIControlEventValueChanged)];
    
    [self.view addSubview:_mySwitch];
    
}

//UISwitch事件
-(void)mySwitchAction : (UISwitch *)sender
{
    //判断mySwitch状态
    BOOL isSwitch = [_mySwitch isOn];
    
    if (isSwitch) {
        DLog(@"开启仅wifi网络下播放或下载");
    }
    else{
        DLog(@"关闭仅wifi网络下播放或下载");
    }
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    
    
    
    //cell.textLabel.text = @"测试";
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    
    if (indexPath.row != 1) {
        
        //cell小箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    
    return cell;
}

//确定cell高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}


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
