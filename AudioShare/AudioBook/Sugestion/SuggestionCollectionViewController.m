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
    self.tagNameArray = [NSMutableArray array];
    self.apiString = kAudioSuggetionList;
    _loadEnable = YES;
    _showSuggestion = YES;
    _currentPageId = 1;
    _pageSize = 30;
    [self p_dragDownToRefresh];
    [self p_dragUptoLoadMore];
    self.dataArray = [NSMutableArray array];
    [self p_requestDataWithPageId:_currentPageId++ pageSize:_pageSize];

}

#pragma mark ---请求数据刷新数据
// 请求数据
- (void)p_requestDataWithPageId:(NSInteger)pageId
                       pageSize:(NSInteger)pageSize
{
    
    NSString *params = nil;
    
    if (_loadEnable) {
        if (_showSuggestion) {
            // 参数字符串
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
                        [_dataArray addObject:subListDict];
                        
                    }
                    // 获得maxPageId
                    _maxPageId = [dict[@"tags"][@"maxPageId"] integerValue];
                    DLog(@"maxPageId = %ld", _maxPageId);
                    
                } else {
                    DLog(@"加载数据无效");
                }
                DLog(@"加载完毕--%@, %@", _dataArray[0][@"title"], _dataArray[0][@"list"]);
                [self.collectionView.footer endRefreshing];
                [self.collectionView.header endRefreshing];
                [self.collectionView reloadData];
                
                self.navigationItem.leftBarButtonItem.enabled = YES;
                _loadEnable = YES;
            }];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            _loadEnable = NO;
        } else {
            
            // 参数字符串
            params = [NSString stringWithFormat:@"calcDimension=hot&categoryId=%@&device=iPhone&pageId=%ld&pageSize=%ld&status=0&tagName=%@", self.categoryId, pageId, pageSize, _currentTagName];
            
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
                    [_dataArray addObject:subListDict];
                    
                    // 获得maxPageId
                    _maxPageId = [dict[@"maxPageId"] integerValue];
                    DLog(@"maxPageId = %ld", _maxPageId);
                    
                } else {
                    DLog(@"加载数据无效");
                }
                DLog(@"加载完毕--%@, %@", _dataArray[0][@"title"], _dataArray[0][@"list"]);
                [self.collectionView.footer endRefreshing];
                [self.collectionView.header endRefreshing];
                [self.collectionView reloadData];
                
                self.navigationItem.leftBarButtonItem.enabled = YES;
                _loadEnable = YES;
            }];
            self.navigationItem.leftBarButtonItem.enabled = NO;
            _loadEnable = NO;
        }
    }
    
}


// 上拉加载
- (void)p_dragUptoLoadMore
{
    // 上拉刷新
    __weak __typeof(self) weakSelf = self;
    
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf p_loadMoreData];
        
        
    }];
    // 默认先隐藏footer
    [self.collectionView.footer beginRefreshing];
    
    
}

// 加载数据
- (void)p_loadMoreData
{
    if (_currentPageId <= _maxPageId) {
        NSString *params = [NSString stringWithFormat:@"calcDimension=hot&categoryId=%@&device=iPhone&pageId=%ld&pageSize=%ld&status=0&tagName=%@", self.categoryId, _currentPageId, _pageSize, _currentTagName];
        
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
            [self.collectionView reloadData];
            
            self.navigationItem.leftBarButtonItem.enabled = YES;
            _loadEnable = YES;
            _currentPageId++;
        }];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        _loadEnable = NO;
        
    } else {
        [self.collectionView.footer noticeNoMoreData];
    }
}


// 下拉刷新
- (void)p_dragDownToRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        // 刷新数据
        _currentPageId = 1;
        self.dataArray = [NSMutableArray array];
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
    
    SubListViewController *subListVC = [[SubListViewController alloc] init];
    // 传值;
    subListVC.titleString = self.categoryName;
    subListVC.tagNameArray = self.tagNameArray;
    subListVC.backTagName = ^(NSString *tagName){
        self.currentTagName = tagName;
        _currentPageId = 1;
        _pageSize = 21;
        _showSuggestion = NO;
        self.apiString = kSubAudioAlbumList;
        [self p_dragDownToRefresh];
    };
    
    
    [self.navigationController pushViewController:subListVC animated:YES];
    
    
    
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
    cell.tracksCountsLabel.text = [NSString stringWithFormat:@"共%@集", m.tracksCounts];
    cell.albumTitleLabel.text = m.title;
    [cell.albumImageView sd_setImageWithURL:[NSURL URLWithString:m.coverMiddle] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

// 点击cell响应事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    
    AudioModel *m = _dataArray[indexPath.section][@"list"][indexPath.row];
    
    AlbumTableViewController *albumVC = [[AlbumTableViewController alloc] init];
    albumVC.albumId = m.albumId;
    [self.navigationController pushViewController:albumVC animated:YES];
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
