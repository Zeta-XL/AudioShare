//
//  SuggestionCollectionViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "SuggestionCollectionViewController.h"
#import "SuggestionCollectionViewCell.h"
#import "SubListViewController.h"
#import "HeaderCollectionReusableView.h"
#import "AlbumTableViewController.h"
#import "RequestTool_v2.h"
#import "UIImageView+WebCache.h"
#import "AudioModel.h"
#import "API_URL.h"
#import "MJRefresh.h"

@interface SuggestionCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
{
    NSInteger _maxPageId;
    NSInteger _currentPageId;
    NSInteger _pageSize;
    BOOL _dragDown;
    BOOL _showSuggestion;
    BOOL _loadEnable;
}
@property (nonatomic, strong)NSMutableArray *tagNameArray;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *currentTagName;
@property (nonatomic, strong)UIActivityIndicatorView *activity;

@property (nonatomic, assign)BOOL networkOK;
@end

@implementation SuggestionCollectionViewController

static NSString * const reuseIdentifier = @"SuggestionCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 初始化数据数组
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[SuggestionCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Register headerView
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self p_navigationBar];
    
    self.apiString = kAudioSuggetionList;
    _loadEnable = YES;
    _showSuggestion = YES;
    _currentPageId = 1;
    _pageSize = 30;
    [self p_dragDownToRefresh];
    [self p_dragUptoLoadMore];
    [self p_setupActivity];
//    self.dataArray = [NSMutableArray array];
//    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];

}

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



#pragma mark ---请求数据刷新数据
// 请求数据
- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    // 刷新数据
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        //////////////////////////
        NSString *params = nil;
        [self.activity startAnimating];
        if (_loadEnable) {
            if (_showSuggestion) {
                // 参数字符串
                
                NSMutableArray *tempArr = [NSMutableArray array];
                
                params = [NSString stringWithFormat:@"categoryId=%@&contentType=album&device=iPhone&version=4.1.7.1", self.categoryId];
                [RequestTool_v2 requestWithURL:_apiString paramString:params postRequest:NO callBackData:^(NSData *data) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                    
                    if ([dict[@"msg"] isEqualToString:@"成功"]) {
                        // 记录小分类列表数组
                        for (NSDictionary *tagDict in dict[@"tags"][@"list"]) {
                            NSString *tagName = tagDict[@"tname"];
                            [_tagNameArray addObject:tagName];
                        }
                        DLog(@"tagNameArray---%@", self.tagNameArray);
                        
                        for (NSDictionary *categoryList in dict[@"categoryContents"][@"list"]) {
                            NSMutableArray *subListArray = [NSMutableArray array];
                            NSDictionary *subListDict = @{@"title":categoryList[@"title"], @"list":subListArray};
                            for (NSDictionary *audioDict in categoryList[@"list"]) {
                                AudioModel *model = [[AudioModel alloc] init];
                                [model setValuesForKeysWithDictionary:audioDict];
                                [subListArray addObject:model];
                            }
                            [tempArr addObject:subListDict];
                            
                        }
                        // 获得maxPageId
                        _maxPageId = [dict[@"tags"][@"maxPageId"] integerValue];
                        DLog(@"maxPageId = %ld", _maxPageId);
                        
                    } else {
                        DLog(@"加载数据无效");
                    }
                    self.dataArray = tempArr;
                    
                    DLog(@"加载完毕--%@, %@", _dataArray[0][@"title"], _dataArray[0][@"list"]);
                    [self.collectionView.footer endRefreshing];
                    [self.collectionView.header endRefreshing];
                    [self.collectionView reloadData];
                    [self.activity stopAnimating];
                    
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                    _loadEnable = YES;
                }];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                _loadEnable = NO;
            } else {
                
                // 参数字符串
                
                NSMutableArray *tempArr = [NSMutableArray array];
                
                params = [NSString stringWithFormat:@"calcDimension=hot&categoryId=%@&device=iPhone&pageId=%ld&pageSize=%ld&status=0&tagName=%@", self.categoryId, pageId, pageSize, _currentTagName];
                DLog(@"currentPageId = %ld", pageId);
                [RequestTool_v2 requestWithURL:_apiString paramString:params postRequest:NO callBackData:^(NSData *data) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                    
                    if ([dict[@"msg"] isEqualToString:@"成功"]) {
                        NSMutableArray *subListArray = [NSMutableArray array];
                        NSDictionary *subListDict = @{@"title":dict[@"title"], @"list":subListArray};
                        for (NSDictionary *audioDict in dict[@"list"]) {
                            AudioModel *m = [[AudioModel alloc] init];
                            [m setValuesForKeysWithDictionary:audioDict];
                            [subListArray addObject:m];
                            
                        }
                        [tempArr addObject:subListDict];
                        
                        // 获得maxPageId
                        _maxPageId = [dict[@"maxPageId"] integerValue];
                        DLog(@"maxPageId = %ld", _maxPageId);
                        
                    } else {
                        DLog(@"加载数据无效");
                    }
                    
                    self.dataArray = tempArr;
                    
                    DLog(@"加载完毕--%@, %@", _dataArray[0][@"title"], _dataArray[0][@"list"]);
                    [self.collectionView.footer endRefreshing];
                    [self.collectionView.header endRefreshing];
                    [self.collectionView reloadData];
                    [self.activity stopAnimating];
                    
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                    _loadEnable = YES;
                }];
                self.navigationItem.leftBarButtonItem.enabled = NO;
                _loadEnable = NO;
            }
        }
        ////////////////////
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.activity stopAnimating];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    }
    
    
}


