//
//  AudioBookCategoryCollectionViewController.m
//  ZLD_AudioShare
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "AudioBookCategoryCollectionViewController.h"
#import "AudioBookCategoryCollectionViewCell.h"
#import "SuggestionCollectionViewController.h"
#import "SearchTableViewController.h"
#import "API_URL.h"
#import "RequestTool_v2.h"
#import "AudioCategory.h"
#import "UIImageView+WebCache.h"

@interface AudioBookCategoryCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIActivityIndicatorView *activity;
@end

@implementation AudioBookCategoryCollectionViewController

static NSString * const reuseIdentifier = @"CategoryCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataArray = [NSMutableArray array];
    [self.activity startAnimating];
    [RequestTool_v2 requestWithURL:kAudioCategoryList paramString:nil postRequest:NO callBackData:^(NSData *data) {
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        DLog(@"%@", dict[@"msg"]);
        if ([dict[@"msg"] isEqualToString:@"成功"]) {
            for (NSDictionary *subDict in dict[@"list"]) {
                AudioCategory *category = [[AudioCategory alloc] init];
                [category setValuesForKeysWithDictionary:subDict];
                [_dataArray addObject:category];
            }
            
        } else {
            DLog(@"--请求数据失败--");
        }
        [self.activity stopAnimating];
        [self.collectionView reloadData];
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Register cell classes
    [self.collectionView registerClass:[AudioBookCategoryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self p_setupNavigationBar];
    [self p_setupActivity];
    
}


// 进度轮
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

#pragma mark -----navigationBar
- (void)p_setupNavigationBar
{
    self.navigationItem.title = @"分类";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:self action:@selector(searchAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
}

- (void)searchAction:(UIBarButtonItem *)sender
{
    DLog(@"搜索");
    SearchTableViewController *searchVC = [[SearchTableViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)backAction:(UIBarButtonItem *)sender
{
    DLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#warning Incomplete method implementation -- Return the number of items in the section
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudioBookCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    
    AudioCategory *cate = _dataArray[indexPath.item];
    
    cell.categoryTitleLabel.text = cate.title;
    [cell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:cate.coverPath] placeholderImage:nil];
    
    
    
    
    return cell;
}




#pragma mark ----UICollectionViewDelegateFlowLayout

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds .size.width - 20 * 2 - 30 * 3) / 4;
    CGFloat height = width * 1.5;


    return  CGSizeMake(width, height);
    
}

// 内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

// footer 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}


// 点击cell响应事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    AudioCategory *audioCate = _dataArray[indexPath.row];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    SuggestionCollectionViewController *suggestionVC = [[SuggestionCollectionViewController alloc] initWithCollectionViewLayout:flow];
    
    suggestionVC.categoryId = audioCate.categoryId;
    suggestionVC.categoryName = audioCate.title;
    
    [self.navigationController pushViewController:suggestionVC animated:YES];
    
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
