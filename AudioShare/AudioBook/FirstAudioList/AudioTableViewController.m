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
#import "UIImageView+WebCache.h"
#import "API_URL.h"
#import "AudioModel.h"
#import "RequestTool_v2.h"
#import "MJRefresh.h"


@interface AudioTableViewController ()
{
    NSInteger _maxPageId;
    NSInteger _currentPageId;
    NSInteger _pageSize;
    BOOL _dragDown;
    BOOL _refresh;
    
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, assign)BOOL network;
@property (nonatomic, assign)BOOL networkOK;
@end

@implementation AudioTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
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

- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.networkOK = [ud boolForKey:@"networkOK"];
    DLog(@"network-%d", _networkOK);
    if (_networkOK) {
        NSString *params = [NSString stringWithFormat:@"calcDimension=hot&categoryId=%@&device=iPhone&pageId=%ld&pageSize=%ld&status=0&tagName=%@", self.categoryId, pageId, pageSize, self.tagName];
        
        [self.activity startAnimating];
        [RequestTool_v2 requestWithURL:kSubAudioAlbumList paramString:params postRequest:NO callBackData:^(NSData *data) {
            NSMutableArray *tempArr = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            if ([dict[@"msg"] isEqualToString:@"成功"]) {
                
                if (_refresh) {
                    tempArr = [NSMutableArray array];
                } else {
                    tempArr = [NSMutableArray arrayWithArray:_dataArray];
                }
                for (NSDictionary *d in dict[@"list"]) {
                    AudioModel *m = [[AudioModel alloc] init];
                    [m setValuesForKeysWithDictionary:d];
                    
                    [tempArr addObject:m];
                    
                    DLog(@"%@", tempArr);
                }
                // 获得maxPageId
                _maxPageId = [dict[@"maxPageId"] integerValue];
                DLog(@"maxPageId = %ld", _maxPageId);
                
            } else {
                DLog(@"加载数据无效");
            }
            
            
            self.dataArray = tempArr;
            
            [self.tableView reloadData];
            DLog(@"加载完毕");
            
            tempArr = nil;
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self.activity stopAnimating];
        }];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.activity stopAnimating];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }
    
    
    
   
}



- (void)viewDidLoad {
    [super viewDidLoad];
/*    // 图片
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"9.jpg" ]];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
  */  
//    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suggestBack.png"]];
//    backgroudImageView.frame = self.tableView.bounds;
//    self.tableView.backgroundView = backgroudImageView;
//    
    
    
    self.navigationItem.title = @"听我想听";
    
    //右button事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_collection@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonAction : )];
    
    //左button事件
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playback_reload.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction : )];
    
    //注册
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //     默认设置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [ud objectForKey:@"defaultSetting"];
    
    self.categoryId = [dict objectForKey: @"defaultCategoryId"];
    self.tagName = [dict objectForKey:@"defaultTagName"];
    self.dataArray = [NSMutableArray array];
    
    _currentPageId = 1;
    _pageSize = 30;
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
    // 上拉加载
    [self p_dragUptoLoadMore];
    _refresh = YES;
    // 下拉刷新
    [self p_dragDownToRefresh];
    
    [self p_setupActivity];

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
    _refresh = NO;
    if (_currentPageId <= _maxPageId) {
        [self p_requestDataWithPageId:_currentPageId pageSize:_pageSize];
        _currentPageId++;
    } else {
        [self.tableView.footer noticeNoMoreData];
    }
}


// 下拉刷新
- (void)p_dragDownToRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf leftBarButtonAction:nil];
    }];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    
    
}


//右button点击事件
- (void)rightBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"逛逛书城");
    // CollectionFlowLayout
    
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        AudioBookCategoryCollectionViewController *audiocateVC = [[AudioBookCategoryCollectionViewController alloc] initWithCollectionViewLayout:flow];
        
        [self.navigationController pushViewController:audiocateVC animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
}

//左button点击事件
-(void)leftBarButtonAction : (UIBarButtonItem *)sender
{
    DLog(@"刷新");
    _refresh = YES;
    _currentPageId = 1;
    
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //cell小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    AudioModel *m = _dataArray[indexPath.row];
    cell.titleLabel.text = m.title;
//    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.tagsLabel.text = m.tags;
//    cell.tagsLabel.textColor = [UIColor whiteColor];
    cell.tracksCountsLabel.text = [NSString stringWithFormat:@"共%@集",m.tracksCounts];
//    cell.tracksCountsLabel.textColor = [UIColor whiteColor];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row]coverMiddle]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
//确定每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//跳转到专辑页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        AlbumTableViewController *albumTVC = [[AlbumTableViewController alloc] init];
        
        AudioModel *am = _dataArray[indexPath.row];
        
        albumTVC.albumId = am.albumId;
        
        [self.navigationController pushViewController:albumTVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
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
