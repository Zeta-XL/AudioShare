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

@interface AudioBookCategoryCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@end

@implementation AudioBookCategoryCollectionViewController

static NSString * const reuseIdentifier = @"CategoryCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[AudioBookCategoryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self p_setupNavigationBar];
    
    
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
    return 23;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudioBookCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    
    cell.categoryTitleLabel.text = @"测试数据";
    DLog(@"%@", NSStringFromCGRect(cell.frame));
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
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    SuggestionCollectionViewController *suggestionVC = [[SuggestionCollectionViewController alloc] initWithCollectionViewLayout:flow];
    
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
