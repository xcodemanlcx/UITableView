//
//  ViewController.m
//  UITableView
//
//  Created by hx_leichunxiang on 14-10-24.
//  Copyright (c) 2014年 lcx. All rights reserved.

//  功能描述: 1、btn作为tableview的表头/表尾 ，控制表的展开、收起。
//          2、CGRectZero的用法:让view不显示。

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    UIButton *btn;
    BOOL _isOpen;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createTableView];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 320, 40);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"收起/展开" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _tableView.tableHeaderView = btn;
    
    [self getTestData];
    [_tableView reloadData];
    
}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 40) style:UITableViewStylePlain];
//    _tableView.frame =CGRectZero;//CGRectZero用法
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor purpleColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
//    _tableView.bounces = NO;//禁止 滑动越界
    

    
}

//收起 或 展开
- (void)btnAction:(UIButton *)sender
{
    _isOpen = !_isOpen;
    if (_isOpen)
    {
        _tableView.frame = CGRectMake(0, 60, 320, 40 + 400);
        _tableView.tableHeaderView = nil;//原来view所在位置不置nil,表尾不能显示
        _tableView.tableFooterView = btn;
    }
    else
    {
        _tableView.frame = CGRectMake(0, 60, 320, 40);
        _tableView.tableFooterView = nil;
        _tableView.tableHeaderView = btn;
    }
}

#pragma mark - test data

- (void)getTestData
{
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 9; i++)
    {
        [_dataSource addObject:[NSString stringWithFormat:@"hello world == %d",i]];
    }

}

#pragma mark - table view data and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
