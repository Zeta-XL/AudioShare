//
//  SearchTableViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SearchTableViewController.h"
#import "AudioTableViewCell.h"
#import "RequestTool_v2.h"
#import "API_URL.h"
#import "SearchModel.h"
#import "UIImageView+WebCache.h"
#import "AlbumTableViewController.h"
#import "MJRefresh.h"
@interface SearchTableViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    
    NSInteger _numFound;
    NSInteger _currentPageId;
    NSInteger _pageSize;
    NSInteger _maxPageId;
    BOOL _loadEnable;
    
}

@property (nonatomic, strong)UISearchBar *searchBar;


@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIActivityIndicatorView *activity;

@end

@implementation SearchTableViewController


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
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
    
    [self headerView];
    
    //注册
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"searchCell"];
    
    
    _currentPageId = 1;
    _pageSize = 30;
    
    _loadEnable = YES;
    
    // 上拉加载
    [self p_dragUptoLoadMore];
    self.tableView.footer.hidden = YES;
    self.tableView.tableHeaderView.hidden = YES;
    [self p_setupActivity];
}


//进度轮
- (void)p_setupActivity
{
    //进度轮
    self.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 80, 50)];
    self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activity.backgroundColor = [UIColor grayColor];
    self.activity.alpha = 0.3;
    self.activity.layer.cornerRadius = 6;
    self.activity.layer.masksToBounds = YES;
    
    //显示位置
    [self.activity setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    
    [self.view addSubview:_activity];
}

-(void)p_requestDataWithPageId:(NSInteger)pageId
                      pageSize:(NSInteger)pageSize
{
    
    self.kw = self.searchBar.text;
    
    NSString *params = [NSString stringWithFormat:@"device=android&condition=relation&core=album&kw=%@&page=%ld&rows=%ld", self.kw, pageId, pageSize];
    
    if (_loadEnable) {
        [self.activity startAnimating];
        [RequestTool_v2 requestWithURL:kSearchUrl paramString:params postRequest:nil callBackData:^(NSData *data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            

            NSDictionary *dic = [dict objectForKey:@"response"];
            NSArray *arr = [dic objectForKey:@"docs"];
            
            DLog(@"%@", arr);
            
            if ([dict[@"response"][@"docs"] count] != 0) {
                
                for (NSDictionary *d in dict[@"response"][@"docs"]) {
                    SearchModel *sm = [[SearchModel alloc]init];
                    [sm setValuesForKeysWithDictionary:d];
                    [_dataArray addObject:sm];
                }
                
                // 获得maxPageId
                NSInteger maxNum = [dict[@"response"][@"numFound"] integerValue];
                
                _maxPageId = maxNum % _pageSize == 0 ? (maxNum / pageSize) : (maxNum / pageSize) + 1;
                
                DLog(@"pageId = %ld", _maxPageId);
            }else {
                
                DLog(@"加载数据无效");
                self.tableView.tableHeaderView.hidden = NO;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.tableView.tableHeaderView.hidden = YES;
                });
            }
            
            if (_maxPageId != 0) {
                [self.tableView.footer endRefreshing];
                [self.tableView.header endRefreshing];
            }
 
            [self.tableView reloadData];
            [self.activity stopAnimating];
            _loadEnable = YES;
            self.tableView.scrollEnabled = YES;
            self.tableView.footer.hidden = NO;
        }];
        _loadEnable = NO;
        self.tableView.scrollEnabled = NO;
    }
    
}




//搜索button点击事件
-(void)rightBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"搜索");
    
    
    if (self.tableView.decelerating == NO && _loadEnable) {
        _currentPageId = 1;
        self.dataArray = [NSMutableArray array];
        [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
        [self.searchBar resignFirstResponder];
    }
    
    
    
}

#pragma mark ---- 上拉刷新和下拉刷新
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


//返回button事件
-(void)leftBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"返回");
    
    [self.navigationController popViewControllerAnimated:YES];
}

//添加UISegmentedControl
-(void)headerView
{
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"专辑", @"声音"]];
//    segmentedControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40);
//    segmentedControl.selectedSegmentIndex = 0;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 20)];
    label.text = @"未搜索到结果";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    
}

//加载searchBar
-(void)createView
{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 100, 40)];
    
    self.searchBar.placeholder = @"搜索专辑";
    
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.keyboardType = UIKeyboardAppearanceDefault;
    
    self.searchBar.showsCancelButton = NO;
    
    self.navigationItem.titleView = _searchBar;
    _searchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self rightBarButtonAction:nil];
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
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    SearchModel *sm = _dataArray[indexPath.row];
    
    cell.titleLabel.text = sm.title;
    
    cell.tagsLabel.text = sm.tags;
    
    cell.tracksCountsLabel.text = [NSString stringWithFormat:@"共%@集", sm.tracks];
    
     [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row]cover_path]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
      
    return cell;
}

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewController *albumTVC = [[AlbumTableViewController alloc]init];
    
    SearchModel *sm = _dataArray[indexPath.row];
    
    DLog(@"%@",sm.albumId);
    
    albumTVC.albumId = sm.albumId;
    
    [self.navigationController pushViewController:albumTVC animated:YES];
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
