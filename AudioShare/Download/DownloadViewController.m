//
//  DownloadViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadView.h"
#import "DownloadedAlbumCell.h"
#import "DownloadingTableViewCell.h"
#import "AlbumTableViewController.h"

@interface DownloadViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)DownloadView *dloadView;
@property (nonatomic, strong)UISegmentedControl *segement;
@end

@implementation DownloadViewController

- (void)loadView
{
    self.dloadView = [[DownloadView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _dloadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // scrollView的代理
    self.dloadView.delegate = self;
    
    // tableView的datasource 和 delegate
    self.dloadView.dloadingView.dataSource = self;
    self.dloadView.dloadingView.delegate = self;
    self.dloadView.dloadedView.dataSource = self;
    self.dloadView.dloadedView.delegate = self;
    
    
    // regist cell

    [self.dloadView.dloadedView registerClass:[DownloadedAlbumCell class] forCellReuseIdentifier:@"dloadedAlbumCell"];
    
//    [self.dloadView.dloadingView registerClass:[DownloadingTableViewCell class] forCellReuseIdentifier:@"dloadingCell"];
    [self.dloadView.dloadingView registerNib:[UINib nibWithNibName:@"DownloadingTableViewCell" bundle:nil] forCellReuseIdentifier:@"dloadingCell"];
    
    
    [self p_navigationBar];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 轻扫手势
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dloadView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dloadView addGestureRecognizer:swipeRight];
    
    
}

- (void)p_navigationBar
{
    self.segement = [[UISegmentedControl alloc] initWithItems:@[@"下载完成", @"下载中"]];
    _segement.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 60, 30);
    _segement.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segement;
    [_segement addTarget:self action:@selector(segementAction:) forControlEvents:(UIControlEventValueChanged)];
    
}

// segementAction
- (void)segementAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.dloadView.contentOffset = CGPointMake(0, 0);
    } else {
        self.dloadView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    }
}


// 轻扫手势事件
- (void)swipeLeftAction:(UISwipeGestureRecognizer *)sender
{
    if (self.dloadView.contentOffset.x == 0) {
        self.dloadView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
        self.segement.selectedSegmentIndex = 1;
    }
    
}

- (void)swipeRightAction:(UISwipeGestureRecognizer *)sender
{
    if (self.dloadView.contentOffset.x > 0) {
        self.dloadView.contentOffset = CGPointZero;
        self.segement.selectedSegmentIndex = 0;
    }
    
}


#pragma mark ----UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dloadView.dloadedView) {
        DownloadedAlbumCell * dloadedCell = [tableView dequeueReusableCellWithIdentifier:@"dloadedAlbumCell" forIndexPath:indexPath];
        
        // 处理dloadedCell
        
        return dloadedCell;
        
        
        
    } else {
        DownloadingTableViewCell *dloadingCell = [tableView dequeueReusableCellWithIdentifier:@"dloadingCell" forIndexPath:indexPath];
        
        
        // 处理dloadingCell
        
        
        return dloadingCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

// 点击cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dloadView.dloadedView) {
        AlbumTableViewController *albumVC = [[AlbumTableViewController alloc] init];
        // 传值
        
        [self.navigationController pushViewController:albumVC animated:YES];
    } else {
        
        DLog(@"暂停下载/继续下载");
        
    }
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

@end
