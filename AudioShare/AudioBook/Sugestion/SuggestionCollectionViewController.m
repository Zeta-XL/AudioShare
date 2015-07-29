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

@interface SuggestionCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@end

@implementation SuggestionCollectionViewController

static NSString * const reuseIdentifier = @"SuggestionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[SuggestionCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Register headerView
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
    [self p_navigationBar];
   
}

#pragma mark ----navigationBar
- (void)p_navigationBar
{
    self.navigationItem.title = @"推荐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"其它分类" style:(UIBarButtonItemStyleDone) target:self action:@selector(moreAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction:)];
    
    
}

- (void)moreAction:(UIBarButtonSystemItem *)sender
{
    DLog(@"打开更多分类");
    
    SubListViewController *subListVC = [[SubListViewController alloc] init];
    // 传值;
    
    
    
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
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuggestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.tracksCountsLabel.text = @"共40集";
    cell.albumTitleLabel.text = @"无限****无无线";
    
    return cell;
}

// 点击cell响应事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@", indexPath);
    
    AlbumTableViewController *albumVC = [[AlbumTableViewController alloc] init];
    
    [self.navigationController pushViewController:albumVC animated:YES];
}

#pragma mark ----UICollectionViewDelegateFlowLayout

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds .size.width - 10 * 2 - 10 * 2) / 3;
    CGFloat height = width * 1.75;
    
    
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
    if (section == 4) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
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
    return CGSizeMake(0, 20);
}

// header 的view
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
 
    HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    headerView.subCategoryLabel.text = @"恐怖悬疑";
    
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
