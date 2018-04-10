//
//  JHBusAppleBaseViewController.m
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/7.
//  Copyright © 2017年 pk. All rights reserved.
//

#import "SHBaseNavViewController.h"
#import "SHNavigationBar.h"

@interface SHBaseNavViewController ()

@end

@implementation SHBaseNavViewController


#pragma mark  ----  生命周期函数


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navigationBar];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)backBtnClicked:(UIButton *)btn{

    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark  ----  SET
-(void)setNavTitle:(NSString *)navTitle{

    _navTitle = navTitle;
    self.navigationBar.navTitle = navTitle;
}

#pragma mark  ----  懒加载
-(SHNavigationBar *)navigationBar{

    if (!_navigationBar) {
        
        _navigationBar = [[SHNavigationBar alloc] initWithTitle:@"" andBackbtnAction:@selector(backBtnClicked:) andBackBtnTarget:self];
    }
    return _navigationBar;
}
#pragma mark  ----  懒加载

-(UIView *)noInternetBGView{
    
    if (!_noInternetBGView) {
        
        _noInternetBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    }
    return _noInternetBGView;
}


@end