// 上拉加载
- (void)p_dragUptoLoadMore
{
    // 上拉刷新
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        __weak __typeof(self) weakSelf = self;
        
        self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf p_loadMoreData];
            
        }];
        [self.collectionView.footer beginRefreshing];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.collectionView.footer endRefreshing];
        [self.activity stopAnimating];
    }
   
    
}

// 加载数据
- (void)p_loadMoreData
{
    if (_currentPageId <= _maxPageId) {
        NSString *params = [NSString stringWithFormat:@"calcDimension=hot&categoryId=%@&device=iPhone&pageId=%ld&pageSize=%ld&status=0&tagName=%@", self.categoryId, _currentPageId, _pageSize, _currentTagName];
        
        if (_loadEnable) {
            [self.activity startAnimating];
            [RequestTool_v2 requestWithURL:_apiString paramString:params postRequest:NO callBackData:^(NSData *data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                
                if ([dict[@"msg"] isEqualToString:@"成功"]) {
                    
                    for (NSDictionary *audioDict in dict[@"list"]) {
                        AudioModel *m = [[AudioModel alloc] init];
                        [m setValuesForKeysWithDictionary:audioDict];
                        [_dataArray.firstObject[@"list"] addObject:m];
                    }
                    
                    // 获得maxPageId
                    _maxPageId = [dict[@"maxPageId"] integerValue];
                    DLog(@"maxPageId = %ld", _maxPageId);
                    
                } else {
                    DLog(@"加载更多数据失败");
                }
                DLog(@"加载完毕--%@, %@", _dataArray[0][@"title"], _dataArray[0][@"list"]);
                [self.collectionView.footer endRefreshing];
                [self.collectionView.header endRefreshing];
                [self.activity stopAnimating];
                [self.collectionView reloadData];
                
                self.navigationItem.leftBarButtonItem.enabled = YES;
                _loadEnable = YES;
                DLog(@"当前加载的page:%ld", _currentPageId);
                _currentPageId++;
            }];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            _loadEnable = NO;
        }
        
    } else {
        [self.collectionView.footer noticeNoMoreData];
    }
    // 默认先隐藏footer
    
}


// 下拉刷新
- (void)p_dragDownToRefresh
{
    
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageId = 1;
        if (_showSuggestion) {
            self.tagNameArray = [NSMutableArray array];
            [weakSelf p_requestDataWithPageId:_currentPageId++ pageSize:30];
        } else {
            [weakSelf p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];
        }
        
        
    }];
    [self.collectionView.header beginRefreshing];
    
}








#pragma mark ----navigationBar
- (void)p_navigationBar
{
    self.navigationItem.title = @"推荐内容";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多分类" style:(UIBarButtonItemStyleDone) target:self action:@selector(moreAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
    
    
}

- (void)moreAction:(UIBarButtonSystemItem *)sender
{
    DLog(@"打开更多分类");
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        SubListViewController *subListVC = [[SubListViewController alloc] init];
        // 传值;
        subListVC.titleString = self.categoryName;
        subListVC.tagNameArray = self.tagNameArray;
        subListVC.categoryId = self.categoryId;
        subListVC.backTagName = ^(NSString *tagName){
            self.currentTagName = tagName;
            _currentPageId = 1;
            _pageSize = 21;
            _showSuggestion = NO;
            _loadEnable = YES;
            self.apiString = kSubAudioAlbumList;
            [self p_dragDownToRefresh];
        };

        [self.navigationController pushViewController:subListVC animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    
}

- (void)backAction:(UIBarButtonSystemItem *)sender
{
    // 
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return _dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return [_dataArray[section][@"list"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuggestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    AudioModel *m = _dataArray[indexPath.section][@"list"][indexPath.row];
    cell.tracksCountsLabel.text = [NSString stringWithFormat:@"%02ld", [m.tracksCounts integerValue]];
    cell.albumTitleLabel.text = m.title;
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:m.coverMiddle] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

// 点击cell响应事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    self.networkOK = [[NSUserDefaults standardUserDefaults] boolForKey:@"networkOK"];
    if (_networkOK) {
        
        AudioModel *m = _dataArray[indexPath.section][@"list"][indexPath.row];
        
        AlbumTableViewController *albumVC = [[AlbumTableViewController alloc] init];
        albumVC.albumId = m.albumId;
        [self.navigationController pushViewController:albumVC animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用, 请检查当前网络设置" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark ----UICollectionViewDelegateFlowLayout

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds .size.width - 10 * 2 - 10 * 2) / 3;
    CGFloat height = width * 1.5;
    
    
    return  CGSizeMake(width, height);
    
}

// 内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// footer 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == _dataArray.count - 1) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    } else {
        return CGSizeMake(1, 1);
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 30);
}

// header 的view
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
 
    HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (_dataArray.count == 1) {
        headerView.subCategoryLabel.text = self.currentTagName;
    } else {
        headerView.subCategoryLabel.text = _dataArray[indexPath.section][@"title"];
    }
    
    
    return headerView;
    
}




#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
