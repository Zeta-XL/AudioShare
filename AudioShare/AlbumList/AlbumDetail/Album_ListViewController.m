//
//  Album_ListViewController.m
//  AudioShare
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 DLZ. All rights reserved.
//

#import "Album_ListViewController.h"
#import "Album_ListView.h"
@interface Album_ListViewController () <Album_ListViewDelegate>

@property (nonatomic, strong)Album_ListView *albumListView;
@property (nonatomic, assign)CGFloat width;


@end

@implementation Album_ListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.albumListView setupContentSize];
}


-(void)loadView
{
    self.albumListView = [[Album_ListView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _albumListView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor grayColor];
    
    self.albumListView.delegate = self;
    self.navigationItem.title = @"专辑详情";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarAction:)];
    
    self.albumListView.titleLabel.text = [NSString stringWithFormat:@"专辑名: %@", _titleString];
    self.albumListView.writerLabel.text = _writerString;
    self.albumListView.discriptionLabel.text = _discriptionString;
    DLog(@"******%@", _discriptionString);
    
    self.width = [UIScreen mainScreen].bounds.size.width - 40;
    //Label自适应高度
//    CGRect temp = _albumListView.discriptionLabel.frame;
//    temp.size.height = [self p_HightWithString:_discriptionString width:_width];
//    _albumListView.discriptionLabel.frame = temp;
    
    
}

- (void)leftBarAction : (UIBarButtonItem *)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
//labe自适应高度
- (CGFloat)p_HightWithString:(NSString*)aString width:(CGFloat)awidth
{
    CGRect r = [aString boundingRectWithSize:CGSizeMake(awidth, 20000)options:(NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}context:nil];
    return r.size.height;
}

- (CGFloat)tellTextHeight
{
    return [self p_HightWithString:_discriptionString width:_width];
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
