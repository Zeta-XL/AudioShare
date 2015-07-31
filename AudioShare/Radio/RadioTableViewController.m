//
//  RadioTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "RadioTableViewController.h"
#import "API_URL.h"
#import "RadioTableViewCell.h"
#import "RadioProvinceTableViewController.h"
#import "RadioFoxView.h"
#import "RequestTool_v2.h"
#import "Radio.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"
#import "RadioProvince.h"

@interface RadioTableViewController ()

@property (nonatomic, strong)NSMutableArray *radioArray;

@property (nonatomic, strong)RadioFoxView *radioFoxView;

@property (nonatomic, strong)NSString *radioProvinveString;

@end

@implementation RadioTableViewController




- (void)viewDidLoad {
    [super viewDidLoad];
 
    //注册
    [self.tableView registerClass:[RadioTableViewCell class] forCellReuseIdentifier:@"radioCell"];
    
    self.navigationItem.title = @"电台直播";
    
    
    //解析
    self.radioArray = [NSMutableArray array];
    [RequestTool_v2 requestWithURL:kUrlRanking paramString:nil postRequest:NO callBackData:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        for (NSDictionary *radioDict in dict[@"result"]) {
            Radio *r = [[Radio alloc]init];
            [r setValuesForKeysWithDictionary:radioDict];
            [_radioArray addObject:r];
            
            //DLog(@"%@", radioDict);
        }
        
        [self.tableView reloadData];
    } ];
 

    
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
    return _radioArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioTableViewCell *foxCell = [tableView dequeueReusableCellWithIdentifier:@"radioCell" forIndexPath:indexPath];
    
    Radio *radio = _radioArray[indexPath.row];
    
    foxCell.nameLabel.text = radio.rname;
    foxCell.contentLabel.text = radio.programName;

    
    //加载图片
    [foxCell.radioImageView sd_setImageWithURL:[NSURL URLWithString:[_radioArray[indexPath.row]radioCoverSmall]] placeholderImage:[UIImage imageNamed:@"radio_btn@2x"]];
    
    
   return foxCell;
}

//选中行 模态至播放器页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController *pVC = [PlayerViewController sharedPlayer];
    
    
    //传值
    Radio *radio = _radioArray[indexPath.row];
    pVC.urlString = radio.radioPlayUrl;
    pVC.titleString = radio.rname;
    
    [self presentViewController:pVC animated:YES completion:nil];
}






//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  140;
}


//添加区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    self.radioFoxView = [[RadioFoxView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 160)];
    
    
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



//网络电台按钮点击方法
- (void)networkButtonAction:(UIButton *)sender
{
    self.radioArray = [NSMutableArray array];
    
    [RequestTool_v2 requestWithURL:kUrlnetwork paramString:nil postRequest:NO callBackData:^(NSData *data) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        for (NSDictionary *dict in dictionary[@"result"]) {
            Radio *radio = [[Radio alloc]init];
            [radio setValuesForKeysWithDictionary:dict];
            [_radioArray addObject:radio];
            
        }
        
        [self.tableView reloadData];
    }];
}


//国家电台按钮点击方法
- (void)countriesButtonAction:(UIButton *)sender
{
    self.radioArray = [NSMutableArray array];
    
    [RequestTool_v2 requestWithURL:kUrlcountries paramString:nil postRequest:NO callBackData:^(NSData *data) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        for (NSDictionary *dict in dictionary[@"result"]) {
            Radio *radio = [[Radio alloc]init];
            [radio setValuesForKeysWithDictionary:dict];
            [_radioArray addObject:radio];
            
        }
        
        [self.tableView reloadData];
    }];

}

//省市电台按钮点击方法
- (void)provinceButtonAction:(UIButton *)sender
{
    RadioProvinceTableViewController *provinceVC = [[RadioProvinceTableViewController alloc] init];
//    provinceVC.string = _radioProvinveString;
    
    provinceVC.province = ^(NSString *aString){
        
        self.radioProvinveString = aString;
        DLog(@"%@", _radioProvinveString);
        [self p_p];
    };
    
  
    [self.navigationController pushViewController:provinceVC animated:YES];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 110;
}


- (void)p_p
{
    self.radioArray = [NSMutableArray array];
    
    DLog(@"******%@", _radioProvinveString);
    
    [RequestTool_v2 requestWithURL:[NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=1&radioType=2&device=android&provinceCode=%@&pageSize=15", _radioProvinveString] paramString:nil postRequest:NO callBackData:^(NSData *data) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        
        for (NSDictionary *dict in dictionary[@"result"]) {
            Radio *radio = [[Radio alloc]init];
            [radio setValuesForKeysWithDictionary:dict];
            [_radioArray addObject:radio];
            
        }
        
        [self.tableView reloadData];
    }];
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
