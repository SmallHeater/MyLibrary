//
//  SHScanVC.m
//  MyLibrary
//
//  Created by xianjunwang on 2018/4/16.
//  Copyright © 2018年 xianjunwang. All rights reserved.
//

#import "SHScanVC.h"
#import "SHQRCodeLibrary.h"

@interface SHScanVC ()

@property (nonatomic,strong) UILabel * resultLabel;
//扫一扫按钮
@property (nonatomic,strong) UIButton * scanBtn;
@end

@implementation SHScanVC

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.navTitle = @"扫一扫组件演示";
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.resultLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)scanBtnClicked{
    
    __weak SHScanVC * wekself = self;
    [SHQRCodeLibrary scanBlock:^(NSString * str) {
        
        NSString * result = [[NSString alloc] initWithFormat:@"扫描结果：%@",str];
        wekself.resultLabel.text = result;
    }];
}

#pragma mark  ----  懒加载
-(UILabel *)resultLabel{
    
    if (!_resultLabel) {
        
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 40)];
        _resultLabel.text = @"扫描结果：";
    }
    return _resultLabel;
}

-(UIButton *)scanBtn{
    
    if (!_scanBtn) {
        
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(10, 100, 60, 40);
        [_scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

@end
