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
#import "MJRefresh.h"

@interface RadioTableViewController ()

@property (nonatomic, strong)NSMutableArray *radioArray;

@property (nonatomic, strong)RadioFoxView *radioFoxView;

@property (nonatomic, assign)NSInteger radioType;
@property (nonatomic, copy)NSString *provinceCode;
@property (nonatomic, assign)NSInteger maxPageId;
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, assign)NSInteger currentPageId;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)BOOL loadEnable;
// 默认位置
@property (nonatomic, assign)CGPoint defaultOffSet;
@end

@implementation RadioTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.titleString;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    //注册
    [self.tableView registerClass:[RadioTableViewCell class] forCellReuseIdentifier:@"radioCell"];
    self.navigationItem.title = @"国家电台直播";
    
    
    self.pageSize = 15;
    self.currentPageId = 1;
    self.radioType = 1;
    self.provinceCode = @"110000";
    self.radioArray = [NSMutableArray array];
    self.loadEnable = YES;
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    
    [self p_dragUptoLoadMore];

}

#pragma mark ---- 加载更多数据;
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






- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    NSString *params = nil;
    if (self.radioType == 2) {
        params = [NSString stringWithFormat:@"pageNum=%ld&radioType=2&device=iPhone&provinceCode=%@&pageSize=%ld", pageId, self.provinceCode, pageSize];
    } else {
        params = [NSString stringWithFormat:@"pageNum=%ld&radioType=%ld&device=iPhone&pageSize=%ld", pageId, self.radioType, pageSize];
    }
    
    if (_loadEnable) {
        [RequestTool_v2 requestWithURL:kRadioUrl paramString:params postRequest:NO callBackData:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            
            if ([dict[@"ret"] isEqualToString:@"0000"]) {
                for (NSDictionary *radioDict in dict[@"result"]) {
                    Radio *rad = [[Radio alloc] init];
                    [rad setValuesForKeysWithDictionary:radioDict];
                    [_radioArray addObject:rad];
                    // 获得maxPageId
                    _maxPageId = [dict[@"total"] integerValue] % pageSize == 0 ? ([dict[@"total"] integerValue] / pageSize) : ([dict[@"total"] integerValue] / pageSize) + 1;
                }
                
                DLog(@"maxPageId = %ld", _maxPageId);
                
            } else {
                DLog(@"加载数据无效");
            }
            
            self.tableView.scrollEnabled = YES;
            [self.tableView reloadData];
            self.loadEnable = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.tableView.footer endRefreshing];
            
            
        }];
    }
    self.loadEnable = NO;
    self.tableView.scrollEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
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
    [foxCell.radioImageView sd_setImageWithURL:[NSURL URLWithString:[_radioArray[indexPath.row]radioCoverSmall]] placeholderImage:[UIImage imageNamed:@"radio_btn@2x.jpg"]];
    
    
   return foxCell;
}

//选中行 模态至播放器页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController *pVC = [PlayerViewController sharedPlayer];
    
    
    //传值
    Radio *radio = _radioArray[indexPath.row];
    pVC.urlString = radio.radioPlayUrl;
    pVC.titleString = radio.programName;
    pVC.liveStartTime = radio.startTime;
    pVC.liveEndTime = radio.endTime;
    pVC.imageUrl = radio.radioCoverLarge;
    pVC.currentIndex = 0;
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



//网络电台按钮点击方法
- (void)networkButtonAction:(UIButton *)sender
{
    if (self.tableView.decelerating == NO || self.tableView.dragging == NO) {
        self.radioType = 3;
        self.currentPageId = 1;
        self.radioArray = [NSMutableArray array];

        [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    }
    
}


//国家电台按钮点击方法
- (void)countriesButtonAction:(UIButton *)sender
{
    if (self.tableView.decelerating == NO || self.tableView.dragging == NO) {
        self.radioType = 1;
        self.currentPageId = 1;
        self.radioArray = [NSMutableArray array];
        [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    }
    
    

}

//省市电台按钮点击方法
- (void)provinceButtonAction:(UIButton *)sender
{
    RadioProvinceTableViewController *provinceVC = [[RadioProvinceTableViewController alloc] init];
//    provinceVC.string = _radioProvinveString;
    self.radioType = 2;
    self.currentPageId = 1;
    provinceVC.province = ^(NSString *aString){
        self.radioArray = [NSMutableArray array];
        self.provinceCode = aString;
        [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    };
  
    [self.navigationController pushViewController:provinceVC animated:YES];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
