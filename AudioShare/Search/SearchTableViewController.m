//
//  SearchTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchViewController.h"
#import "AudioTableViewCell.h"
@interface SearchTableViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong)UISearchBar *searchBar;

@property (nonatomic, strong)UITableView *aTableView;


@end

@implementation SearchTableViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [self.aTableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.navigationItem.title = @"搜索";
    
    //搜索button事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonAction : )];
    
    //返回button事件
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction : )];
    
    
    //布局
    [self createView];
    
    //添加 UISegmentedControl
    [self segmentController];
    
    //注册
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"searchCell"];
    
    
}

//搜索button点击事件
-(void)rightBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"搜索");
    //SearchViewController *searchVC = [[SearchViewController alloc]init];
    //[self.navigationController pushViewController:searchVC animated:YES];
}

//返回button事件
-(void)leftBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"返回");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//添加UISegmentedControl
-(void)segmentController
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"专辑", @"声音"]];
    segmentedControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40);
    segmentedControl.selectedSegmentIndex = 0;
    self.tableView.tableHeaderView = segmentedControl;
    
    
}






-(void)createView
{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 100, 40)];
    
    self.searchBar.placeholder = @"搜索声音、专辑、人";
    
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.keyboardType = UIKeyboardAppearanceDefault;
    
    self.searchBar.showsCancelButton = NO;
    
    self.navigationItem.titleView = _searchBar;
    
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
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
      
    return cell;
}


//确定每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
