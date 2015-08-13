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
@property (nonatomic, assign)BOOL networkOK;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation RadioTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.titleString;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *v1 = [UIImage imageNamed:@"v1.jpg"];
    UIImage *v2 = [UIImage imageNamed:@"v2.jpg"];
    UIImage *v3 = [UIImage imageNamed:@"v3.jpg"];
    self.imageArray = @[v1, v2, v3];
    //注册
    [self.tableView registerClass:[RadioTableViewCell class] forCellReuseIdentifier:@"radioCell"];
    self.titleString = @"广播电台";
    [self p_setupActivity];
    self.radioFoxView = [[RadioFoxView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 90)];
    [self.radioFoxView.networkButton addTarget:self action:@selector(networkButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.radioFoxView.countriesButton addTarget:self action:@selector(countriesButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.radioFoxView.provinceButton addTarget:self action:@selector(provinceButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _radioFoxView.foxLabel.text = @"国家电台列表";
    _radioFoxView.backImageView.image = _imageArray[1];
    self.pageSize = 15;
    self.currentPageId = 1;
    self.radioType = 1;
    self.provinceCode = @"110000";
    self.radioArray = [NSMutableArray array];
    self.loadEnable = YES;
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    [self p_dragUptoLoadMore];
    
}


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
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        [self.activity startAnimating];
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
                
                
                [self.tableView reloadData];
                [self.activity stopAnimating];
                self.loadEnable = YES;
                self.navigationItem.leftBarButtonItem.enabled = YES;
                [self.tableView.footer endRefreshing];
                
                
            }];
        }
        self.loadEnable = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.activity stopAnimating];
    }
    
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
    [foxCell.radioImageView sd_setImageWithURL:[NSURL URLWithString:[_radioArray[indexPath.row]radioCoverSmall]] placeholderImage:[UIImage imageNamed:@"radio_btn.jpg"]];
    
    
   return foxCell;
}

//选中行 模态至播放器页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
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
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}






//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  90;
}


//添加区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
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
    
    if (_loadEnable) {
        self.radioFoxView.foxLabel.text = @"网络电台列表";
        _radioFoxView.backImageView.image = _imageArray[0];
    }
    self.radioType = 3;
    self.currentPageId = 1;
    self.radioArray = [NSMutableArray array];
    [self.tableView reloadData];
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    
    
    
}


//国家电台按钮点击方法
- (void)countriesButtonAction:(UIButton *)sender
{
    if (_loadEnable) {
        self.radioFoxView.foxLabel.text = @"国家电台列表";
        _radioFoxView.backImageView.image = _imageArray[1];
    }
    self.radioType = 1;
    self.currentPageId = 1;
    self.radioArray = [NSMutableArray array];
    [self.tableView reloadData];
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    

}

//省市电台按钮点击方法
- (void)provinceButtonAction:(UIButton *)sender
{
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        RadioProvinceTableViewController *provinceVC = [[RadioProvinceTableViewController alloc] init];
        //    provinceVC.string = _radioProvinveString;
        self.radioType = 2;
        self.currentPageId = 1;
        provinceVC.province = ^(NSString *aString){
            self.radioArray = [NSMutableArray array];
            self.provinceCode = aString;
            [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
            self.radioFoxView.foxLabel.text = @"地方电台列表";
            _radioFoxView.backImageView.image = _imageArray[2];
        };
        [self.navigationController pushViewController:provinceVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80;
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
