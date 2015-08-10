//
//  RadioProvinceTableViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioProvinceTableViewController.h"
#import "RequestTool_v2.h"
#import "RadioHeader.h"
#import "RadioProvince.h"

#import "Radio.h"

@interface RadioProvinceTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@end

@implementation RadioProvinceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请选择要听的省市";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"provinceCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
    [self p_setupActivity];
    
    self.dataArray = [NSMutableArray array];
    [self.activity startAnimating];
    [RequestTool_v2 requestWithURL:kUrlCity paramString:nil postRequest:NO callBackData:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        if ([dict[@"ret"] isEqualToString:@"0000"]) {
            for (NSDictionary *d in dict[@"result"]) {
                RadioProvince *rp = [[RadioProvince alloc]init];
                [rp setValuesForKeysWithDictionary:d];
                [_dataArray addObject:rp];
                
            };
        }
        [self.activity stopAnimating];
        [self.tableView reloadData];

    }];
    
    
    
    
    
}


- (void)backAction:(UIBarButtonItem *)sender
{
    DLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

//进度轮
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell" forIndexPath:indexPath];
    
    RadioProvince *radioProvince = _dataArray[indexPath.row];
    
    cell.textLabel.text = radioProvince.provinceName;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //RadioProvinceTableViewController *rptVC = [[RadioProvinceTableViewController alloc]init];
    
    
    
    RadioProvince *radioProvince = _dataArray[indexPath.row];
    _province(radioProvince.provinceCode);
   
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
