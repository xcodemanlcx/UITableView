//
//  ViewController1.m
//  UITableView
//
//  Created by hx_leichunxiang on 14-10-24.
//  Copyright (c) 2014年 lcx. All rights reserved.
//  功能：1.1 tableview的基本属性与相关代理方法。

/*
标记，与编辑模式：移动、删除、增加插入。

 一、编辑模式==YES，标记不显示。
 1、移动：
 1.1 打开编辑模式：[_tableView setEditing:YES animated:YES];默认为删除style，且可以移动。
 1.2 代理方法设置：UITableViewCellEditingStyle 为UITableViewCellEditingStyleNone；这样删除模式不显示。
 1.3 实现代理方法move to（会出现右边三横按钮），并更新数据源，并reload。
 
 2、删除：
 2.1 打开编辑模式：[_tableView setEditing:YES animated:YES];默认为删除style，且可以移动。
 2.2 实现代理方法commitEditingStyle，并在此方法中实现更新数据源、tableView的deleteRowsAtIndexPaths方法。
 
 
 3、增加，插入
 3.1 打开编辑模式：[_tableView setEditing:YES animated:YES];默认为删除style，且可以移动。
 3.2 代理方法设置编辑模式：UITableViewCellEditingStyle 为UITableViewCellEditingStyleInsert
 3.3 实现代理方法commitEditingStyle，并在此方法中实现更新数据源、tableView的insertRowsAtIndexPaths方法。

 二、标记：
 1.1 编辑模式==NO,标记显示。
 1.2 cell.accessoryType系统标记，cell.accessoryType；cell.accessoryView自定义标记。
 */
#import "ViewController1.h"

@interface ViewController1 ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    UITableViewCellEditingStyle _style;
    NSInteger _times;
}
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(refresh)];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(delete)];
    UIBarButtonItem *insert = [[UIBarButtonItem alloc] initWithTitle:@"insert" style:UIBarButtonItemStylePlain target:self action:@selector(insert)];
    UIBarButtonItem *none = [[UIBarButtonItem alloc] initWithTitle:@"none" style:UIBarButtonItemStylePlain target:self action:@selector(none)];
    self.navigationItem.rightBarButtonItems = @[refresh,delete,insert,none];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor purpleColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //1 系统分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//1-1 设置cell分割线有无
    _tableView.separatorColor = [UIColor orangeColor];//1-2 设置分割线颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);//距离左边间距
    }
    
    _dataSource =[NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++)
    {
        [_dataSource addObject:[NSString stringWithFormat:@"hello == %i",i]];
    }

    
//    [_tableView setEditing:YES animated:YES];//默认是删除模式。
}

//刷新
- (void)refresh
{
    [_tableView reloadData];
}

- (void)delete
{
    _style = UITableViewCellEditingStyleDelete;
    [_tableView reloadData];
}

- (void)insert
{
    _style = UITableViewCellEditingStyleInsert;
    [_tableView reloadData];

}

- (void)none
{
    _style = UITableViewCellEditingStyleNone;
    [_tableView reloadData];

}


#pragma mark - tableview data and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        v.backgroundColor = [UIColor redColor];
        cell.accessoryView = v;//cell右边自定义图标标记
        cell.imageView.image = [UIImage imageNamed:@"person_icon"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;//有自定义标记，系统标记不显示。
    }
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;

}

//cell的编辑样式：移动、删除、无。
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        [_dataSource insertObject:[NSString stringWithFormat:@"插入%d",indexPath.row] atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        return;
    }
    return;
}

//1 移动：move to
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

    [_dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [_tableView reloadData];
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
