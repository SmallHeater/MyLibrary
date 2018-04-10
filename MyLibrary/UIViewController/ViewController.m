//
//  ViewController.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/3/30.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import "SHUIImagePickerControllerDemoVC.h"
#import "ScaleViewController.h"
#import "WaterMarkViewController.h"
#import "SHAlertViewVC.h"

#define FIRSTLIBRARY @"相片选择器和大图浏览器"
#define SECONDLIBRARY @"刻度尺组件"
#define THREELIBRARY @"水印组件"
#define FOURTHLIBRARY @"AlertView管理组件"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//自定义导航条
@property (nonatomic,strong) UIView * shNavigationBar;
//标题label
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataArray;
@end

@implementation ViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.shNavigationBar];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //使用自定义导航条
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  代理

#pragma mark  ----  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str = self.dataArray[indexPath.row];
    if ([str isEqualToString:FIRSTLIBRARY]) {
        
        SHUIImagePickerControllerDemoVC * vc = [[SHUIImagePickerControllerDemoVC alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if([str isEqualToString:SECONDLIBRARY]){
        
        ScaleViewController * vc = [[ScaleViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ([str isEqualToString:THREELIBRARY]){
        
        WaterMarkViewController * vc = [[WaterMarkViewController alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ([str isEqualToString:FOURTHLIBRARY]){
        
        SHAlertViewVC * vc = [[SHAlertViewVC alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark  ----  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark  ----  懒加载

-(UIView *)shNavigationBar{
    
    if (!_shNavigationBar) {
        
        _shNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        _shNavigationBar.backgroundColor = Color_87BA4B;
        [_shNavigationBar addSubview:self.titleLabel];
    }
    return _shNavigationBar;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.shNavigationBar.frame), 44)];
        _titleLabel.textColor = Color_FFFFFF;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"组件Demo";
    }
    return _titleLabel;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

-(NSArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSArray alloc] initWithObjects:FIRSTLIBRARY,SECONDLIBRARY,THREELIBRARY,FOURTHLIBRARY, nil];
    }
    return _dataArray;
}

@end
